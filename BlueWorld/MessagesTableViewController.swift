//
//  MessagesTableViewController.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/10/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let messagesManager = MessagesManager()
    
    var timer: NSTimer? = nil
    
    /**
         Need to implement a func that runs every 10 secs to see if there is a new message
         Also, implenent hasRead for each messageGroup, and if they haven't, then change the bg color.
     **/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.7)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        load()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(MessagesTableViewController.reload), userInfo: nil, repeats: true)
        
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.revealViewController().tapGestureRecognizer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.view.userInteractionEnabled = true
    }
    
    func load() {
        messagesManager.getMessageGroup(true) {
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    func reload() {
        messagesManager.getMessageGroup(false) {
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.timer?.invalidate()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageGroup.Group.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! MessageCell
        cell.initCell(MessageGroup.Group[indexPath.row])
        if MessageGroup.Group[indexPath.row].seenFlag == false {
            cell.backgroundColor = .grayColor()
        } else {
            cell.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let message = MessageGroup.Group[indexPath.row]
        let vc = MessageDetailViewController()
        
        vc.message = message
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reloadDistance = CGFloat(50)
        if y > (h + reloadDistance) {
            reload()
        }
    }
}
