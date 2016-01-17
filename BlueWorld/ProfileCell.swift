//
//  ProfileCell.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/17/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import UIKit
import SwiftHTTP

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var currentlyPlayingCell: UILabel!
    
    func initCell(user: User?) {
        if let user = user {
            do {
                let req = try HTTP.GET(user.avatarUrl)
                req.start() {
                    res in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.avatarImageView.image = UIImage(data: res.data)
                    }
                }
            } catch let e {
                print(e)
            }
            
            usernameLabel.text = user.onlineId
            
            if user.onlineStatus == "offline" {
                currentlyPlayingCell.text = "Offline"
            } else if user.currentPlayingTitleName == "" {
                currentlyPlayingCell.text = "Online"
            } else {
                currentlyPlayingCell.text = "Currently Playing \(user.currentPlayingTitleName)"
            }
        } else {
            avatarImageView.image = User.avatar
            usernameLabel.text = User.username
            
            if User.onlineStatus == "offline" {
                currentlyPlayingCell.text = "Offline"
            } else if User.status == "idle" {
                currentlyPlayingCell.text = "Online"
            } else {
                currentlyPlayingCell.text = "Currently Playing \(User.gameTitleInfo["titleName"]!)"
            }
        }
    }
}
