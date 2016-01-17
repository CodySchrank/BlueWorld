//
//  WelcomeCell.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/5/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import UIKit

class WelcomeCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var onlineStatus: UILabel!

    func initCell() {
        if User.username != "" {
            usernameLabel.text = "Welcome \(User.username)"
        } else {
            usernameLabel.text = "Welcome"
        }
        
        onlineStatus.layer.cornerRadius = 6
        onlineStatus.alpha = 0.8
        onlineStatus.clipsToBounds = true
        
        if User.onlineStatus == "online" || User.onlineStatus == "Online" {
            onlineStatus.backgroundColor = UIColor.greenColor()
        }
    }
}
