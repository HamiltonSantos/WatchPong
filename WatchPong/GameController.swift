//
//  GameController.swift
//  TVCommunication
//
//  Created by Gabriel Caron  on 02/06/16.
//  Copyright © 2016 Gabriel Caron. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class GameController: NSObject, NSNetServiceBrowserDelegate, NSNetServiceDelegate, GCDAsyncSocketDelegate {
 
    //MARK: Properties
    private var socket: GCDAsyncSocket!
    var serviceBrowser: NSNetServiceBrowser!
    var services: NSMutableArray!
    var delegate: GameControllerDelegate?
    var autoConnect: Bool = true
    var ID: Int = 0
    let serviceType = "_sidespin"
    let serviceProtocol = "_tcp"
    var config = true
    
    //MARK: Constructor
    
    override init() {
        super.init()
        startBrowsing()
    }
    
    convenience init(autoConnect: Bool) {
        self.init()
        self.autoConnect = autoConnect
    }
    
    //MARK: Browse methods
    
    func startBrowsing() {
        
        if services != nil {
            services.removeAllObjects()
        } else {
            services = NSMutableArray()
        }
        serviceBrowser = NSNetServiceBrowser()
        serviceBrowser.delegate = self
        serviceBrowser.searchForServicesOfType("\(serviceType).\(serviceProtocol)", inDomain: "local")
    }
    
    func stopBrowsing() {
        serviceBrowser.stop()
        serviceBrowser.delegate = nil
        serviceBrowser = nil
    }
    
    //MARK: NSNetServiceBrowser delegates
    //TODO - fazer tentativas sucessivas de conexão
    func netServiceBrowser(browser: NSNetServiceBrowser, didFindService service: NSNetService, moreComing: Bool) {
        services.addObject(service)
        
        if !moreComing {
            services.sortUsingDescriptors([NSSortDescriptor(key: "name", ascending: true)])
            if !autoConnect { delegate?.didFindGames(services) }
            else {
                if services.count != 0 {
                    let game = services.firstObject as! NSNetService
                    game.delegate = self
                    game.resolveWithTimeout(30)
                }
            }
        }
    }
    
    func netServiceBrowser(browser: NSNetServiceBrowser, didRemoveService service: NSNetService, moreComing: Bool) {
        self.services.removeObject(service)
        
        if !moreComing { delegate?.didRemoveGame(service) }
    }
    
    func netServiceBrowserDidStopSearch(browser: NSNetServiceBrowser) {
        stopBrowsing()
    }
    
    func netServiceBrowser(browser: NSNetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        stopBrowsing()
    }
    
    //MARK: Communication methods
    //Obs.: Tamanho do corpo da mensagem limitado à 6 bytes, e 2 para o cabeçalho.
    func sendDataToTV(data: NSData) {
        guard let skt = socket else {print("Socket doesn't exist"); return}
        var playerID = self.ID
        let dataChunk = data.subdataWithRange(NSRange(location: 0, length: sizeof(Int64)-sizeof(Int16)))
        let packetData = NSMutableData(bytes: &playerID, length: sizeof(Int16))
        packetData.appendData(dataChunk)
        skt.writeData(packetData, withTimeout: -1, tag: 0)
    }
    
    func sendStringToTV(string: String, encoding: NSStringEncoding) {
        let data = string.dataUsingEncoding(encoding)
        guard let dt = data else {print("Data doesn't exist"); return}
        sendDataToTV(dt)
    }
    
    func sendCommandToTV(command: CommandType) {
        var commandInt = command.hashValue
        let data = NSData(bytes: &commandInt, length: sizeof(Int64))
        sendDataToTV(data)
    }
    
    /* 
     Chama a função connectToGame se inicializar o GameController com autoConnect = false
     Dessa forma, deve-se obter o array de services/games e colocar em uma tableView. Quando selecionar a cell, chama esta função para realizar a conexão.
     */
    func connectToGame(game: NSNetService) {
        if autoConnect {return}
        game.delegate = self
        game.resolveWithTimeout(30)
    }
    
    //MARK: NSNetService delegates
    
    func netService(sender: NSNetService, didNotResolve errorDict: [String : NSNumber]) {
        sender.delegate = nil
    }
    
    func netServiceDidResolveAddress(sender: NSNetService) {
        if connectWithServer(sender) {
            print("Did connect with server: domain:\(sender.domain) type:\(sender.type) name:\(sender.name) port:\(sender.port)")
        } else {
            print("Unable to connect with server: domain:\(sender.domain) type:\(sender.type) name:\(sender.name) port:\(sender.port)")
        }
    }
    
    //MARK: Connect to server function
    
    func connectWithServer(service: NSNetService) -> Bool {
        
        var isConnected : Bool = false
        let addresses = service.addresses
        
        if socket == nil || !socket.isConnected {
            socket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
            
            while (!isConnected && (addresses?.count != 0)){
                let address = addresses?.first
                
                guard (try? socket.connectToAddress(address)) != nil else {
                    assert(false, "Unable to connect to address")
                    break
                }
                isConnected = true
            }
        } else {
            isConnected = socket.isConnected
        }
        return isConnected
    }
    
    //MARK: Socket delegates
    
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("Socket did connect to host:\(host) port:\(port)")
        sock.readDataToLength(UInt(sizeof(UInt64)), withTimeout: -1, tag: 0)
        guard let del = delegate?.didConnect else {print("didConnect doesn't exist on delegate"); return}
        del(withTV: host)
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        print("Socket did disconnect: host:\(sock.connectedHost) port:\(sock.connectedPort)")
        
        socket.delegate = nil
        socket = nil
    }
    
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        guard let hostName = sock.connectedHost else {print("Host doesn't exist"); return}

        if config {
            var id : Int = 0
            data.getBytes(&id, length: sizeof(Int))
            print("My id is: \(id)")
            socket.readDataToLength(UInt(sizeof(UInt64)), withTimeout: -1, tag: 0)
            self.ID = id
            config = false
            guard let del = delegate?.didReceiveData else {print("didReceiveData isn't implemented"); return}
            del(fromTV: hostName, data: data)
            sock.readDataToLength(UInt(data.length), withTimeout: -1, tag: 0)
        }
        else {
            var commandInt : Int = 0
            data.getBytes(&commandInt, length: sizeof(Int))
            print("Command Int from TV is: \(commandInt)")
            if commandInt >= CommandType.Data.hashValue {
                self.delegate?.didReceiveData(fromTV: hostName, data: data)
            } else {
                self.delegate?.didReceiveCommand(fromTV: hostName, command: CommandType(rawValue: commandInt)!)
            }
            sock.readDataToLength(UInt(data.length), withTimeout: -1, tag: 0)
        }
    }
}

public protocol GameControllerDelegate: NSObjectProtocol {

    func didFindGames(games: NSMutableArray!)
    
    func didRemoveGame(game: NSNetService)
    
    func didConnect(withTV TV: String)
    
    func didReceiveData(fromTV TV: String, data: NSData)
    
    func didReceiveCommand(fromTV TV: String, command: CommandType)
    
//    func didSendData(toTV socket: String)
    
//    func didSendCommand(toTV command: CommandType)
}