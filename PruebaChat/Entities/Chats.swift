//
//  Chats.swift
//  PruebaChat
//
//  Created by Brayam Alberto Mora Arias on 12/05/20.
//  Copyright © 2020 Brayam Alberto Mora Arias. All rights reserved.
//

import Foundation

struct Chats: Decodable {
    var idChat: String
    var nameChat: String
    var description: String?
    
    private enum CodingKeys: CodingKey {
        //case id
        case idChat
        case nameChat
        case description
    }
    
    init() {
        self.idChat = ""
        self.nameChat = ""
        self.description = "Hola, ¿Como estás?"
    }
    
    init(idChat: String, nameChat: String, description: String) {
        self.idChat = idChat
        self.nameChat = nameChat
        self.description = description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.idChat = try container.decode(String.self, forKey: .idChat)
        self.nameChat = try container.decode(String.self, forKey: .nameChat)
        self.description = try container.decode(String.self, forKey: .description)
    }
    
}
