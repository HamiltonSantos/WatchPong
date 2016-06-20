//
//  GameControllerManager.swift
//  TVCommunication
//
//  Created by Gabriel Caron  on 02/06/16.
//  Copyright © 2016 Gabriel Caron. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class GameControllerManager: NSObject, GCDAsyncSocketDelegate, NSNetServiceDelegate {

    //MARK: Properties
    var service: NSNetService!
    var socket: GCDAsyncSocket!
    var clientSockets: NSMutableArray!
    var delegate: GameControllerManagerDelegate?
    let serviceType = "_sidespin"
    let serviceProtocol = "_tcp"

    override init() {
        super.init()
        startBroadcast()
    }

    //MARK: Configuration

    func startBroadcast() {
        //Initialize socket
        socket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
        clientSockets = NSMutableArray()

        //Start Listening
        guard (try? self.socket.acceptOnPort(0)) != nil else {
            print("Unable to create socket")
            return
        }

        //Initialize Service
        let localPort = self.socket.localPort
        service = NSNetService(domain: "local", type: "\(serviceType).\(serviceProtocol)", name: "Side&Spin", port: Int32(localPort))
        service.delegate = self
        service.publish()
    }

    //MARK: NSNetService Delegates

    func netServiceDidPublish(sender: NSNetService) {

        print("Bonjour service published: domain\(service.domain) type:\(service.type) name:\(service.name) port:\(service.port)")
    }

    func netService(sender: NSNetService, didNotPublish errorDict: [String : NSNumber]) {
        print("Failed to publish service: domain\(service.domain) type:\(service.type) name:\(service.name) port:\(service.port)")
        print(errorDict)
    }

    //MARK: Socket Delegates

    func socket(sock: GCDAsyncSocket!, didAcceptNewSocket newSocket: GCDAsyncSocket!) {
        print("Accepted new socket from \(newSocket.connectedHost) \(newSocket.connectedPort)")
        newSocket.delegate = self
        clientSockets.addObject(newSocket)
        newSocket.readDataToLength(UInt(sizeof(UInt64)), withTimeout: -1, tag: 0)

        //OBS.: talvez seja preciso mudar a id
        var id: Int = clientSockets.count-1
        let data = NSData(bytes: &id, length: sizeof(Int))
        newSocket.writeData(data, withTimeout: -1, tag: 0)
        delegate?.playerDidConnect(id)
    }

    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {

        print("Socket disconnected: host - \(sock.connectedHost) port - \(sock.connectedPort)")
        guard let so = sock else {print("Não tem socket"); return}
        for i in 0..<clientSockets.count {

            //Crasha aqui ao desconectar
            let s = clientSockets.objectAtIndex(i) as! GCDAsyncSocket
            if so == s {
                clientSockets.removeObject(sock)
                delegate?.playerDidDisconnect(i)
            }
        }
    }

    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {

        //TODO - separar o didReceiveData e o didReceiveCommand
        let playerIdData = data.subdataWithRange(NSRange(location: 0, length: sizeof(Int16)))
        let playerData = data.subdataWithRange(NSRange(location: sizeof(Int16), length: data.length - sizeof(Int16)))

        var id: Int = 0
        playerIdData.getBytes(&id, length: sizeof(Int))
        var commandInt: Int = 0
        playerData.getBytes(&commandInt, length: sizeof(Int))
        print("Player id is: \(id)")
        print("Player command Int is: \(commandInt)")

        dispatch_async(dispatch_get_main_queue()) {
            if commandInt >= CommandType.Data.hashValue {
                self.delegate?.didReceiveData(fromPlayer: id, data: data)
            } else {
                self.delegate?.didReceiveCommand(fromPlayer: id, command: CommandType(rawValue: commandInt)!)
            }
        }
        sock.readDataToLength(UInt(data.length), withTimeout: -1, tag: 0)
    }

    //MARK: Communication methods

    func sendDataToPlayer(player: Int, data: NSData) {

        let sock = clientSockets.objectAtIndex(player) as! GCDAsyncSocket
        sock.writeData(data, withTimeout: -1, tag: 0)
    }

    func sendDataToAllPlayers(data: NSData) {

        if clientSockets.count == 0 {return}

        for i in 0..<clientSockets.count {
            sendDataToPlayer(i, data: data)
        }
    }

    func sendCommandToPlayer(player: Int, command: CommandType) {
        var commandInt = command.hashValue
        let data = NSData(bytes: &commandInt, length: sizeof(Int64))
        sendDataToPlayer(player, data: data)
    }

    func sendCommandToAllPlayers(command: CommandType) {
        var commandInt = command.hashValue
        let data = NSData(bytes: &commandInt, length: sizeof(Int64))
        sendDataToAllPlayers(data)
    }
}

public protocol GameControllerManagerDelegate: NSObjectProtocol {

    func didReceiveData(fromPlayer player: Int, data: NSData)
    func didReceiveCommand(fromPlayer player: Int, command: CommandType)
    func playerDidConnect(player: Int)
    func playerDidDisconnect(player: Int)
//    func didSendData(toPlayer player: GCDAsyncSocket)
//    func didSendData(toAllPlayers players: NSMutableArray)
}

public enum CommandType: Int {
    case Up, Down, Left, Right, Action1, Action2, GameInit, Data
}
