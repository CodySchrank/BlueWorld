//
//  MenuController.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/4/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import Foundation
import UIKit

class MenuController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarBackground = UIView(frame: CGRect(x: 0, y: -22, width: 320, height: 22))
        statusBarBackground.backgroundColor = UIColor(red: 48/255, green: 62/255, blue: 80/255, alpha: 90/100)
        self.view.addSubview(statusBarBackground)
        
        //The first page is the home page so we select it when this loads.
        tableView.selectRowAtIndexPath(NSIndexPath(forItem: 1, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
        
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        //Idk why but they each neaded their own selectedBackgroundView, also idk why but this only works in the viewDidAppear(they dont exist yet in viewDidLoad) and not the delegate method :didSelectRowAtIndexPath
        let color = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
        let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
        let view1 = UIView(frame: cell1!.bounds)
        view1.backgroundColor = color
        cell1?.selectedBackgroundView = view1
        
        let cell2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0))
        let view2 = UIView(frame: cell2!.bounds)
        view2.backgroundColor = color
        cell2?.selectedBackgroundView = view2
        
        let cell3 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0))
        let view3 = UIView(frame: cell3!.bounds)
        view3.backgroundColor = color
        cell3?.selectedBackgroundView = view3
        
        let cell4 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0))
        let view4 = UIView(frame: cell4!.bounds)
        view4.backgroundColor = color
        cell4?.selectedBackgroundView = view4
        
        let cell5 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 5, inSection: 0))
        let view5 = UIView(frame: cell5!.bounds)
        view5.backgroundColor = color
        cell5?.selectedBackgroundView = view5
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell?.backgroundColor = .grayColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        //Returns the cells back to blue after they were selected, similar problem with the selectedBackground
        let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
        cell1?.backgroundColor = UIColor(red: 48/255, green: 62/255, blue: 80/255, alpha: 90/100)
        
        let cell2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0))
        cell2?.backgroundColor = UIColor(red: 48/255, green: 62/255, blue: 80/255, alpha: 90/100)
        
        let cell3 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0))
        cell3?.backgroundColor = UIColor(red: 48/255, green: 62/255, blue: 80/255, alpha: 90/100)
        
        let cell4 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0))
        cell4?.backgroundColor = UIColor(red: 48/255, green: 62/255, blue: 80/255, alpha: 90/100)
        
        let cell5 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 5, inSection: 0))
        cell5?.backgroundColor = UIColor(red: 48/255, green: 62/255, blue: 80/255, alpha: 90/100)
    }
}