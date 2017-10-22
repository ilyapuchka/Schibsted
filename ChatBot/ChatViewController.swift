//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Muge Ersoy on 21/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            //registerReusableViews()
            tableView.register(UserChatBubble.nib)
            tableView.register(FriendChatBubble.nib)
        }
    }
    
    var service: ChatService = ChatService(networkSession: URLSession.shared)
    //var model = ChatModel(messages: [])
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        service.getChatMessages().then { [weak self] (messages) in
            //self?.model = ChatModel(messages: messages)
            self?.messages = [
                Message(
                    username: UserDefaults.standard.value(forKey: "username") as! String,
                    time: "now",
                    userImageURL: nil,
                    content: "lalalala")
            ] + messages
            self?.tableView.reloadData()
        }
    }

}

extension ChatViewController/*: ListView*/ {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
        //return numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let username = UserDefaults.standard.value(forKey: "username") as? String

        if message.username == username {
            let userChatBubble = tableView.dequeueReusableCell(withIdentifier: UserChatBubble.reuseIdentifier, for: indexPath)!
            let model = ChatBubbleViewModel<UserSenderType>(message: message)
            userChatBubble.update(withViewModel: model)
            return userChatBubble
        } else {
            let friendChatBubble = tableView.dequeueReusableCell(withIdentifier: FriendChatBubble.reuseIdentifier, for: indexPath)!
            let model = ChatBubbleViewModel<FriendSenderType>(message: message)
            friendChatBubble.update(withViewModel: model)
            return friendChatBubble
        }
        //return cellForRow(at: indexPath)
    }
    
}

//struct ChatModel: ListViewModel {
//
//    typealias Item = AnyChatBubbleViewModel
//    typealias Cell = AnyChatBubble
//
//    let messages: [AnyChatBubbleViewModel]
//
//    init(messages: [Message]) {
//        self.messages = messages.map(AnyChatBubbleViewModel.init(message:))
//    }
//
//    func numberOfRows() -> Int {
//        return messages.count
//    }
//
//    func item(at index: Int) -> Item? {
//        guard index < messages.count else { return nil }
//        return messages[index]
//    }
//
//}

