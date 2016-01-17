//
//  FriendCell.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/16/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import UIKit
import SwiftHTTP

class FriendCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var currentlyPlaying: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    func initCell(friend: User) {
        nameLabel.text = friend.onlineId
        currentlyPlaying.text = friend.currentPlayingTitleName
        
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        
        do {
            let req = try HTTP.GET(friend.avatarUrl)
            
            req.start() {
                res in
                dispatch_async(dispatch_get_main_queue()) {
                    let avatar = UIImage(data: res.data)
                    self.avatarImageView.image = avatar
                }
            }
        } catch let e {
            print(e)
        }
    }
}
