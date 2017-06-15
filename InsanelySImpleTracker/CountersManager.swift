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
    
    
    func updateCounter(counter: inout Counter, counterName: String, count: Int, notes: String, step: Int) {

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
            counter.step = step
        }
    }
    
    
    func deleteAllEntries() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    
    func decreaseCoutnerValue(counter: inout Counter) {

        guard counter.count-counter.step >= CounterConstants.minCounterValue else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "minValue"), object: nil, userInfo: nil)
            return
        }

        let realm = try! Realm()
        try! realm.write {
            counter.count -= counter.step
        }
    }
    
    
    func increaseCoutnerValue(counter: inout Counter) {

        guard counter.count + counter.step <= CounterConstants.maxCounterValue else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "maxValue"), object: nil, userInfo: nil)
            return
        }

        let realm = try! Realm()
        try! realm.write {
            counter.count += counter.step
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
        createCounter(counterName: "💧 Glasses of water today", initialCount: 2)
        createCounter(counterName: "💪 Push ups record", initialCount: 35)
        createCounter(counterName: "📚 Books this year", initialCount: 6)
        createCounter(counterName: "🎬 Movies this month", initialCount: 3)
        createCounter(counterName: "🎂 Days until birthday", initialCount: 27)
        createCounter(counterName: "Days without smoking", initialCount: 39)
    }
    
    func resetCounter(counter: inout Counter, completionHandler: () -> Void) {
        let realm = try! Realm()
        try! realm.write {
            counter.count = 0
            completionHandler()
        }
    }
}
