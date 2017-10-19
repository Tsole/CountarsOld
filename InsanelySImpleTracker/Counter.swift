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
    
    @objc dynamic var counterName = ""
    @objc dynamic var count: Int = 0
    @objc dynamic var counterID = UUID().uuidString
    @objc dynamic var creationDate = NSDate()
    @objc dynamic var counterNotes = ""
    @objc dynamic var step = 1
    @objc dynamic var repeatIntervall = RepeatIntervall.never.rawValue
    @objc dynamic var hasReminder = false
    @objc dynamic var reminderDate: NSDate?
    
    var historyEntries = List<HistoryEntry>()
        
    override static func primaryKey() -> String? {
        return "counterID"
    }
}
