//
//  Counter.swift
//  InsanelySImpleTracker
//
//  Created by Tsole on 9/5/17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import UIKit
import RealmSwift

enum CounterConstants {
    static let maxCounterValue = 100000000000000
    static let minCounterValue = -100000000000000
}

class Counter: Object {
    
    dynamic var counterName = ""
    dynamic var count: Int = 0
    dynamic var counterID = UUID().uuidString
    dynamic var creationDate = NSDate()
    dynamic var counterNotes = ""
    
    override static func primaryKey() -> String? {
        return "counterID"
    }
}
