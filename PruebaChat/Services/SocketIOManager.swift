//
//  SocketIOManager.swift
//  PruebaChat
//
//  Created by Brayam Alberto Mora Arias on 13/05/20.
//  Copyright © 2020 Brayam Alberto Mora Arias. All rights reserved.
//

import SocketIO

class SocketIOManager {
    
    static let sharedInstance = SocketIOManager()
    let manager = SocketManager(socketURL: URL(string: "https://socket-server-rcflechas.herokuapp.com/")!, config: [.log(true), .compress])
    var socket: SocketIOClient
    
    private init() {
        self.socket = self.manager.defaultSocket
        
        self.socket.on(clientEvent: .connect) {(data, ack) in
            print("socket connected")
        }
        
        self.socket.on(clientEvent: .disconnect) {(data, ack) in
            print("socket disconnect")
        }
        
        self.socket.on(clientEvent: .error) {(data, ack) in
            print("socket error")
        }
    }
    
    func connectSocket() {
        self.socket.connect()
    }
    
    func disconnectSocket() {
        self.socket.off(clientEvent: .connect)
        self.socket.off(clientEvent: .error)
        self.socket.off(clientEvent: .disconnect)
        self.socket.off(clientEvent: SocketClientEvent.reconnect)
        self.socket.removeAllHandlers()
        self.socket.emit("disconnect")
        self.socket.disconnect()
        print("socket Disconnected")
    }
    
    func checkConnection() -> Bool {
        if self.socket.status == .connected {
            return true
        }
        return false
    }
    
    func addMeToUserList(_ username: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]) -> Void) {
        
        self.socket.emit("add user", username)
        
        self.socket.on("user list") { response, ack in
            completionHandler((response as! [[String: AnyObject]]))
        }
        
        self.listenForOtherMessages()
    }
    
    func sendMessage(_ data: String) {
        //transform data to JSON
        self.socket.emit("send_mensaje", data)
    }
    
    func listenForOtherMessages() {
        
        socket.on("user joined") { (response, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: response as! [[String: AnyObject]])
        }
        
        socket.on("user left") { (response, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasDesconnectedNotification"), object: response as! [[String: AnyObject]])
        }
        
        socket.on("new_message") { (response, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newMessageNotification"), object: response as! [[String: AnyObject]])
        }
    }
}
