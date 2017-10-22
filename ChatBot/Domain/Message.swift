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
    var time : Date?
    var userImageURL: URL?
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case username, time, userImageURL = "userImage_url", content
    }
    
    init(username: String, time: Date, userImageURL: URL? = nil, content: String) {
        self.username = username
        self.time = time
        self.userImageURL = userImageURL
        self.content = content
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        username = try values.decode(String.self, forKey: .username)
        userImageURL = try values.decode(URL?.self, forKey: .userImageURL)
        content = try values.decode(String.self, forKey: .content)
        let timeString = try values.decode(String.self, forKey: .time)
        time = messageTimeDecodingFormatter.date(from: timeString)
    }
    
}

let messageTimeDecodingFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm'h'"
    return formatter
}()
