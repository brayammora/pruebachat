//
//  LoginViewController.swift
//  PruebaChat
//
//  Created by Brayam Alberto Mora Arias on 11/05/20.
//  Copyright © 2020 Brayam Alberto Mora Arias. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SocketIOManager.sharedInstance.connectSocket()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        guard let usr = self.userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            else { return }
        
        self.username = usr
        
        if(usr == "") {
            print("Usuario invalido")
        } else {
            self.performSegue(withIdentifier: "fromLoginToChats", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromLoginToChats") {
            let vc = segue.destination as! ChatsViewController
            vc.username = self.username
        }
    }
}
