//
//  TrophyCell.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/17/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import UIKit
import SwiftHTTP

class TrophyCell: UITableViewCell {
    
    @IBOutlet weak var trophyIcon: UIImageView!
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    @IBOutlet weak var platformButton: UIButton!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var platinumTrophy: UIImageView!
    
    @IBOutlet weak var bronzeView: UIView!
    
    @IBOutlet weak var bronzeViewWidth: NSLayoutConstraint?
    
    @IBOutlet weak var silverView: UIView!
    
    @IBOutlet weak var silverViewWidth: NSLayoutConstraint?
    
    @IBOutlet weak var goldView: UIView!
    
    @IBOutlet weak var goldViewWidth: NSLayoutConstraint?
    
    func initCell(trophy: Trophy) {
        let alpha: CGFloat = 0.2
        
        gameTitleLabel.text = trophy.title
        
        for view in self.subviews {
            if view.tag == 2{
                view.removeFromSuperview()
            }
        }
        
        progressLabel.text = "\(trophy.progress)%"
        
        platformButton.layer.cornerRadius = 5
        platformButton.clipsToBounds = true
        
        if trophy.earnedTrophies["platinum"] == 0 {
            platinumTrophy.alpha = 0
        } else {
            platinumTrophy.alpha = 1
        }
        
        /** BRONZE **/
        var bronzeWidth = CGFloat(trophy.definedTrophies["bronze"]!) * 3
        if bronzeWidth > 150 {
            bronzeWidth = 150
        }
        
        let bronzeEarnedView = UIView(frame: bronzeView.frame)
        bronzeEarnedView.tag = 2
        bronzeEarnedView.alpha = 1
        bronzeEarnedView.backgroundColor = UIColor(red: 140/255, green: 120/255, blue: 83/255, alpha: 1)
        var earnedViewWidth = CGFloat(trophy.earnedTrophies["bronze"]!) * 3
        if earnedViewWidth > 150 {
            earnedViewWidth = 150
        }
        bronzeEarnedView.frame.size.width = earnedViewWidth
        self.addSubview(bronzeEarnedView)
        
        bronzeView.alpha = alpha
        bronzeViewWidth?.constant = bronzeWidth
        
        /** SILVER **/
        let silverWidth = CGFloat(trophy.definedTrophies["silver"]!) * 3
        
        let silverEarnedView = UIView(frame: silverView.frame)
        silverEarnedView.tag = 2
        silverEarnedView.alpha = 1
        silverEarnedView.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
        silverEarnedView.frame.size.width = CGFloat(trophy.earnedTrophies["silver"]!) * 3
        self.addSubview(silverEarnedView)
        
        silverView.alpha = alpha
        silverViewWidth?.constant = silverWidth
        
        /** GOLD **/
        let goldWidth = CGFloat(trophy.definedTrophies["gold"]!) * 3
        
        let goldEarnedView = UIView(frame: goldView.frame)
        goldEarnedView.tag = 2
        goldEarnedView.alpha = 1
        goldEarnedView.backgroundColor = UIColor(red: 255/255, green: 235/255, blue: 0/255, alpha: 1)
        goldEarnedView.frame.size.width = CGFloat(trophy.earnedTrophies["gold"]!) * 3
        self.addSubview(goldEarnedView)
        
        goldView.alpha = alpha
        goldViewWidth?.constant = goldWidth
        
        self.trophyIcon.image = nil
        do {
            let req = try HTTP.GET(trophy.trophyTitleIconUrl)
            
            req.start() {
                res in
                dispatch_async(dispatch_get_main_queue()) {
                    let trophyTitleIcon = UIImage(data: res.data)
                    self.trophyIcon.image = trophyTitleIcon
                }
            }
        } catch let e {
            print(e)
        }
    }
}
