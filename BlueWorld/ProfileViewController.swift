//
//  ProfileViewController.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/15/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let menuItems = ["Trophies","Recent Activity"]
    
    var trophiesBeingShown = [Trophy]()
    var activitiesBeingShown = [Activity]()
    
    var showingAllTrophies = false
    var recentActivityOffset = 0
    
    var friend = ""
    var friendTrophies = [Trophy]()
    
    let trophyManager = TrophyManager()
    let profileManager = ProfileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if friend == "" {
            trophyManager.getAllTrophies() {
                dispatch_async(dispatch_get_main_queue()) {
                    self.load()
                    self.tableView.reloadData()
                }
            }
            
            profileManager.getFeed(recentActivityOffset) {
                dispatch_async(dispatch_get_main_queue()) {
                    for activity in Activity.UserActivity {
                        self.activitiesBeingShown.append(activity)
                    }
                    self.tableView.reloadData()
                }
            }
        } else {
            trophyManager.getAllFriendTrophies(friend) {
                trophies in
                dispatch_async(dispatch_get_main_queue()) {
                    if let trophies = trophies {
                        self.friendTrophies = trophies
                    }
                    self.friendLoad()
                    self.tableView.reloadData()
                }
            }
            profileManager.getFriendFeed(friend,offset: recentActivityOffset) {
                activities in
                dispatch_async(dispatch_get_main_queue()) {
                    if let activities = activities {
                        for activity in activities {
                            self.activitiesBeingShown.append(activity)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.revealViewController() != nil {
            self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().frontViewController.revealViewController().tapGestureRecognizer()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.revealViewController() != nil {
            self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().frontViewController.view.userInteractionEnabled = true
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + menuItems.count + self.trophiesBeingShown.count + self.activitiesBeingShown.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath) as! ProfileCell
            if friend != "" {
                for f in User.Friends {
                    if f.onlineId == self.friend {
                        print(f)
                        cell.initCell(f)
                    }
                }
            } else {
                cell.initCell(nil)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
            cell.initCell(menuItems[0])
            return cell
        case 2..<(2 + self.trophiesBeingShown.count) where self.trophiesBeingShown.count != 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("TrophyCell", forIndexPath: indexPath) as! TrophyCell
            cell.initCell(self.trophiesBeingShown[indexPath.row - 2])
            return cell
        case 2 + self.trophiesBeingShown.count where self.trophiesBeingShown.count != 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("LoadMoreCell", forIndexPath: indexPath)
            return cell
        case 3 + self.trophiesBeingShown.count:
            let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
            cell.initCell(menuItems[1])
            return cell
        case (4 + self.trophiesBeingShown.count)..<(4 + self.trophiesBeingShown.count + self.activitiesBeingShown.count):
            let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as! ActivityCell
            cell.initCell(self.activitiesBeingShown[indexPath.row - 4 - self.trophiesBeingShown.count])
            return cell
        case 4 + self.trophiesBeingShown.count + self.activitiesBeingShown.count:
            let cell = tableView.dequeueReusableCellWithIdentifier("LoadMoreCell", forIndexPath: indexPath)
            return cell
        default:
            let cell = UITableViewCell(frame: CGRectZero)
            cell.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2 + self.trophiesBeingShown.count {
            showingAllTrophies ? (self.showingAllTrophies = false) : (self.showingAllTrophies = true)
            (self.friend == "") ? self.load() : self.friendLoad()
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        if indexPath.row == 4 + self.trophiesBeingShown.count + self.activitiesBeingShown.count {
            recentActivityOffset++
            if self.friend == "" {
                profileManager.getFeed(recentActivityOffset) {
                    dispatch_async(dispatch_get_main_queue()) {
                        for activity in Activity.UserActivity {
                            self.activitiesBeingShown.append(activity)
                        }
                        self.tableView.reloadData()
                    }
                }
            } else {
                profileManager.getFriendFeed(friend,offset: recentActivityOffset) {
                    activities in
                    dispatch_async(dispatch_get_main_queue()) {
                        if let activities = activities {
                            for activity in activities {
                                self.activitiesBeingShown.append(activity)
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func load() {
        self.trophiesBeingShown = []
        if showingAllTrophies {
            self.trophiesBeingShown = Trophy.UserTrophies
        } else {
            for (index,trophy) in Trophy.UserTrophies.enumerate() {
                if index == 5 {
                    break
                }
                self.trophiesBeingShown.append(trophy)
            }
        }
    }
    
    func friendLoad() {
        self.trophiesBeingShown = []
        if showingAllTrophies {
            self.trophiesBeingShown = self.friendTrophies
        } else {
            for (index,trophy) in self.friendTrophies.enumerate() {
                if index == 5 {
                    break
                }
                self.trophiesBeingShown.append(trophy)
            }
        }
    }
}