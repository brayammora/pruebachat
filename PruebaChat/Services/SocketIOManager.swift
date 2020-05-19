//
//  SocketIOManager.swift
//  PruebaChat
//
//  Created by Brayam Alberto Mora Arias on 13/05/20.
//  Copyright © 2020 Brayam Alberto Mora Arias. All rights reserved.
//

import SocketIO

class SocketIOManager: NSObject {
    
    static let manager = SocketManager(socketURL: URL(string: "https://socket-server-rcflechas.herokuapp.com/")!, config: [.log(true), .compress])
    var socket: SocketIOClient
    
    override init() {
        self.socket = SocketIOManager.manager.defaultSocket
        
        socket.on("test") { dataArray, ack in
            print(dataArray)
        }
    }
    
    func establishConnection() {
        self.socket.connect()
    }
    
    func closeConnection() {
        self.socket.disconnect()
    }
}


/*
 
 class SocketHelper {
 
 static let shared = SocketHelper()
 var socket: SocketIOClient!
 
 let manager = SocketManager(socketURL: URL(string: "https://socket-server-rcflechas.herokuapp.com/")!, config: [.log(true), .compress])
 
 private init() {
 socket = manager.defaultSocket
 }
 
 func connectSocket(completion: @escaping(Bool) -> () ) {
 disconnectSocket()
 socket.on(clientEvent: .connect) {[weak self] (data, ack) in
 print("socket connected")
 self?.socket.removeAllHandlers()
 completion(true)
 }
 socket.connect()
 }
 
 func disconnectSocket() {
 socket.removeAllHandlers()
 socket.disconnect()
 print("socket Disconnected")
 }
 
 func checkConnection() -> Bool {
 if socket.manager?.status == .connected {
 return true
 }
 return false
 
 }
 
 enum Events {
 
 case search
 
 var emitterName: String {
 switch self {
 case .searchTags:
 return "emt_search_tags"
 }
 }
 
 var listnerName: String {
 switch self {
 case .search:
 return "filtered_tags"
 }
 }
 
 func emit(params: [String : Any]) {
 SocketHelper.shared.socket.emit(emitterName, params)
 }
 
 func listen(completion: @escaping (Any) -> Void) {
 SocketHelper.shared.socket.on(listnerName) { (response, emitter) in
 completion(response)
 }
 }
 
 func off() {
 SocketHelper.shared.socket.off(listnerName)
 }
 }
 }
 */
