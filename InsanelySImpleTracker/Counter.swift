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
    static let maxCounterValue: Int =  2147483646
    static let minCounterValue: Int = -2147483644
}

class Counter: Object {
    
    dynamic var counterName = ""
    dynamic var count: Int = 0
    dynamic var counterID = UUID().uuidString
    dynamic var creationDate = NSDate()
    dynamic var counterNotes = ""
    dynamic var step = 1
    
    var historyEntries = List<HistoryEntry>()
        
    override static func primaryKey() -> String? {
        return "counterID"
    }
}
