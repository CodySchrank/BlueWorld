//
//  NewMessageViewController.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/16/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: NewMessageView!
    
    @IBOutlet weak var sortTextField: UITextField!
    
    var sortedOnlineUsers = [User]()
    
    var sortedOfflineUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortedListOfNames("")
        
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.tintColor = .whiteColor()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 48/255, green: 62/255, blue: 80/255, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 48/255, green: 62/255, blue: 80/255, alpha: 1)
        
        tableView.delegate = self
        tableView.dataSource = self
        sortTextField.delegate = self
        
        sortTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        tableView.separatorColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.7)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.tableHeaderView = UIView(frame: CGRectZero)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.title = "Friends"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.revealViewController().tapGestureRecognizer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.view.userInteractionEnabled = true
    }
    
    func textFieldDidChange(textField: UITextField) {
        sortedListOfNames(textField.text!)
        self.tableView.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FriendCell
        self.performSegueWithIdentifier("friendSelected", sender: cell.nameLabel.text!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "friendSelected" {
            let vc = segue.destinationViewController as! ProfileViewController
            vc.friend = String(stringInterpolationSegment: sender!)
        }
    }
    
    func loadMessageDetail(name: String) {
        for friend in MessageGroup.Group {
            if friend.membersExcludingTheUser[0] == name {
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
                return
            }
        }
        let vc = MessageDetailViewController()
        
        vc.name = name
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        let viewControllers = self.navigationController!.viewControllers
        var newViewControllers = [UIViewController]()
        newViewControllers.append(viewControllers[0])
        newViewControllers.append(vc)
        self.navigationController!.setViewControllers(newViewControllers, animated: true)
    }
    
    func sortedListOfNames(sort: String) {
        sortedOnlineUsers = []
        sortedOfflineUsers = []
        if sort == "" {
            for friend in User.Friends {
                if friend.onlineStatus == "online" {
                    self.sortedOnlineUsers.append(friend)
                } else {
                    self.sortedOfflineUsers.append(friend)
                }
            }
        } else {
            for friend in User.Friends {
                let name = friend.onlineId.lowercaseString
                if name.containsString(sort.lowercaseString) {
                    if friend.onlineStatus == "online" {
                        self.sortedOnlineUsers.append(friend)
                    } else {
                        self.sortedOfflineUsers.append(friend)
                    }
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sortedOnlineUsers.count == 0 {
            return sortedOfflineUsers.count
        }
        if section == 0 {
            return sortedOnlineUsers.count
        } else {
            return sortedOfflineUsers.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sortedOnlineUsers.count == 0 {
            return "Offline Users"
        }
        if section == 0 {
            return "Online Users"
        } else {
            return "Offline Users"
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if sortedOnlineUsers.count == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! FriendCell
        
        if sortedOnlineUsers.count == 0 {
            cell.initCell(sortedOfflineUsers[indexPath.row])
        } else if indexPath.section == 0 {
            cell.initCell(sortedOnlineUsers[indexPath.row])
        } else {
            cell.initCell(sortedOfflineUsers[indexPath.row])
        }
        
        return cell
    }
}
