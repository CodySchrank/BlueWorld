//
//  MessageCell.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/10/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    func initCell(messageGroup: MessageGroup) {
        
        //MARK: Avatar
        let profileManager = ProfileManager()
        
        avatarImageView.layer.cornerRadius = 32
        avatarImageView.clipsToBounds = true
        
        // This is kinda confusing to follow but we send in the username of the other person in the message, and then we update the image on the main thread.
        if avatarImageView.image != messageGroup.avatar {
            avatarImageView.image = messageGroup.avatar
        }
        
        //bug?
        
        if messageGroup.avatar == nil {
            profileManager.getAvatar(messageGroup.membersExcludingTheUser[0]) {
                avatar in
                dispatch_async(dispatch_get_main_queue()) {
                    if let avatar = avatar {
                        self.avatarImageView.image = avatar
                        messageGroup.avatar = avatar
                    }
                }
            }
        }
        
        //MARK: Labels
        var ish = ""
        for member in messageGroup.membersExcludingTheUser {
            ish += "\(member), "
        }
        if ish != "" {
            let name1 = ish.substringToIndex(ish.endIndex.predecessor())
            let name2 = name1.substringToIndex(name1.endIndex.predecessor())
            nameLabel.text = name2
        }
        bodyLabel.text = messageGroup.latestMessageBody
        dateLabel.text = messageGroup.lastUpdated
    }
}
