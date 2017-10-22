//
//  ChatBubble.swift
//  ChatBot
//
//  Created by Muge Ersoy on 22/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//


import UIKit


class ChatBubble : UITableViewCell {

    @IBOutlet weak var bubbleContent: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        self.userImage.layer.masksToBounds = true
        self.userImage.layer.borderWidth = 1
        self.userImage.layer.borderColor = UIColor.white.cgColor
        self.userImage.layer.cornerRadius = 15

        self.background.layer.cornerRadius = 8
        self.background.layer.masksToBounds = true
    }
    
    func updateChatBubble(message : Message) {
        userName.text = message.username
        bubbleContent.text = message.content
    }
}
