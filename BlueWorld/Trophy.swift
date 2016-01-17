//
//  Trophies.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/15/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import Foundation

class Trophy {
    var platform: String
    var title: String
    var lastPlayed: NSDate
    var trophyTitleIconUrl: String
    var earnedTrophies = ["bronze": 0,"silver": 0,"gold": 0,"platinum": 0]
    var definedTrophies = ["bronze": 0,"silver": 0,"gold": 0,"platinum": 0]
    var progress: Int
    
    init(platform: String, title: String, lastPlayed: NSDate, trophyTitleIconUrl: String, progress: Int, earnedTrophies: [String: Int], definedTrophies: [String: Int]) {
        self.platform = platform
        self.title = title
        self.lastPlayed = lastPlayed
        self.trophyTitleIconUrl = trophyTitleIconUrl
        self.progress = progress
        self.earnedTrophies = earnedTrophies
        self.definedTrophies = definedTrophies
    }
    
    static var UserTrophies = [Trophy]()
    
    static func parseJSONForUserTrophies(data: [[String: AnyObject]]) {
        self.UserTrophies = []
        
        for trophy in data {
            guard let trophyTitleName = trophy["trophyTitleName"] as? String where trophyTitleName != "" else {
                continue
            }
            
            guard let trophyTitlePlatfrom = trophy["trophyTitlePlatfrom"] as? String where trophyTitlePlatfrom != "" else {
                continue
            }
            
            guard let lastUpdateDate = trophy["fromUser"]?["lastUpdateDate"] as? String where lastUpdateDate != "" else {
                continue
            }
            
            guard let trophyTitleIconUrl = trophy["trophyTitleIconUrl"] as? String where trophyTitleIconUrl != "" else {
                continue
            }
            
            guard let progress = trophy["fromUser"]?["progress"] as? Int where progress != -1 else {
                continue
            }
            
            guard let definedTrophies = trophy["definedTrophies"] as? [String:Int] where definedTrophies != ["":0] else {
                continue
            }
            
            guard let earnedTrophies = trophy["fromUser"]?["earnedTrophies"] as? [String:Int] where earnedTrophies != ["":0] else {
                continue
            }
            
            // create dateFormatter with UTC time format
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            let date = dateFormatter.dateFromString(lastUpdateDate)
            
            let newTrophy = Trophy(platform: trophyTitlePlatfrom, title: trophyTitleName, lastPlayed: date!, trophyTitleIconUrl: trophyTitleIconUrl, progress: progress, earnedTrophies: earnedTrophies, definedTrophies: definedTrophies)
            
            self.UserTrophies.append(newTrophy)
        }
    }
    
    static func parseJSONForFriendTrophies(data: [[String: AnyObject]]) -> [Trophy] {
        var trophies = [Trophy]()
        
        for trophy in data {
            guard let trophyTitleName = trophy["trophyTitleName"] as? String where trophyTitleName != "" else {
                continue
            }
            
            guard let trophyTitlePlatfrom = trophy["trophyTitlePlatfrom"] as? String where trophyTitlePlatfrom != "" else {
                continue
            }
            
            guard let lastUpdateDate = trophy["comparedUser"]?["lastUpdateDate"] as? String where lastUpdateDate != "" else {
                continue
            }
            
            guard let trophyTitleIconUrl = trophy["trophyTitleIconUrl"] as? String where trophyTitleIconUrl != "" else {
                continue
            }
            
            guard let progress = trophy["comparedUser"]?["progress"] as? Int where progress != -1 else {
                continue
            }
            
            guard let definedTrophies = trophy["definedTrophies"] as? [String:Int] where definedTrophies != ["":0] else {
                continue
            }
            
            guard let earnedTrophies = trophy["comparedUser"]?["earnedTrophies"] as? [String:Int] where earnedTrophies != ["":0] else {
                continue
            }
            
            // create dateFormatter with UTC time format
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            let date = dateFormatter.dateFromString(lastUpdateDate)
            
            let newTrophy = Trophy(platform: trophyTitlePlatfrom, title: trophyTitleName, lastPlayed: date!, trophyTitleIconUrl: trophyTitleIconUrl, progress: progress, earnedTrophies: earnedTrophies, definedTrophies: definedTrophies)
            
            trophies.append(newTrophy)
        }
        
        return trophies
    }
}
