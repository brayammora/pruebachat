//
//  PrivateViewController.swift
//  PruebaChat
//
//  Created by Brayam Alberto Mora Arias on 13/05/20.
//  Copyright © 2020 Brayam Alberto Mora Arias. All rights reserved.
//

import Foundation


import UIKit

class PrivateViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var principalView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var titleUser: UILabel!
    @IBOutlet weak var statusUser: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var chatView: UITableView!
    @IBOutlet weak var boxChatTextView: UITextView!
    @IBOutlet weak var openView: UIView!
    @IBOutlet weak var openChatButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var addDocumentButton: UIButton!
    @IBOutlet weak var shareLinkButton: UIButton!
    @IBOutlet weak var multimediaButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    var messageList: [[String:String]]!
    var me: String = String()
    var receiverId: String = String()
    var receiverName: String = String()
    
    var cont = 0
    var y1 = 0.0
    var y2 = 0.0
    var y3 = 0.0
    var textViewActive = false
    var test = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.messageList = [[String:String]]()
        
        print("SOY YO --> \(self.me) <--- SOY YO")
        print("RECEIVER--> \(self.receiverId) <--- RECEIVER")
        
        if(!SocketIOManager.sharedInstance.checkConnection()) {
            SocketIOManager.sharedInstance.connectSocket()
        }
        
        self.titleUser.text = self.receiverName.capitalized
        self.statusUser.text = "Online"
        self.navigationController?.isNavigationBarHidden = true
        self.boxChatTextView.delegate = self
        self.chatView.delegate = self
        self.chatView.dataSource = self
        self.chatView.estimatedRowHeight = 20
        self.chatView.rowHeight = UITableView.automaticDimension
        self.chatView.separatorColor = Colors.clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewMessageNotification(_:)), name: NSNotification.Name(rawValue: "newMessageNotification"), object: nil)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sendMessageAction(_ sender: Any) {
        
        guard let message = self.boxChatTextView.text else {return}
        if(SocketIOManager.sharedInstance.checkConnection()) {
            let data = self.prepareData(message: message)
            SocketIOManager.sharedInstance.sendMessage(data, completionHandler: { () -> Void in
                self.messageList.append([self.receiverId: message])
                self.chatView.reloadData()
                self.chatView.isHidden = false
            })
        }
        
    }
    
    func prepareData(message: String) -> String {
        return """
        { "from": "\(self.me)", "to": "\(self.receiverId)", "message" : "\(message)", "rnd" : "rnd" , "iv" : "iv" , "irv" : "irv" }
        """
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.y1 = Double(self.bottomView.frame.origin.y)
        self.y2 = Double(self.openChatButton.frame.origin.y)
        self.y3 = Double(self.boxChatTextView.frame.origin.y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.setImagePlaceholder()
        }
    }
    
    @objc func handleNewMessageNotification(_ notification: Notification) {
        let userList = notification.object as! [[String: AnyObject]]
        
        var to = String()
        var message = String()
        for (key, value) in userList[0] {
            switch key {
                case "to":
                    to = value.description
                case "message":
                    message = value.description
                default:
                    print("")
            }
        }
        self.messageList.append([to:message])
        self.chatView.reloadData()
        self.chatView.isHidden = false
        
        /*
         print("NUEVO MENSAJE --> \(userList) <-- NUEVO MENSAJE")
         
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
    
}

extension PrivateViewController : UITableViewDelegate, UITableViewDataSource { //table views
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateTableViewCell") as? PrivateTableViewCell
        let row = self.messageList[indexPath.row]
        let key = row.keys
        
        if(key.description != self.me) {
            test = (cell?.setCustom(text: row.values.description , type: true))!
        }else {
            test = (cell?.setCustom(text: row.values.description,type: false))!
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return test + 10
    }
    
    func setImagePlaceholder(){
        let attributedString = NSMutableAttributedString(string: "")
        let textAttachment = NSTextAttachment()
        textAttachment.image = UIImage(named: "rook_icon")!
        let oldWidth = 4.5//textAttachment.image!.size.width;
        let scaleFactor = oldWidth  //for the padding inside the textView
        textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: CGFloat(scaleFactor), orientation: .up)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedString.replaceCharacters(in: NSMakeRange(0, 0), with: attrStringWithImage)
        boxChatTextView.attributedText = attributedString;
        self.view.addSubview(boxChatTextView)
    }
    
    func addBottomBorderWithColor(_ myView:UIView) {
        let border = CALayer()
        border.backgroundColor = (Colors.gray_F2F2F2 as! CGColor)
        border.frame = CGRect(x: 0, y: myView.frame.height - myView.frame.height + 1, width: myView.frame.width, height: 1)
        myView.layer.addSublayer(border)
        self.view.layer.masksToBounds = true
    }
}
