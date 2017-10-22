//
//  ChatBubble.swift
//  ChatBot
//
//  Created by Muge Ersoy on 22/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//


import UIKit
import Rswift

final class FriendChatBubble: ChatBubble<FriendSenderType>, ListCell {
    
    static let reuseIdentifier = R.reuseIdentifier.friendChatBubble
    static let nib = R.nib.friendChatBubble
    
}

final class UserChatBubble: ChatBubble<UserSenderType>, ListCell {
    
    static let reuseIdentifier = R.reuseIdentifier.userChatBubble
    static let nib = R.nib.userChatBubble
    
}

class ChatBubble<Sender: SenderType>: UITableViewCell {

    @IBOutlet weak var bubbleContent: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView?

    fileprivate var imageLoadindHandle: UUID?

    func update(withViewModel model: ChatBubbleViewModel<Sender>) {
        userName.text = model.username
        bubbleContent.text = model.content
        
        if let userImage = userImage, let imageURL = model.imageURL {
            userImage.isHidden = true
            imageLoadindHandle = ImageLoader.shared.getImage(imageURL) { [weak self] handle, image, _ in
                guard handle == self?.imageLoadindHandle else { return }
                userImage.image = image
                userImage.isHidden = image == nil
            }
        }
    }
    
    override func prepareForReuse() {
        if let imageLoadindHandle = imageLoadindHandle {
            ImageLoader.shared.cancelImageLoading(imageLoadindHandle)
            self.imageLoadindHandle = nil
        }
        userImage?.image = nil
        userImage?.isHidden = true
    }

}

protocol SenderType {
    static func formatUserName(message: Message) -> String
}
enum UserSenderType: SenderType {
    static func formatUserName(message: Message) -> String {
        return message.time
    }
}
enum FriendSenderType: SenderType {
    static func formatUserName(message: Message) -> String {
        return "\(message.username) - \(message.time)"
    }
}

class ChatBubbleViewModel<Sender: SenderType> {
    
    let username: String
    let content: String
    let imageURL: URL?
    
    init(message: Message) {
        self.username = Sender.formatUserName(message: message)
        self.content = message.content
        self.imageURL = message.userImageURL
    }

}
