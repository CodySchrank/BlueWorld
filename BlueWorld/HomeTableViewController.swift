//
//  HomeViewController.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/3/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import UIKit
import Foundation
import iAd

class HomeTableViewController: UIViewController, ADBannerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var status = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    let menuItems = ["Friends Online","New Messages"]
    
    let profileManager = ProfileManager()
    
    let messageManager = MessagesManager()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let trophyManager = TrophyManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        iAd()
        
        setErrorObserver()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func setErrorObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ErrorPresentation:", name: Tools.ErrorNotification, object: nil)
    }
    
    func ErrorPresentation(notification: NSNotification) {
        let userInfo = notification.userInfo as! Dictionary<String,String!>
        let messageString = userInfo["error"]
        
        let alert = UIAlertController(title: "Network Error", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        load()

        appDelegate.bannerView?.hidden = false
        
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.revealViewController().tapGestureRecognizer()
    }
    
    func iAd() {
        if appDelegate.bannerView != nil {
            appDelegate.bannerView!.translatesAutoresizingMaskIntoConstraints = false
            appDelegate.bannerView!.delegate = self
            appDelegate.bannerView!.hidden = true
            view.addSubview(appDelegate.bannerView!)
            
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
            tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
            
            let viewsDictionary = ["bannerView": appDelegate.bannerView!]
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        appDelegate.bannerView?.hidden = true
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.view.userInteractionEnabled = true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + self.menuItems.count + (Bool(User.FriendsOnline.count) ? User.FriendsOnline.count : 1) + (Bool(MessageGroup.UnreadGroup.count) ? MessageGroup.UnreadGroup.count : 1)
    }
    
    var friendCount = 1
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("WelcomeCell", forIndexPath: indexPath) as!WelcomeCell
            cell.initCell()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("CurrentlyPlayingCell", forIndexPath: indexPath) as! CurrentlyPlayingCell
            cell.initCell(status)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
            cell.initCell(menuItems[0])
            return cell
        case 3 where User.FriendsOnline.count == 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("NoCell",forIndexPath: indexPath) as! NoCell
            cell.initCell("No friends online")
            return cell
        case 3..<(3 + User.FriendsOnline.count) where User.FriendsOnline.count != 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell",forIndexPath: indexPath) as! FriendCell
            cell.initCell(User.FriendsOnline[indexPath.row - 3])
            return cell
        case 3 + friendCount:
            let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
            cell.initCell(menuItems[1])
            return cell
        case 4 + friendCount..<(4 + friendCount + MessageGroup.UnreadGroup.count) where MessageGroup.UnreadGroup.count != 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! MessageCell
            let group = MessageGroup.UnreadGroup[indexPath.row - (4 + friendCount)]
            cell.initCell(group)
            return cell
        case 4 + friendCount where MessageGroup.UnreadGroup.count == 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("NoCell",forIndexPath: indexPath) as! NoCell
            cell.initCell("No new messages")
            return cell
        default:
            let cell = UITableViewCell(frame: CGRectZero)
            cell.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return 200
        default:
            return 50
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell is FriendCell {
            let typedCell = cell as! FriendCell
            self.performSegueWithIdentifier("friendFromHomeSegue", sender: typedCell.nameLabel.text!)
        } else if cell is MessageCell {
            let typedCell = cell as! MessageCell
            for friend in MessageGroup.Group {
                if friend.membersExcludingTheUser[0] == typedCell.nameLabel.text {
                    let vc = MessageDetailViewController()
                    
                    vc.message = friend
                    
                    let backItem = UIBarButtonItem()
                    backItem.title = ""
                    navigationItem.backBarButtonItem = backItem
                    
                    let viewControllers = self.navigationController!.viewControllers
                    var newViewControllers = [UIViewController]()
                    newViewControllers.append(viewControllers[0])
                    newViewControllers.append(vc)
                    self.navigationController!.setViewControllers(newViewControllers, animated: true)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "friendFromHomeSegue" {
            let rear = self.revealViewController().rearViewController as! MenuController
            let cell = rear.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
            cell?.selected = false
            
            let goingToCell = rear.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0))
            goingToCell?.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
            let vc = segue.destinationViewController as! ProfileViewController
            vc.friend = String(stringInterpolationSegment: sender!)
        }
    }

    func load() {
        profileManager.getProfile() {
            dispatch_async(dispatch_get_main_queue()) {
                /*
                * Now we have user data so lets get a bunch of info!
                * Anything else that requires user data will go below here
                */
                
                self.tableView.reloadData()
                
                if User.onlineStatus == "online" {
                    self.trophyManager.currentlyPlaying() {
                        playing in
                        dispatch_async(dispatch_get_main_queue()) {
                            if !playing {
                                self.status = "Recently Played"
                            } else {
                                self.status = "Currently Playing"
                            }
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    self.status = "Recently Played"
                    self.trophyManager.getMostRecentGame() {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                    }
                }
                
                self.profileManager.getFriends() {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.friendCount = Bool(User.FriendsOnline.count) ? User.FriendsOnline.count : 1
                        self.tableView.reloadData()
                    }
                }
                
                self.messageManager.getMessageGroup(true) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}















