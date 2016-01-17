//
//  SettingsTableViewController.swift
//  BlueWorld
//
//  Created by Cody Schrank on 1/13/16.
//  Copyright © 2016 TheTapAttack. All rights reserved.
//

import UIKit
import CoreData

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var autoLoginSwitch: UISwitch!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func logoutButtonPressed(sender: UIButton) {
        let fetchRequest = NSFetchRequest(entityName: "UserModel")
        
        do {
            let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as! [UserModel]
            managedObjectContext.deleteObject(fetchResults.first!)
            try managedObjectContext.save()
        } catch let e {
            print(e)
        }
        User.reset()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.layer.borderWidth = 2
        logoutButton.layer.borderColor = UIColor.whiteColor().CGColor
        logoutButton.layer.cornerRadius = 10
        logoutButton.clipsToBounds = true
        
        logoutButton.backgroundColor = UIColor(red: 207/255, green: 0/255, blue: 15/255, alpha: 0.9)
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        autoLoginSwitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        let url = databaseURL()
        let stylesheet = NSDictionary(contentsOfURL:url!)
        
        print(stylesheet)
        
        let autoLogin = stylesheet!["AutoLogin"] as! Bool
        
        autoLoginSwitch.setOn(autoLogin, animated: true)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func stateChanged(switchState: UISwitch) {
        let url = databaseURL()
        let stylesheet = NSMutableDictionary(contentsOfURL: url!)
        if switchState.on {
            stylesheet?.setValue(true, forKey: "AutoLogin")
            stylesheet?.writeToURL(url!, atomically: true)
        } else {
            stylesheet?.setValue(false, forKey: "AutoLogin")
            stylesheet?.writeToURL(url!, atomically: true)
        }
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
    
    func databaseURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        // If array of path is empty the document folder not found
        guard urls.count == 0 else {
            let finalDatabaseURL = urls.first!.URLByAppendingPathComponent("Settings.plist")
            // Check if file reachable, and if reacheble just return path
            guard finalDatabaseURL.checkResourceIsReachableAndReturnError(nil) else {
                // Check if file is exists in bundle folder
                if let bundleURL = NSBundle.mainBundle().URLForResource("Settings", withExtension: "plist") {
                    // if exist we will copy it
                    do {
                        try fileManager.copyItemAtURL(bundleURL, toURL: finalDatabaseURL)
                    } catch _ {
                        print("File copy failed!")
                    }
                } else {
                    print("Our file not exist in bundle folder")
                    return nil
                }
                return finalDatabaseURL
            }
            return finalDatabaseURL
        }
        return nil
    }

}
