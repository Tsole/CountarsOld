//
//  CountersManager.swift
//  InsanelySImpleTracker
//
//  Created by Tsole on 9/5/17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import Foundation
import RealmSwift

class CountersManager {
    
    static let sharedInstance = CountersManager()
    
    
    var counters: [Counter] {
        let realm = try! Realm()
        let counters = realm.objects(Counter.self)
        return Array(counters.sorted(byKeyPath: "creationDate", ascending: false))
    }
    
    
    func createCounter(counterName: String, initialCount: Int) {
        let counter = Counter(value: [counterName, initialCount])
        let realm = try! Realm()
        try! realm.write {
            realm.add(counter)
        }
    }
    
    
    func updateCounter(counter: inout Counter, counterName: String, count: Int, notes: String) {

        guard count <= CounterConstants.maxCounterValue else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "maxValue"), object: nil, userInfo: nil)
            return
        }

        guard count >= CounterConstants.minCounterValue else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "minValue"), object: nil, userInfo: nil)
            return
        }

        let realm = try! Realm()
        try! realm.write {
            counter.counterName = counterName
            counter.count = count
            counter.counterNotes = notes
        }
    }
    
    
    func deleteAllEntries() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    
    func decreaseCoutnerValue(counter: inout Counter) {

        guard counter.count-1 >= CounterConstants.minCounterValue else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "minValue"), object: nil, userInfo: nil)
            return
        }

        let realm = try! Realm()
        try! realm.write {
            counter.count -= 1
        }
    }
    
    
    func increaseCoutnerValue(counter: inout Counter) {

        guard counter.count + 1 <= CounterConstants.maxCounterValue else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "maxValue"), object: nil, userInfo: nil)
            return
        }

        let realm = try! Realm()
        try! realm.write {
            counter.count += 1
        }
    }
    
    
    func deleteCounter(counter: inout Counter, completionHandler: () -> Void) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(counter)
            completionHandler()
        }
    }
    
    
    func createPlaceholderCounters() {
        createCounter(counterName: "counter1", initialCount: 0)
        createCounter(counterName: "counter2", initialCount: 0)
        createCounter(counterName: "counter3", initialCount: 0)
        createCounter(counterName: "counter4", initialCount: 0)
        createCounter(counterName: "counter5", initialCount: 0)
        createCounter(counterName: "counter6", initialCount: 0)
        createCounter(counterName: "counter7", initialCount: 0)
        createCounter(counterName: "counter8", initialCount: 0)
        createCounter(counterName: "counter9", initialCount: 0)
        createCounter(counterName: "counter10", initialCount: 0)
        createCounter(counterName: "counter11", initialCount: 0)
        createCounter(counterName: "counter12", initialCount: 0)
        createCounter(counterName: "counter13", initialCount: 0)
        createCounter(counterName: "counter14", initialCount: 0)
        createCounter(counterName: "counter15", initialCount: 0)
        createCounter(counterName: "counter16", initialCount: 0)
        createCounter(counterName: "counter17", initialCount: 0)
        createCounter(counterName: "counter18", initialCount: 0)
        createCounter(counterName: "counter19", initialCount: 0)
    }
    
}
