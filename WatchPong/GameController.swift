//
//  GameController.swift
//  TVCommunication
//
//  Created by Gabriel Caron  on 02/06/16.
//  Copyright © 2016 Gabriel Caron. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class GameController: NSObject, NetServiceBrowserDelegate, NetServiceDelegate, GCDAsyncSocketDelegate {
 
    //MARK: Properties
    fileprivate var socket: GCDAsyncSocket!
    var serviceBrowser: NetServiceBrowser!
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
        serviceBrowser = NetServiceBrowser()
        serviceBrowser.delegate = self
        serviceBrowser.searchForServices(ofType: "\(serviceType).\(serviceProtocol)", inDomain: "local")
    }
    
    func stopBrowsing() {
        serviceBrowser.stop()
        serviceBrowser.delegate = nil
        serviceBrowser = nil
    }
    
    //MARK: NSNetServiceBrowser delegates
    //TODO - fazer tentativas sucessivas de conexão
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        services.add(service)
        
        if !moreComing {
            services.sort(using: [NSSortDescriptor(key: "name", ascending: true)])
            if !autoConnect { delegate?.didFindGames(services) }
            else {
                if services.count != 0 {
                    let game = services.firstObject as! NetService
                    game.delegate = self
                    game.resolve(withTimeout: 30)
                }
            }
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        self.services.remove(service)
        
        if !moreComing { delegate?.didRemoveGame(service) }
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        stopBrowsing()
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        stopBrowsing()
    }
    
    //MARK: Communication methods
    //Obs.: Tamanho do corpo da mensagem limitado à 6 bytes, e 2 para o cabeçalho.
    func sendDataToTV(_ data: Data) {
        guard let skt = socket else {print("Socket doesn't exist"); return}
        var playerID = self.ID
        let dataChunk = data.subdata(in: NSRange(location: 0, length: sizeof(Int64)-sizeof(Int16)))
        let packetData = NSMutableData(bytes: &playerID, length: MemoryLayout<Int16>.size)
        packetData.append(dataChunk)
        skt.write(packetData as Data!, withTimeout: -1, tag: 0)
    }
    
    func sendStringToTV(_ string: String, encoding: String.Encoding) {
        let data = string.data(using: encoding)
        guard let dt = data else {print("Data doesn't exist"); return}
        sendDataToTV(dt)
    }
    
    func sendCommandToTV(_ command: CommandType) {
        var commandInt = command.hashValue
        let data = Data(bytes: UnsafePointer<UInt8>(&commandInt), count: sizeof(Int64))
        sendDataToTV(data)
    }
    
    /* 
     Chama a função connectToGame se inicializar o GameController com autoConnect = false
     Dessa forma, deve-se obter o array de services/games e colocar em uma tableView. Quando selecionar a cell, chama esta função para realizar a conexão.
     */
    func connectToGame(_ game: NetService) {
        if autoConnect {return}
        game.delegate = self
        game.resolve(withTimeout: 30)
    }
    
    //MARK: NSNetService delegates
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        sender.delegate = nil
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        if connectWithServer(sender) {
            print("Did connect with server: domain:\(sender.domain) type:\(sender.type) name:\(sender.name) port:\(sender.port)")
        } else {
            print("Unable to connect with server: domain:\(sender.domain) type:\(sender.type) name:\(sender.name) port:\(sender.port)")
        }
    }
    
    //MARK: Connect to server function
    
    func connectWithServer(_ service: NetService) -> Bool {
        
        var isConnected : Bool = false
        let addresses = service.addresses
        
        if socket == nil || !socket.isConnected {
            socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
            
            while (!isConnected && (addresses?.count != 0)){
                let address = addresses?.first
                
                guard (try? socket.connect(toAddress: address)) != nil else {
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
    
    func socket(_ sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("Socket did connect to host:\(host) port:\(port)")
        sock.readData(toLength: UInt(MemoryLayout<UInt64>.size), withTimeout: -1, tag: 0)
        guard let del = delegate?.didConnect else {print("didConnect doesn't exist on delegate"); return}
        del(host)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket!, withError err: NSError!) {
        print("Socket did disconnect: host:\(sock.connectedHost) port:\(sock.connectedPort)")
        
        socket.delegate = nil
        socket = nil
    }
    
    func socket(_ sock: GCDAsyncSocket!, didRead data: Data!, withTag tag: Int) {
        guard let hostName = sock.connectedHost else {print("Host doesn't exist"); return}

        if config {
            var id : Int = 0
            data.copyBytes(to: &UInt8(id), count: MemoryLayout<Int>.size)
            print("My id is: \(id)")
            socket.readData(toLength: UInt(MemoryLayout<UInt64>.size), withTimeout: -1, tag: 0)
            self.ID = id
            config = false
            guard let del = delegate?.didReceiveData else {print("didReceiveData isn't implemented"); return}
            del(hostName, data)
            sock.readData(toLength: UInt(data.count), withTimeout: -1, tag: 0)
        }
        else {
            var commandInt : Int = 0
            data.copyBytes(to: &UInt8(commandInt), count: MemoryLayout<Int>.size)
            print("Command Int from TV is: \(commandInt)")
            if commandInt >= CommandType.data.hashValue {
                self.delegate?.didReceiveData(fromTV: hostName, data: data)
            } else {
                self.delegate?.didReceiveCommand(fromTV: hostName, command: CommandType(rawValue: commandInt)!)
            }
            sock.readData(toLength: UInt(data.count), withTimeout: -1, tag: 0)
        }
    }
}

public protocol GameControllerDelegate: NSObjectProtocol {

    func didFindGames(_ games: NSMutableArray!)
    
    func didRemoveGame(_ game: NetService)
    
    func didConnect(withTV TV: String)
    
    func didReceiveData(fromTV TV: String, data: Data)
    
    func didReceiveCommand(fromTV TV: String, command: CommandType)
    
    func didSendData(toTV socket: String)
    
    func didSendCommand(toTV command: CommandType)
}
