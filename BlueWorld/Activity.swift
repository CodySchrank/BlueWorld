//
//  Activity.swift
//  BlueWorld
//
//  Created by Cody Schrank on 1/6/16.
//  Copyright © 2016 TheTapAttack. All rights reserved.
//

import Foundation

class Activity {
    var caption: String
    var storyId: String
    var smallImageUrl: String
    var date: String
    
    init(caption: String,storyId: String,smallImageUrl: String,date: String) {
        self.caption = caption
        self.storyId = storyId
        self.smallImageUrl = smallImageUrl
        self.date = date
    }
    
    static var UserActivity = [Activity]()
    
    static func parseJSONForUserActivity(data: [[String:AnyObject]]) {
        self.UserActivity = []
        
        for activity in data {
            guard let caption = activity["caption"] as? String where caption != "" else {
                continue
            }
            
            guard let storyId = activity["storyId"] as? String where storyId != "" else {
                continue
            }
            guard let smallImageUrl = activity["smallImageUrl"] as? String where smallImageUrl != "" else {
                continue
            }
            guard let date = activity["date"] as? String where date != "" else {
                continue
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            let formattedDate = dateFormatter.dateFromString(date)?.formattedRelativeString()
            
            let newActivity = Activity(caption: caption, storyId: storyId, smallImageUrl: smallImageUrl, date: formattedDate!)
            
            self.UserActivity.append(newActivity)
        }
    }
    
    static func parseJSONForFriendActivity(data: [[String:AnyObject]]) -> [Activity] {
        var activities: [Activity] = []
        for activity in data {
            guard let caption = activity["caption"] as? String where caption != "" else {
                continue
            }
            
            guard let storyId = activity["storyId"] as? String where storyId != "" else {
                continue
            }
            guard let smallImageUrl = activity["smallImageUrl"] as? String where smallImageUrl != "" else {
                continue
            }
            guard let date = activity["date"] as? String where date != "" else {
                continue
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            let formattedDate = dateFormatter.dateFromString(date)?.formattedRelativeString()
            
            let newActivity = Activity(caption: caption, storyId: storyId, smallImageUrl: smallImageUrl, date: formattedDate!)
            
            activities.append(newActivity)
        }
        
        return activities
    }
    
    
    
}