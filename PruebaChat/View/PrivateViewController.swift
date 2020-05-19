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
    
    var dataTest = ["i","image","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text","h","Lorem Ipsum is simply dummy"]
    var test2 = 0
    var cont = 0
    var y1 = 0.0
    var y2 = 0.0
    var y3 = 0.0
    var textViewActive = false
    var test = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
        self.boxChatTextView.delegate = self
        self.chatView.delegate = self
        self.chatView.dataSource = self
        self.chatView.estimatedRowHeight = 20
        self.chatView.rowHeight = UITableView.automaticDimension
        self.chatView.separatorColor = Colors.clear
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addDocumentAction(_ sender: Any) {
    }
    
    @IBAction func shareLinkAction(_ sender: Any) {
    }
    
    @IBAction func multimediaAction(_ sender: Any) {
    }
    
    @IBAction func addImageAction(_ sender: Any) {
    }
    
    @IBAction func cameraAction(_ sender: Any) {
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
    }
    
    @IBAction func openChatAction(_ sender: Any) {
        cont += 1
        UIView.animate(withDuration: 0.3) {
            if self.cont % 2 != 0{
                self.textViewActive = true
                self.boxChatTextView.frame = CGRect(x:  self.boxChatTextView.frame.origin.x, y: self.boxChatTextView.frame.origin.y, width: self.boxChatTextView.frame.width, height: 45)
                self.openChatButton.frame = CGRect(x:  self.openChatButton.frame.origin.x, y: self.openChatButton.frame.origin.y, width: self.openChatButton.frame.width, height: self.openChatButton.frame.height)
                self.openChatButton.transform =  CGAffineTransform(rotationAngle: .pi)
                
            }else{
                self.textViewActive = false
                self.openChatButton.frame = CGRect(x:  self.openChatButton.frame.origin.x, y: CGFloat(self.y2), width: self.openChatButton.frame.width, height: self.openChatButton.frame.height)
                self.boxChatTextView.frame = CGRect(x:  self.boxChatTextView.frame.origin.x, y: self.bottomView.frame.origin.y - 1 , width: self.boxChatTextView.frame.width, height: 45)
                self.openChatButton.transform =  CGAffineTransform(rotationAngle: 0 )
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
    
    @objc func keyboardWillShow(_ notification:Notification) {
        self.boxChatTextView.text = nil
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.openChatButton.transform =  CGAffineTransform(rotationAngle: .pi)
            
            self.bottomView.frame = CGRect(x: self.bottomView.frame.origin.x, y:  keyboardHeight + 93, width: self.bottomView.frame.width, height: self.bottomView.frame.height)
            self.boxChatTextView.frame = CGRect(x: self.boxChatTextView.frame.origin.x, y: keyboardHeight +  48, width:  self.boxChatTextView.frame.width, height:  self.boxChatTextView.frame.height)
            self.openView.frame = CGRect(x: self.openView.frame.origin.x, y: keyboardHeight +  48, width:  self.openView.frame.width, height:  self.openView.frame.height)
            self.openChatButton.frame = CGRect(x: self.openChatButton.frame.origin.x, y:  keyboardHeight + 57, width: self.openChatButton.frame.width, height: self.openChatButton.frame.height)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if !self.textViewActive{
            self.bottomView.frame = CGRect(x: self.bottomView.frame.origin.x, y:  CGFloat(y1)  , width: self.bottomView.frame.width, height: self.bottomView.frame.height)
            self.boxChatTextView.frame = CGRect(x: self.boxChatTextView.frame.origin.x, y: CGFloat(y3) , width:  self.boxChatTextView.frame.width, height:  45)
            self.openView.frame = CGRect(x: self.openView.frame.origin.x, y: CGFloat(y3) , width:  self.openView.frame.width, height:  45)
            self.openChatButton.frame = CGRect(x: self.openChatButton.frame.origin.x, y:  CGFloat(y2)  , width: self.openChatButton.frame.width, height: self.openChatButton.frame.height)
        }else{
            self.bottomView.frame = CGRect(x: self.bottomView.frame.origin.x, y:  CGFloat(y1)  , width: self.bottomView.frame.width, height: self.bottomView.frame.height)
            self.openChatButton.frame = CGRect(x: self.openChatButton.frame.origin.x, y:  CGFloat(y2)  , width: self.openChatButton.frame.width, height: self.openChatButton.frame.height)
            self.boxChatTextView.frame = CGRect(x: self.boxChatTextView.frame.origin.x, y: CGFloat(y3), width:  self.boxChatTextView.frame.width, height:  self.boxChatTextView.frame.height)
            self.openView.frame = CGRect(x: self.openView.frame.origin.x, y: CGFloat(y3), width:  self.openView.frame.width, height:  self.openView.frame.height)
        }
        self.openChatButton.transform =  CGAffineTransform(rotationAngle: 0 )
        
    }
    
}

extension PrivateViewController : UITableViewDelegate, UITableViewDataSource { //table views
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTest.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as? MessageTableViewCell
        test2 += 1
        
        if test2%2 == 0{
            print("......1")
            test = (cell?.setCustom(text: dataTest[indexPath.row], type: true))!
        }else{
            print("......2")
            test = (cell?.setCustom(text: dataTest[indexPath.row],type: false))!
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
