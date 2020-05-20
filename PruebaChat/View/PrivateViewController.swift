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
        //Generamos un random que se usa para crear las llaves
        let random = axlsign.randomBytes(64)
        
        //Convertimos el random a Hexadecimal para ser enviado al otro usuario o usuarios
        let randomTohex: String = random.toHexString()
        print("randomTohex : \(randomTohex)\n")

        //Convertimos el anterior hexadecimal a UInt8 para crear las llaves
        let randomToUInt8 = strToArray(randomTohex)
        
        // Traemos la key(32) para cifrar e random
        let secretKeyRandom = Cryptography().cryptRandom()
        //Ciframos el random
        let randomCipher = Cryptography().encrypted(randomTohex,secretKeyRandom)
        
        let keys = axlsign.generateKeyPair(randomToUInt8)

        // Creamos la secret master con la que se cifra y descifra el mensaje
        let secretSender = axlsign.sharedKey(secretKey: keys.privateKey, publicKey: keys.publicKey)
        
        /*------------------------------------ Ciframos el mensaje ------------------------------------*/
        guard let message = self.boxChatTextView.text else {return}
        let cipherText = Cryptography().encrypted(message, secretSender)
        
        if(SocketIOManager.sharedInstance.checkConnection()) {
            let data = self.prepareData(message: cipherText[0], randomCipher: randomCipher[0], iv: cipherText[1], irv: randomCipher[1])
            SocketIOManager.sharedInstance.sendMessage(data)
            self.messageList.append(["me": message])
            self.chatView.reloadData()
            self.chatView.isHidden = false
        }
    }
    
    func prepareData(message: String, randomCipher: String , iv: String , irv: String ) -> String {
        return """
        { "from": "\(self.me)", "to": "\(self.receiverId)", "message" : "\(message)", "rnd" : "\(randomCipher)" , "iv" : "\(iv)" , "irv" : "\(irv)" }
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
        print("userList : , \(userList)")
        var to = String()
        var message = String()
        var iv = String()
        var irv = String()
        var rnd = String()
        for (key, value) in userList[0] {
            switch key {
                case      "to":
                    to      = value.description
                case "message":
                    message = value.description
                case      "iv":
                    iv      = value.description
                case     "irv":
                    irv     = value.description
                case     "rnd":
                    rnd     = value.description
                       default:
                    print("")
            }
        }
              
        /*------------------------------------ Desciframos el mensaje ------------------------------------*/
        // Pimero tomamos el random que nos envían y está en formato Hexadecimal y se encuentra cifrado
        // Para descifrar obtenemos la key que están en tipo de dato Array<UInt8>

        /*El otro usuario se traer la key para descifrar el mensaje */
        let RandomSecretReceive = Cryptography().cryptRandom()
        print("RandomSecretReceive: , \(RandomSecretReceive)\n")
        // Desciframos el Random para generar las llaves y derivar el secreto maestro
        let randomDescifrado2 = Cryptography().decrypted(rnd,  RandomSecretReceive  , irv)
        
        // Procedemos a generar las llaver públicas, privadas y secreto maestro
        // Para ello el random descifrado que está en hexadecimal lo convertimos a [UInt8]
        let rn = strToArray(randomDescifrado2)
        // Generamos el par de llaves
        let keypairReceive = axlsign.generateKeyPair(rn)
        let publicReceive = keypairReceive.publicKey
        let privateReceive = keypairReceive.privateKey
        let secretReceive = axlsign.sharedKey(secretKey: privateReceive, publicKey: publicReceive)
        
        //Desciframos el texto cifrado
        let decrypt = Cryptography().decrypted(message, secretReceive, iv)
        
        
        self.messageList.append(["receiver":decrypt])
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
        let key = row.first!.key as String
        
        if(key == "me") {
            test = (cell?.setCustom(text: row["me"]! as String,type: false))!
        }else {
            test = (cell?.setCustom(text: row["receiver"]! as String, type: true))!
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
