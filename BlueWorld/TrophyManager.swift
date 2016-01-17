//
//  TrophyManager.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/5/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import Foundation
import SwiftHTTP

class TrophyManager {
    func getMostRecentGame(callback: () -> Void) {
        AuthManager.getReqWithAuth() {
            Config.debug("Getting last played information for: \(User.username)")
            
            let url = URL.prepURL(URL.trophyData,options: ["{{offset}}": "0","{{limit}}": "1"], region: nil, lang: nil)
            
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
                            CurrentTrophies.parseJSONForTrophies(data)
                            if let url = data["trophyTitles"]?[0]?["trophyTitleIconUrl"] as? String {
                                User.trophyTitleIconUrl = url
                            }
                            if let url = data["trophyTitles"]?[0]?["trophyTitleName"] as? String {
                                User.gameTitleInfo["titleName"] = url
                            }
                            User.status = "idle"
                            
                        }
                        callback()
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func currentlyPlaying(callback: (Bool) -> Void) {
        AuthManager.getReqWithAuth() {
            Config.debug("Getting currently playing information for: \(User.username)")
            
            let url = URL.prepURL(URL.allTrophyData,options: ["{{offset}}": "0"], region: nil, lang: nil)
            
            do {
                let headers = Network.PSNHeaders
                
                let opt = try HTTP.GET(url, headers: headers)
                
                opt.start() {
                    response in
                    
                    if((response.error) != nil) {
                        Config.debug(response.error!)
                    } else {
                        let data = Tools.parseAnyJSON(response.data)
                        if let data = data?["trophyTitles"] as? [[String:AnyObject]] {
                            for list in data {
                                for (_,value) in list {
                                    if let str = value as? String {
                                        if str.rangeOfString(User.gameTitleInfo["titleName"]!) != nil {
                                            if let url = list["trophyTitleIconUrl"] as? String {
                                                CurrentTrophies.parseJSONForTrophies(list)
                                                User.trophyTitleIconUrl = url
                                                callback(true)
                                                return
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        //If this fails (Like when logged in but not playing something)
                        let tm = TrophyManager()
                        tm.getMostRecentGame() {
                            callback(false)
                        }
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func getAllTrophies(callback: () -> Void) {
        AuthManager.getReqWithAuth() {
            Config.debug("Getting all trophies for: \(User.username)")
            
            let url = URL.prepURL(URL.allTrophyData,options: ["{{offset}}": "0"], region: nil, lang: nil)
            
            do {
                let headers = Network.PSNHeaders
                
                let opt = try HTTP.GET(url, headers: headers)
                
                opt.start() {
                    response in
                    
                    let data = Tools.parseAnyJSON(response.data)
                    if let data = data?["trophyTitles"] as? [[String: AnyObject]] {
                        Trophy.parseJSONForUserTrophies(data)
                    }
                    callback()
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func getAllFriendTrophies(friend: String,callback: ([Trophy]?) -> Void) {
        AuthManager.getReqWithAuth() {
            Config.debug("Getting all trophies for: \(friend)")
            
            let url = URL.prepURL(URL.allTrophyCompare,options: ["{{offset}}": "0", "{{user}}": friend], region: nil, lang: nil)
            
            do {
                let headers = Network.PSNHeaders
                
                let opt = try HTTP.GET(url, headers: headers)
                
                opt.start() {
                    response in
                    
                    let data = Tools.parseAnyJSON(response.data)
                    if let data = data?["trophyTitles"] as? [[String: AnyObject]] {
                        let trophies = Trophy.parseJSONForFriendTrophies(data)
                        callback(trophies)
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