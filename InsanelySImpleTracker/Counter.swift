//
//  Counter.swift
//  InsanelySImpleTracker
//
//  Created by Tsole on 9/5/17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import UIKit
import RealmSwift

class Counter: Object {
    
    dynamic var counterID = UUID().uuidString
    dynamic var counterName = ""
    dynamic var count = 0
    dynamic var creationDate = NSDate()

    override static func primaryKey() -> String? {
        return "counterID"
    }
}
