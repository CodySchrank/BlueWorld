//
//  User.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/2/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import Foundation
import SwiftHTTP

public class User {
    
    /*
        Static vars are the user info
        An init'd User is the user's friend
    */
    
    static var
        username = "",
        password = "",
        email = "",
        access_token = "",
        access_token_timestap: NSDate?,
        refresh_token = "",
        avatar: UIImage?,
        onlineStatus = "",
        gameTitleInfo = ["titleName": "","npTitleId" : ""],
        trophyTitleIconUrl = "",
        npCommunicationId = "",
        npId = "",
        status = ""
        
    
    var onlineId: String
    var onlineStatus: String
    var currentPlayingTitleName: String
    var trophyLevel: String
    var avatarUrl: String
    
    static var Friends = [User]()
    static var FriendsOnline: [User] {
        get {
            var _FriendsOnline = [User]()
            for friend in User.Friends {
                if friend.onlineStatus == "online" {
                    _FriendsOnline.append(friend)
                }
            }
            return _FriendsOnline
        }
    }
    
    init(onlineId: String, onlineStatus: String, currentlyPlayingTitleName: String, trophyLevel: String, avatarUrl: String) {
        self.onlineId = onlineId
        self.onlineStatus = onlineStatus
        self.currentPlayingTitleName = currentlyPlayingTitleName
        self.trophyLevel = trophyLevel
        self.avatarUrl = avatarUrl
    }
    
    static func reset() {
        User.email = ""
        User.password = ""
        User.username = ""
        User.access_token = ""
        User.refresh_token = ""
    }
    
    static func parseJSONForUserData(data: [String: AnyObject]) {
        if let avatarURL = data["avatarUrl"] as? String {
            do {
                let opt = try HTTP.GET(avatarURL)
                opt.start() {
                    res in
                    
                    self.avatar = UIImage(data: res.data)
                }
            } catch let e {
                print(e)
            }
        }
        if let npId = data["npId"] as? String {
            User.npId = npId
        }
        if let primaryInfo = data["presence"]?["primaryInfo"] as? [String: AnyObject] {
            if let onlineStatus = primaryInfo["onlineStatus"] as? String {
                User.onlineStatus = onlineStatus
            }
            if let gameTitleInfo = primaryInfo["gameTitleInfo"] as? [String: AnyObject] {
                if let titleName = gameTitleInfo["titleName"] as? String {
                    User.gameTitleInfo["titleName"] = titleName
                }
                if let npTitleId = gameTitleInfo["npTitleId"] as? String {
                    User.gameTitleInfo["npTitleId"] = npTitleId
                }
            }
        }
    }
    
    static func parseJSONForFriendsData(data: [[String: AnyObject]]) {
        User.Friends = []
        for friend in data {
            guard let onlineId = friend["onlineId"] as? String where onlineId != "" else {
                continue
            }
            
            guard let onlineStatus = friend["presences"]?[0]["onlineStatus"] as? String where onlineStatus != "" else {
                continue
            }
            
            guard let avatarUrl = friend["avatarUrls"]?[0]["avatarUrl"] as? String where avatarUrl != "" else {
                continue
            }
            
            var currentPlayingTitleName = ""
            if let _currentPlayingTitleName = friend["presences"]?[0]["titleName"] as? String {
                currentPlayingTitleName = _currentPlayingTitleName
            }
    
            guard let trophyLevel = friend["trophySummary"]?["level"] as? Int where trophyLevel != -1 else {
                continue
            }
            
            let newFriend = User(onlineId: onlineId, onlineStatus: onlineStatus, currentlyPlayingTitleName: currentPlayingTitleName, trophyLevel: String(stringInterpolationSegment: trophyLevel), avatarUrl: avatarUrl)
            
            User.Friends.append(newFriend)
        }
    }
}