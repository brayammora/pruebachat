//
//  Binding.swift
//  PruebaChat
//
//  Created by Brayam Alberto Mora Arias on 14/05/20.
//  Copyright © 2020 Brayam Alberto Mora Arias. All rights reserved.
//

import Foundation

class Binding<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    func dataBinding(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
