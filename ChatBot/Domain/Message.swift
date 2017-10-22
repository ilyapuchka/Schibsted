//
//  Message.swift
//  ChatBot
//
//  Created by Muge Ersoy on 22/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import Foundation

struct Message: Decodable {

    var username : String
    var time : String
    var userImageURL: URL?
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case username, time, userImageURL = "userImage_url", content
    }
    
}
