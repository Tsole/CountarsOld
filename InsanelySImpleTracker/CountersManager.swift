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
        return Array(realm.objects(Counter.self))
    }


    func createCounter(counterName: String) {

        let counter = Counter()
        counter.counterName = counterName
        let realm = try! Realm()

        try! realm.write {
            realm.add(counter)
        }

    }


    func deleteAllEntries() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

}
