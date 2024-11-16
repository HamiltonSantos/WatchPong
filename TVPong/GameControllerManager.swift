//
//  GameControllerManager.swift
//  TVCommunication
//
//  Created by Gabriel Caron  on 02/06/16.
//  Copyright © 2016 Gabriel Caron. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class GameControllerManager: NSObject, GCDAsyncSocketDelegate, NetServiceDelegate {

    //MARK: Properties
    var service: NetService!
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
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated))
        clientSockets = NSMutableArray()

        //Start Listening
        guard (try? self.socket.accept(onPort: 0)) != nil else {
            print("Unable to create socket")
            return
        }

        //Initialize Service
        let localPort = self.socket.localPort
        service = NetService(domain: "local", type: "\(serviceType).\(serviceProtocol)", name: "Side&Spin", port: Int32(localPort))
        service.delegate = self
        service.publish()
    }

    //MARK: NSNetService Delegates

    func netServiceDidPublish(_ sender: NetService) {

        print("Bonjour service published: domain\(service.domain) type:\(service.type) name:\(service.name) port:\(service.port)")
    }

    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("Failed to publish service: domain\(service.domain) type:\(service.type) name:\(service.name) port:\(service.port)")
        print(errorDict)
    }

    //MARK: Socket Delegates

    func socket(_ sock: GCDAsyncSocket!, didAcceptNewSocket newSocket: GCDAsyncSocket!) {
        print("Accepted new socket from \(newSocket.connectedHost) \(newSocket.connectedPort)")
        newSocket.delegate = self
        clientSockets.add(newSocket)
        newSocket.readData(toLength: UInt(MemoryLayout<UInt64>.size), withTimeout: -1, tag: 0)

        //OBS.: talvez seja preciso mudar a id
        var id: Int = clientSockets.count-1
        let data = Data(bytes: UnsafeRawPointer(&id), count: sizeof(Int))
        newSocket.write(data, withTimeout: -1, tag: 0)
        delegate?.playerDidConnect(id)
    }

    func socketDidDisconnect(_ sock: GCDAsyncSocket!, withError err: NSError!) {

        print("Socket disconnected: host - \(sock.connectedHost) port - \(sock.connectedPort)")
        guard let so = sock else {print("Não tem socket"); return}
        for i in 0..<clientSockets.count {

            //Crasha aqui ao desconectar
            let s = clientSockets.object(at: i) as! GCDAsyncSocket
            if so == s {
                clientSockets.remove(sock)
                delegate?.playerDidDisconnect(i)
            }
        }
    }

    func socket(_ sock: GCDAsyncSocket!, didRead data: Data!, withTag tag: Int) {

        //TODO - separar o didReceiveData e o didReceiveCommand
        let playerIdData = data.subdata(in: NSRange(location: 0, length: sizeof(Int16)))
        let playerData = data.subdata(in: NSRange(location: sizeof(Int16), length: data.count - sizeof(Int16)))

        var id: Int = 0
        (playerIdData as NSData).getBytes(&id, length: sizeof(Int))
        var commandInt: Int = 0
        (playerData as NSData).getBytes(&commandInt, length: sizeof(Int))
        print("Player id is: \(id)")
        print("Player command Int is: \(commandInt)")

        DispatchQueue.main.async {
            if commandInt >= CommandType.data.hashValue {
                self.delegate?.didReceiveData(fromPlayer: id, data: data)
            } else {
                self.delegate?.didReceiveCommand(fromPlayer: id, command: CommandType(rawValue: commandInt)!)
            }
        }
        sock.readData(toLength: UInt(data.count), withTimeout: -1, tag: 0)
    }

    //MARK: Communication methods

    func sendDataToPlayer(_ player: Int, data: Data) {

        let sock = clientSockets.object(at: player) as! GCDAsyncSocket
        sock.write(data, withTimeout: -1, tag: 0)
    }

    func sendDataToAllPlayers(_ data: Data) {

        if clientSockets.count == 0 {return}

        for i in 0..<clientSockets.count {
            sendDataToPlayer(i, data: data)
        }
    }

    func sendCommandToPlayer(_ player: Int, command: CommandType) {
        var commandInt = command.hashValue
        let data = Data(bytes: UnsafePointer<UInt8>(&commandInt), count: sizeof(Int64))
        sendDataToPlayer(player, data: data)
    }

    func sendCommandToAllPlayers(_ command: CommandType) {
        var commandInt = command.hashValue
        let data = Data(bytes: UnsafePointer<UInt8>(&commandInt), count: sizeof(Int64))
        sendDataToAllPlayers(data)
    }
}

public protocol GameControllerManagerDelegate {

    func didReceiveData(fromPlayer player: Int, data: Data)
    func didReceiveCommand(fromPlayer player: Int, command: CommandType)
    func playerDidConnect(_ player: Int)
    func playerDidDisconnect(_ player: Int)
    func didSendData(toPlayer player: GCDAsyncSocket)
    func didSendData(toAllPlayers players: NSMutableArray)
}

public enum CommandType: Int {
    case up, down, left, right, action1, action2, gameInit, data
}
