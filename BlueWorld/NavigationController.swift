//
//  NavigationController.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/4/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UINavigationBarDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor(red: 48/255, green: 62/255, blue: 80/255, alpha: 1)
        self.navigationBar.barStyle = .Black
    }
}