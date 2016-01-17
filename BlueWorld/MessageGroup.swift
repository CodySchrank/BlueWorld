//
//  MessageGroup.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/10/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import Foundation
import UIKit

class MessageGroup {
    var messageGroupId: String
    var membersExcludingTheUser: [String]
    var latestMessageUId: Int
    var seenFlag: Bool
    var latestMessageBody: String
    var lastUpdated: String
    var avatar: UIImage?
    
    static var Group: [MessageGroup] = []
    
    static var UnreadGroup: [MessageGroup] {
        get {
            var _UnreadGroup = [MessageGroup]()
            for message in MessageGroup.Group {
                if message.seenFlag == false {
                    _UnreadGroup.append(message)
                }
            }
            return _UnreadGroup
        }
    }
    
    init(messagesGroupId: String, members: [String],latestMessageUId: Int, seenFlag: Bool, latestMessageBody: String, lastUpdated: String) {
        self.messageGroupId = messagesGroupId
        self.membersExcludingTheUser = members
        self.latestMessageUId = latestMessageUId
        self.seenFlag = seenFlag
        self.latestMessageBody = latestMessageBody
        self.lastUpdated = lastUpdated
    }
    
    static func parseJSONForMessageGroup(firstTime: Bool,data: [[String: AnyObject]]?) {
        if let data = data {
            if !firstTime {
                for messageGroup in data {
                    if let newMessageGroupMember = newMessageGroup(messageGroup) {
                        for (index,message) in MessageGroup.Group.enumerate() {
                            if newMessageGroupMember.messageGroupId == message.messageGroupId {
                                if newMessageGroupMember.seenFlag == false {
                                    MessageGroup.Group[index] = newMessageGroupMember
                                }
                            }
                        }
                    }
                }
            } else {
                MessageGroup.Group = []
                for messageGroup in data {
                    let newMessageGroupMember = newMessageGroup(messageGroup)
                    if let newMessageGroupMember = newMessageGroupMember {
                        MessageGroup.Group.append(newMessageGroupMember)
                    }
                }
            }
        }
    }
    
    static func newMessageGroup(messageGroup: [String: AnyObject]) -> MessageGroup? {
        guard let MessageGroupId = messageGroup["messageGroupId"] as? String where MessageGroupId != "" else {
            return nil
        }
        
        guard let membersIncludingTheUser = messageGroup["messageGroupDetail"]?["members"] as? [[String:String]] where membersIncludingTheUser != [["":""]] else {
            return nil
        }
        
        guard let latestMessageUId = messageGroup["latestMessage"]?["messageUid"] as? Int where latestMessageUId != 0 else {
            return nil
        }
        
        var seenFlag = true
        if let seenFlagInMessageGroup = messageGroup["latestMessage"]?["seenFlag"] as? Bool {
            if seenFlagInMessageGroup == false {
                seenFlag = false
            }
        }
        
        guard let latestMessageBody = messageGroup["latestMessage"]?["body"] as? String where latestMessageBody != "" else {
            return nil
        }
        
        guard let lastUpdated = messageGroup["latestMessage"]?["receivedDate"] as? String where lastUpdated != "" else {
            return nil
        }
        
        var membersExcludingTheUser: [String] = []
        for member in membersIncludingTheUser {
            guard let member = member["onlineId"] where member != User.username else {
                continue
            }
            membersExcludingTheUser.append(member)
        }
        
        // create dateFormatter with UTC time format
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(lastUpdated)
        
        // change to a readable time format and change to local time zone
        let timeStamp = date?.formattedRelativeString()
        
        return MessageGroup(messagesGroupId: MessageGroupId, members: membersExcludingTheUser, latestMessageUId: latestMessageUId, seenFlag: seenFlag, latestMessageBody: latestMessageBody, lastUpdated: timeStamp!)
    }
}