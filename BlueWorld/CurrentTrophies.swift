//
//  Trophies.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/8/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import Foundation

class CurrentTrophies {
    
    static var currentGameProgess = 0
    static var currentGameEarnedTrophies = ["bronze": 0,"silver": 0,"gold": 0,"platinum": 0]
    static var currentGameDefinedTrophies = ["bronze": 0,"silver": 0,"gold": 0,"platinum": 0]
    
    static var currentGameEarnedTrophiesTotal: Int {
        get {
            return currentGameEarnedTrophies["bronze"]! + currentGameEarnedTrophies["silver"]! + currentGameEarnedTrophies["gold"]! + currentGameEarnedTrophies["platinum"]!
        }
    }
    
    static var currentGameDefinedTrophiesTotal: Int {
        get {
            return currentGameDefinedTrophies["bronze"]! + currentGameDefinedTrophies["silver"]! + currentGameDefinedTrophies["gold"]! + currentGameDefinedTrophies["platinum"]!
        }
    }
    
    static func parseJSONForTrophies(data: AnyObject) {
        if let trophies = data["trophyTitles"]??[0]?["fromUser"]??["earnedTrophies"] as? [String:Int] {
            for (key,value) in trophies {
                currentGameEarnedTrophies[key] = value
            }
        } else if let trophies = data["fromUser"]??["earnedTrophies"] as? [String: Int] {
            for (key,value) in trophies {
                currentGameEarnedTrophies[key] = value
            }
        }
        
        if let trophies = data["trophyTitles"]??[0]?["definedTrophies"] as? [String:Int] {
            for (key,value) in trophies {
                currentGameDefinedTrophies[key] = value
            }
        } else if let trophies = data["definedTrophies"] as? [String: Int] {
            for (key,value) in trophies {
                currentGameDefinedTrophies[key] = value
            }
        }
        
        if let progress = data["trophyTitles"]??[0]?["fromUser"]??["progress"] as? Int {
            currentGameProgess = progress
        } else if let progress = data["fromUser"]??["progress"] as? Int {
            currentGameProgess = progress
        }
    }
}