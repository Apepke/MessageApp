//
//  messageDetailCell.swift
//  MessageApp
//
//  Created by Alex Pepke on 6/30/18.
//  Copyright © 2018 Alex Pepke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase
import SwiftKeychainWrapper

class messageDetailCell: UITableViewCell {
    @IBOutlet weak var recipientImg: UIImageView!
    @IBOutlet weak var recipientName: UILabel!
    @IBOutlet weak var chatPreview: UILabel!
    var messageDetail: MessageDetail!
    var userPostKey: DatabaseReference!
    let currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    func configureCell(messageDetail: MessageDetail){
        self.messageDetail = messageDetail
        let recipientData = Database.database().reference().child("users").child(messageDetail.recipient)
        
        recipientData.observeSingleEvent(of: .value, with: {(snapshot) in
            let data = snapshot.value as! Dictionary<String, AnyObject>
            let username = data ["username"]
            let userImg = data ["userImg"]
            self.recipientName.text = username as? String
            
            let ref = Storage.storage().reference(forURL: userImg! as! String)
            ref.getData(maxSize: 100000, completion: { (data, error) in
                
                if error != nil{
                    print("could not load")
                }
                else{
                    if let imgData = data {
                        if let img = UIImage(data: imgData){
                            self.recipientImg.image = img
                        }
                    }
                }
            })
            
        })
    }
}
