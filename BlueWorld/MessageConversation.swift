//
//  MessageConversation.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/13/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class MessageConversation {
    var conversation = [JSQMessage]()
    
    let outgoingBubbleImageData = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(.jsq_messageBubbleGreenColor())
    
    let incomingBubbleImageData = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(.jsq_messageBubbleLightGrayColor())
    
    func sortMessages(conversation: [[String: AnyObject]], messageGroupUid: String) {
        self.conversation = []

        for message in conversation {
            guard let senderId = message["senderOnlineId"] as? String where senderId != "" else {
                continue
            }
            
            guard let body = message["body"] as? String where body != "" else {
                continue
            }
            
            guard let receivedDate = message["receivedDate"] as? String where receivedDate != "" else {
                continue
            }
            
            guard let messageUid = message["messageUid"] as? Int where messageUid != -1 else {
                continue
            }
            
            var seenFlag = true
            if let _seenFlag = message["seenFlag"] as? Bool {
                if _seenFlag == false {
                    seenFlag = false
                }
            }
            
            if !seenFlag {
                let messagesManager = MessagesManager()
                
                messagesManager.seenFlag(messageGroupUid, messageUid: String(stringInterpolationSegment: messageUid)) {
                    
                }
            }
            
            // create dateFormatter with UTC time format
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            let date = dateFormatter.dateFromString(receivedDate)
            
            let newMessage = JSQMessage(senderId: senderId, senderDisplayName: senderId, date: date, text: body)
            self.conversation.append(newMessage)
        }
        self.conversation = self.conversation.reverse()
    }
}
