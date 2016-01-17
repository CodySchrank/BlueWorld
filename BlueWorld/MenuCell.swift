//
//  MenuCell.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/8/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func initCell(title: String?) {
        if let title = title {
            titleLabel.text = title
        }
    }
}
