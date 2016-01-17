//
//  ProfileManager.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/2/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import Foundation
import SwiftHTTP

public class ProfileManager {
    func getProfile(callback: () -> Void) {
        AuthManager.getReqWithAuth() {
            Config.debug("Getting profile information for: \(User.username)")
            
            let url = URL.prepURL(URL.profileData,options: ["{{id}}": User.username], region: nil, lang: nil)
            
            do {
                let headers = Network.PSNHeaders
                
                let opt = try HTTP.GET(url, headers: headers)
                
                opt.start() {
                    response in
                    
                    if((response.error) != nil) {
                        Config.debug(response.error!)
                    } else {
                        let data = Tools.parseJSON(response.data)
                        if let data = data {
                            User.parseJSONForUserData(data)
                        }
                        callback()
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func getAvatar(id: String,callback: (UIImage?) -> Void) {
        AuthManager.getReqWithAuth() {
            Config.debug("Getting avatar for: \(id)")
            
            let url = URL.prepURL(URL.profileData,options: ["{{id}}": id], region: nil, lang: nil)
            
            do {
                let headers = Network.PSNHeaders
                
                let opt = try HTTP.GET(url, headers: headers)
                
                opt.start() {
                    response in
                    
                    if((response.error) != nil) {
                        Config.debug(response.error!)
                    } else {
                        let data = Tools.parseJSON(response.data)
                        if let data = data {
                            if let url = data["avatarUrl"] as? String {
                                do {
                                    let opt = try HTTP.GET(url)
                                    
                                    opt.start() {
                                        response in
                                        
                                        let avatar = UIImage(data: response.data)
                                        callback(avatar)
                                    }
                                } catch let e {
                                    print(e)
                                }
                            }
                        }
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func getFriends(callback: () -> Void) {
        AuthManager.getReqWithAuth() {
            Config.debug("Getting friend Information for: \(User.username)")
            
            let url = URL.prepURL(URL.friendData,options: ["{{offset}}": "0"], region: nil, lang: nil)
            
            do {
                let headers = Network.PSNHeaders
                
                let opt = try HTTP.GET(url, headers: headers)
                
                opt.start() {
                    response in
                    
                    let data = Tools.parseAnyJSON(response.data)
                    if let data = data?["profiles"] as? [[String: AnyObject]] {
                        User.parseJSONForFriendsData(data)
                    }
                    callback()
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func getFeed(offset: Int,callback: () -> Void) {
        AuthManager.getReqWithAuth() {
            Config.debug("Getting feed for: \(User.username)")
            
            let url = URL.prepURL(URL.activityFeed,options: ["{{user}}": User.username,"{{offset}}": "\(offset)"], region: nil, lang: nil)
            
            do {
                let headers = Network.PSNHeaders
                
                let opt = try HTTP.GET(url, headers: headers)
                
                opt.start() {
                    response in
                    
                    let data = Tools.parseAnyJSON(response.data)
                    if let data = data?["feed"] as? [[String: AnyObject]] {
                        Activity.parseJSONForUserActivity(data)
                    }
                    callback()
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func getFriendFeed(friend: String,offset: Int,callback: ([Activity]?) -> Void) {
        AuthManager.getReqWithAuth() {
            Config.debug("Getting feed for: \(friend)")
            
            let url = URL.prepURL(URL.activityFeed,options: ["{{user}}": friend,"{{offset}}": "\(offset)"], region: nil, lang: nil)
            
            do {
                let headers = Network.PSNHeaders
                
                let opt = try HTTP.GET(url, headers: headers)
                
                opt.start() {
                    response in
                    
                    let data = Tools.parseAnyJSON(response.data)
                    if let data = data?["feed"] as? [[String: AnyObject]] {
                        let activity = Activity.parseJSONForFriendActivity(data)
                        callback(activity)
                        return
                    }
                    callback(nil)
                }
            } catch let error {
                print(error)
            }
        }
    }
}