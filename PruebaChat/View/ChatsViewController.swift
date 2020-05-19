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

    /*
    let manager = SocketManager(socketURL: URL(string: "https://socket-server-rcflechas.herokuapp.com/")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if(!SocketIOManager.sharedInstance.checkConnection()) {
            SocketIOManager.sharedInstance.connectSocket()
        }
        self.messagesList = [Chats]()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.showUserList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleConnectedUserUpdateNotification(_:)), name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserLeftUpdateNotification(_:)), name: NSNotification.Name(rawValue: "userWasDesonnectedNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewMessageNotification(_:)), name: NSNotification.Name(rawValue: "newMessageNotification"), object: nil)
    }
    
    func showUserList() {
        if(SocketIOManager.sharedInstance.checkConnection()) {
            
            SocketIOManager.sharedInstance.addMeToUserList(self.username, completionHandler: { (userList) -> Void in
                
                let userList =  userList
                let users = self.getValuesFromList(list: userList[0])
                self.messagesList = self.removeMe(users: users)
                self.tableView.reloadData()
                self.tableView.isHidden = false
            })
        }
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
            }else {
                self.id = user.idChat
            }
        }
        return response
    }
    
    func back(sender: UIBarButtonItem) {
        SocketIOManager.sharedInstance.disconnectSocket()
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func handleConnectedUserUpdateNotification(_ notification: Notification) {
        let userList = notification.object as! [[String: AnyObject]]
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
    
    @objc func handleUserLeftUpdateNotification(_ notification: Notification) {
        let userList = notification.object as! [[String: AnyObject]]
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
    
    @objc func handleNewMessageNotification(_ notification: Notification) {
        let userList = notification.object as! [[String: AnyObject]]
        print("NUEVO MENSAJE --> \(userList) <-- NUEVO MENSAJE")
        
        /*
        NUEVO MENSAJE --> [[
            "rnd": f1ee37b7680711fe6b354064579b05ebf95cf2ad6b729bd66027223f8de22a245b7f7be90ace1fd617be6e6633bae1907e63f05398bb56387bb14ca99639a97e844f2e030b4a102aa18479816b611a5e707ddeb4f060ed0d0a93ba46a632853f1d55ab65e2d17245e6626c26439903c50228a4a10420a176bd9ab088fdc5f8e80476fd763d9fe5e996afc7ddcbd0d0b1,
            "iv": 983e383d7c27258a1e8d46898ab99e5e,
            "message": 83132b2e78a09b7a4f965b029f6f9d7d852bd8cf,
            "irv": aad58a4ed5f724171e586eb9719f0683,
            "to": sk8MkwO2gBHMDuS-AAAJ,
            "from": ihd7zThX4y8HSusjAAAH
        ]] <-- NUEVO MENSAJE
 
         */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "fromChatsToMessages") {
            let vc = segue.destination as! PrivateViewController
            vc.me = self.id
            let receiverInfo = sender as! [String]
            vc.receiverId = receiverInfo[0]
            vc.receiverName = receiverInfo[1]
        }
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
        
        let currentCell = tableView.cellForRow(at: indexPath) as? ChatsTableViewCell
        guard let index = self.messagesList.firstIndex(where: { currentCell?.userName.text == $0.nameChat }) else {return}
        let idReceiver = self.messagesList[index].idChat
        let nameReceiver = self.messagesList[index].nameChat
        let receiverInfo = [idReceiver, nameReceiver]
        self.performSegue(withIdentifier: "fromChatsToMessages", sender: receiverInfo)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
        
    }
}
