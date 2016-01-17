//
//  ActivityCell.swift
//  BlueWorld
//
//  Created by Cody Schrank on 1/6/16.
//  Copyright © 2016 TheTapAttack. All rights reserved.
//

import UIKit
import SwiftHTTP

class ActivityCell: UITableViewCell {
    
    @IBOutlet weak var activityImageView: UIImageView!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    func initCell(activity: Activity) {
        captionLabel.text = activity.caption
        dateLabel.text = activity.date
        
        activityImageView.image = nil
        
        self.activityImageView.image = nil
        do {
            let req = try HTTP.GET(activity.smallImageUrl)
            
            req.start() {
                res in
                dispatch_async(dispatch_get_main_queue()) {   
                    let image = UIImage(data: res.data)
                    self.activityImageView.image = image
                }
            }
        } catch let e {
            print(e)
        }

    }
}
