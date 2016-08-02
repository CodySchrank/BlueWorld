//
//  MessageDetailViewController.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/12/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Foundation
import SwiftHTTP
import iAd

class MessageDetailViewController: JSQMessagesViewController, ADBannerViewDelegate {
    
    let messagesManager = MessagesManager()
    
    let messageConversation = MessageConversation()
    
    var name: String? = nil
    
    var message: MessageGroup?
    
    var timer: NSTimer? = nil
    
    var gettingAvatar = false
    
    var _incomingAvatarImage: JSQMessagesAvatarImage? = nil
    
    var isSending = false
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var incomingAvatarImage: JSQMessagesAvatarImage? {
        get {
            if self._incomingAvatarImage != nil {
                return _incomingAvatarImage
            }
            if let avatar = message?.avatar {
               _incomingAvatarImage = JSQMessagesAvatarImage(avatarImage: avatar, highlightedImage: avatar, placeholderImage: avatar)
                return _incomingAvatarImage
            } else {
                self.getIncomingAvatar()
                self.gettingAvatar = true
                return nil
            }
        }
        
        set(avatar) {
            _incomingAvatarImage = avatar
        }
    }
    
    var outgoingAvatarImage: JSQMessagesAvatarImage? {
        get {
            if let avatar = User.avatar {
                return JSQMessagesAvatarImage(avatarImage: avatar, highlightedImage: avatar, placeholderImage: avatar)
            } else {
                return nil
            }
        }
    }
    
    func getIncomingAvatar() {
        if !gettingAvatar {
            if let id = message?.membersExcludingTheUser[0] {
                let profileManager = ProfileManager()
                profileManager.getAvatar(id) {
                    avatar in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.incomingAvatarImage = JSQMessagesAvatarImage(avatarImage: avatar, highlightedImage: avatar, placeholderImage: avatar)
                        self.collectionView?.reloadData()
                    }
                }
            } else if let id = name {
                let profileManager = ProfileManager()
                profileManager.getAvatar(id) {
                    avatar in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.incomingAvatarImage = JSQMessagesAvatarImage(avatarImage: avatar, highlightedImage: avatar, placeholderImage: avatar)
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    func load() {
        if let id = message?.messageGroupId {
            messagesManager.getMessageConversation(id) {
                messages in
                dispatch_async(dispatch_get_main_queue()) {
                    self.messageConversation.sortMessages(messages, messageGroupUid: id)
                    self.finishReceivingMessageAnimated(true)
                }
            }
        }
    }
    
    func reload() {
        if isSending {
            return
        }
        if let id = message?.messageGroupId {
            messagesManager.getMessageConversation(id) {
                messages in
                dispatch_async(dispatch_get_main_queue()) {
                    self.messageConversation.sortMessages(messages, messageGroupUid: id)
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    func iAd() {
        if appDelegate.bannerView != nil {
            appDelegate.bannerView!.translatesAutoresizingMaskIntoConstraints = false
            appDelegate.bannerView!.delegate = self
            appDelegate.bannerView!.hidden = true
            view.addSubview(appDelegate.bannerView!)
            
            let viewsDictionary = ["bannerView": appDelegate.bannerView!]
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-62-[bannerView]", options: [], metrics: nil, views: viewsDictionary))
        }
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        print("Ad Loaded")
        appDelegate.bannerView?.hidden = false
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        print("Ad did not load, \(error)")
        appDelegate.bannerView?.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.tintColor = .whiteColor()
        if let name = message?.membersExcludingTheUser[0] {
            self.title = name
        } else {
            self.title = name
        }
        self.senderId = User.username
        self.senderDisplayName = User.username
        
        self.inputToolbar?.contentView?.leftBarButtonItemWidth = 0
        
        self.collectionView?.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
        
        load()
        iAd()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(MessageDetailViewController.reload), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        appDelegate.bannerView?.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.timer?.invalidate()
        appDelegate.bannerView?.hidden = true
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.messageConversation.conversation[indexPath.item] 
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messageConversation.conversation.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = self.messageConversation.conversation[indexPath.item]
        
        if message.senderId == self.senderId {
            return self.messageConversation.outgoingBubbleImageData
        }
        
        return self.messageConversation.incomingBubbleImageData
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = self.messageConversation.conversation[indexPath.item]
        
        if message.senderId == User.username {
            return self.outgoingAvatarImage
        }
        
        return self.incomingAvatarImage
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            let message = self.messageConversation.conversation[indexPath.item]
            return NSAttributedString(string: message.date.formattedRelativeString())
        }
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = self.messageConversation.conversation[indexPath.item]
        
        if message.senderId == User.username {
            cell.textView?.textColor = .whiteColor()
        } else {
            cell.textView?.textColor = .blackColor()
        }
        return cell
    }
    
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        isSending = true
        
        let newMessage = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        
        self.messageConversation.conversation.append(newMessage)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        self.finishSendingMessage()
        
        if let id = message?.messageGroupId {
            messagesManager.sendMessage(id, postData:["body":text,"fakeMessageUid":1234,"messageKind": 1]) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.isSending = false
                })
            }
        } else {
            print("No id")
        }
        
        self.view.endEditing(true)
    }

    override func didPressAccessoryButton(sender: UIButton!) {        
        self.inputToolbar?.contentView?.textView?.resignFirstResponder()
        let sheet = UIAlertController(title: "Media messages are still in development, stay tuned!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        sheet.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { (ish) -> Void in
            
        }))
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
}
