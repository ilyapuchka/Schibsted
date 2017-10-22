//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Muge Ersoy on 21/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import UIKit



let serverURL =  "https://s3-eu-west-1.amazonaws.com/rocket-interview/chat.json"

class ChatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
  

    
    @IBOutlet weak var tableView: UITableView!
    
    var messages = [Message]()
    
    override func viewDidLoad() {
           
    }

    //MARK - UITableViewDataSource
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
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
