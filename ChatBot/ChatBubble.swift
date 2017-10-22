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
    @IBOutlet weak var userImage: UIImageView!
    
    private var imageLoadindHandle: UUID?
    
    func updateChatBubble(message : Message) {
        userName.text = message.username
        bubbleContent.text = message.content
        
        userImage.isHidden = true
        imageLoadindHandle = ImageLoader.shared.getImage(message.userImageURL) { [weak self] handle, image, _ in
            guard handle == self?.imageLoadindHandle else { return }
            self?.userImage.image = image
            self?.userImage.isHidden = image == nil
        }
    }
    
    override func prepareForReuse() {
        if let imageLoadindHandle = imageLoadindHandle {
            ImageLoader.shared.cancelImageLoading(imageLoadindHandle)
            self.imageLoadindHandle = nil
        }
        userImage.image = nil
        userImage.isHidden = true
    }

}
