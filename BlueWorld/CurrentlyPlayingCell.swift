//
//  CurrentlyPlayingCell.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/5/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import UIKit
import SwiftHTTP
import AVFoundation

class CurrentlyPlayingCell: UITableViewCell {
    
    @IBOutlet weak var currentGameImage: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var statusLabelLeadingMargin: NSLayoutConstraint?
    
    func initCell(status: String) {
        statusLabel.text = status
//        statusLabelLeadingMargin?.constant = 5 + 18 //Just an estimate (Optimized for iphone 6)
        
        do {
            let req = try HTTP.GET(User.trophyTitleIconUrl)
            
            req.start() {
                res in
                
                let gameImage = UIImage(data: res.data)
                if let gameImage = gameImage {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.currentGameImage.image = gameImage
                        for view in self.currentGameImage.subviews {
                            view.removeFromSuperview()
                        }
                        
                        let bounds = AVMakeRectWithAspectRatioInsideRect(Tools.calculateRectOfImageInImageView(self.currentGameImage).size, self.currentGameImage.bounds)
                        
//                        if let statusLabelLeadingMargin = self.statusLabelLeadingMargin {
//                            statusLabelLeadingMargin.constant = bounds.origin.x + 18
//                        }
                        
                        let view = UIView(frame: bounds)
                        view.backgroundColor = .blackColor()
                        view.alpha = 0.5
                        
                        let gameTitle = UILabel(frame: CGRect(x: 20 + bounds.origin.x, y: 10 + bounds.origin.y, width: 400, height: 21))
                        gameTitle.text = User.gameTitleInfo["titleName"]
                        gameTitle.textColor = .whiteColor()
                        gameTitle.alpha = 0.7
                        gameTitle.font = UIFont(name: "Futura", size: 17)
                        
                        let trophyProgress = CurrentTrophies.currentGameProgess
                        let initialCircle = CircleView(frame: CGRect(x: 15 + bounds.origin.x, y: 110 - bounds.origin.y, width: 60, height: 60),alpha: 0.2, width: CGFloat(M_PI * 2.0))
                        
                        let width = CGFloat(Double(Float(trophyProgress) / Float(50)) * M_PI)
                    
                        let trophyProgressCircle = CircleView(frame: CGRect(x: 15 + bounds.origin.x, y: 110 - bounds.origin.y, width: 60, height: 60),alpha: 0.8, width: width)
                        trophyProgressCircle.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI_2));
                        
                        let trophyProgressLabel = UILabel(frame: CGRect(x: 20 + bounds.origin.x, y: 130 - bounds.origin.y, width: 50, height: 21))
                        trophyProgressLabel.font = UIFont(name: "Futura", size: 14)
                        trophyProgressLabel.textColor = .whiteColor()
                        trophyProgressLabel.textAlignment = .Center
                        trophyProgressLabel.alpha = 0.8
                        trophyProgressLabel.text = "\(trophyProgress)%"
                        
                        let trophyTotalLabel = UILabel(frame: CGRect(x: 90 + bounds.origin.x, y: 130 - bounds.origin.y, width: 90, height: 21))
                        trophyTotalLabel.font = UIFont(name: "Futura", size: 16)
                        trophyTotalLabel.textColor = .whiteColor()
                        trophyTotalLabel.alpha = 0.8
                        trophyTotalLabel.text = "\(CurrentTrophies.currentGameEarnedTrophiesTotal)/\(CurrentTrophies.currentGameDefinedTrophiesTotal)"
                        
                        
                        /** DONT LIKE HOW THE TROPHY STUFF LOOKS SO IM HIDING IT FOR NOW**/
                        trophyTotalLabel.alpha = 0
                        trophyProgressCircle.alpha = 0
                        initialCircle.alpha = 0
                        trophyProgressLabel.alpha = 0
                        
                        self.currentGameImage.addSubview(view)
                        self.currentGameImage.addSubview(gameTitle)
                        self.currentGameImage.addSubview(initialCircle)
                        self.currentGameImage.addSubview(trophyProgressCircle)
                        self.currentGameImage.addSubview(trophyProgressLabel)
                        self.currentGameImage.addSubview(trophyTotalLabel)
                    }
                }
            }
        } catch let e {
            print(e)
        }
    }
}

class CircleView: UIView {
    var width = CGFloat(M_PI * 2.0)
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(context, 3.0)
        
        UIColor.whiteColor().set()
        CGContextAddArc(context, frame.size.width/2, frame.size.height/2, (frame.size.width - 10)/2, 0.0, width, 0)
        
        CGContextStrokePath(context)
    }
    
    init(frame: CGRect, alpha: CGFloat, width: CGFloat) {
        self.width = width
        super.init(frame: frame)
        self.alpha = alpha
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

