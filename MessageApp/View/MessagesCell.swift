//
//  MessagesCell.swift
//  MessageApp
//
//  Created by Alex Pepke on 6/30/18.
//  Copyright © 2018 Alex Pepke. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MessagesCell: UITableViewCell {
    @IBOutlet weak var recievedMessagesLbl: UILabel!
    @IBOutlet weak var recievedMessageView: UIView!
    @IBOutlet weak var sentMessageLbl: UILabel!
    @IBOutlet weak var sentMessageVIew: UIView!
    var message: Message!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    func configCell(message: Message) {
        self.message = message
        if message.sender == currentUser {
            sentMessageVIew.isHidden = false
            sentMessageLbl.text = message.message
            recievedMessagesLbl.text = ""
            recievedMessagesLbl.isHidden = true
        } else {
            sentMessageVIew.isHidden = true
            sentMessageLbl.text = ""
            recievedMessagesLbl.text = message.message
            recievedMessagesLbl.isHidden = false
        }
    }
}
