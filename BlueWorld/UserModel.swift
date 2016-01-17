//
//  UserModel.swift
//  BlueWorld
//
//  Created by Cody Schrank on 1/13/16.
//  Copyright © 2016 TheTapAttack. All rights reserved.
//

import Foundation
import CoreData

class UserModel: NSManagedObject {
    @NSManaged var email: String
    @NSManaged var password: String
}