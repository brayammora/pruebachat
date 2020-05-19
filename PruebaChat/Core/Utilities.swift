//
//  Utilities.swift
//  PruebaChat
//
//  Created by Brayam Alberto Mora Arias on 15/05/20.
//  Copyright © 2020 Brayam Alberto Mora Arias. All rights reserved.
//

import Foundation
import UIKit

class Utilities {

    class func setAlert(msg: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Message", message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        
        return alertController
    }
}

