//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Muge Ersoy on 21/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
//            tableView.estimatedRowHeight = 150
//            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.register(UINib(nibName: "ChatBubble", bundle: nil), forCellReuseIdentifier: "ChatBubble")
        }
    }
    
    var service: ChatService = ChatService(networkSession: URLSession.shared)
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.getChatMessages { [weak self] (messages, error) in
            guard let messages = messages else { return }
            self?.messages = messages
            self?.tableView.reloadData()
        }
    }

    //MARK - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatBubble") as! ChatBubble
        cell.updateChatBubble(message: message)
        return cell
    }

}
