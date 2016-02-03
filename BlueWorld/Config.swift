//
//  Config.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/2/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import Foundation

let debugging = false

class Config {
    static func debug(information: AnyObject) {
        if debugging {
            print(information)
        }
    }
}

