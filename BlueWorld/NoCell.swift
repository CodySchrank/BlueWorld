//
//  NoCell.swift
//  BlueWorld
//
//  Created by Cody Schrank on 1/8/16.
//  Copyright © 2016 TheTapAttack. All rights reserved.
//

import Foundation

class NoCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func initCell(title: String) {
        titleLabel.text = title
    }
}