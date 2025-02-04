//
//  ChatsViewModel.swift
//  PruebaChat
//
//  Created by Brayam Alberto Mora Arias on 14/05/20.
//  Copyright © 2020 Brayam Alberto Mora Arias. All rights reserved.
//

import Foundation
import UIKit
import SocketIO


class ChatsViewModel: NSObject {
    
    var messagesList: [String]!
    var usersList: [String]!
    
    override init() {
        self.messagesList = [String]()
        self.usersList = [String]()
    }
    
}
