//
//  ChatsViewController.swift
//  PruebaChat
//
//  Created by Brayam Alberto Mora Arias on 12/05/20.
//  Copyright © 2020 Brayam Alberto Mora Arias. All rights reserved.
//

import UIKit
import SocketIO

class ChatsViewController: UIViewController {

    var username = String()
    var id = String()
    
    //private var messagesList = [[String: AnyObject]]()
    private var messagesList = [Chats]()
    
    @IBOutlet weak var tableView: UITableView!

    let manager = SocketManager(socketURL: URL(string: "https://socket-server-rcflechas.herokuapp.com/")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.ConnectToSocket()
        self.messagesList = [Chats]()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func ConnectToSocket() {
        
        self.socket = self.manager.defaultSocket
        
        self.socket.on(clientEvent: .connect) {data, ack in
            //self.present(Utilities.setAlert(msg: "Socket Connected"), animated: true, completion: nil)
            self.socket.emit("add user", self.username)
        }
        
        self.socket.on(clientEvent: .error) { (data, eck) in
            //self.present(Utilities.setAlert(msg: "Socket Error"), animated: true, completion: nil)
        }
        
        self.socket.on(clientEvent: .disconnect) { (data, eck) in
            self.present(Utilities.setAlert(msg: "Socket Disconnect"), animated: true, completion: nil)
        }
        
        self.socket.on(clientEvent: SocketClientEvent.reconnect) { (data, eck) in
            //self.present(Utilities.setAlert(msg: "Socket Reconnect"), animated: true, completion: nil)
        }
        
        self.socket.on("user list") { response, ack in
            //self.present(Utilities.setAlert(msg: "user list"), animated: true, completion: nil)
            
            let userList =  response as! [[String: AnyObject]]
            let users = self.getValuesFromList(list: userList[0])
            self.messagesList = self.removeMe(users: users)
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
        
        self.socket.on("user joined") { response, ack in
            //self.present(Utilities.setAlert(msg: "user joined"), animated: true, completion: nil)
            
            let userList =  response as! [[String: AnyObject]]
            var user: Chats = Chats()
            for (key, value) in userList[0] {
                switch key {
                    case "id":
                        user.idChat = value.description
                    case "username":
                        user.nameChat = value.description
                    default:
                        print("")
                }
            }
            self.messagesList.append(user)
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
        
        self.socket.on("user left") { response, ack in
            //self.present(Utilities.setAlert(msg: "user joined"), animated: true, completion: nil)
            
            let userList =  response as! [[String: AnyObject]]
            var userToRemove = String()
            
            for (key, value) in userList[0] {
                if(key == "username") {
                    userToRemove = value.description
                }
            }
            
            guard let index = self.messagesList.firstIndex(where: { userToRemove == $0.nameChat }) else {return}
            self.messagesList.remove(at: index)
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
        
        self.socket.connect()
    }
    
    func disconnect() {
        
        self.socket.off(clientEvent: .connect)
        self.socket.off(clientEvent: .error)
        self.socket.off(clientEvent: .disconnect)
        self.socket.off(clientEvent: SocketClientEvent.reconnect)
        self.socket.removeAllHandlers()
        self.socket.emit("disconnect")
        self.socket.disconnect()
    }
    
    func getValuesFromList(list: [String: AnyObject]) -> [Chats] {
        var users:[Chats] = [Chats]()
    
        for (_, value) in list {
            for subValue in value as! Array<AnyObject> {
                var user: Chats = Chats()
                for (subKey, subSubValue) in subValue as! Dictionary<String, AnyObject> {
                    switch subKey {
                        case "id":
                            user.idChat = subSubValue.description
                        case "username":
                            user.nameChat = subSubValue.description
                        default:
                            print("")
                    }
                }
                users.append(user)
            }
        }
        return users
    }
    
    func removeMe(users: [Chats]) -> [Chats] {
        var response = [Chats]()
        for user in users {
            if(user.nameChat != self.username) {
                response.append(user)
            }
        }
        return response
    }
    
    func back(sender: UIBarButtonItem) {
        self.disconnect()
        _ = navigationController?.popViewController(animated: true)
    }
}

extension ChatsViewController : UITableViewDelegate, UITableViewDataSource { //table views
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ChatsTableViewCell
        let row = self.messagesList[indexPath.row]
        
        cell?.userName.text = row.nameChat
        cell?.descriptionMessage.text = row.description
        
        let hour = Calendar.current.component(.hour, from: Date()).description
        let minutes = Calendar.current.component(.minute, from: Date()).description
        cell?.timeMessage.text = "\(hour) : \(minutes)"
    
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        self.performSegue(withIdentifier: "fromChatsToMessages", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
        
    }
}
