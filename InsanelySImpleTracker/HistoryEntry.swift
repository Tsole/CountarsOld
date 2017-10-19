//
//  HistoryEntry.swift
//  Countars
//
//  Created by Konstantinos Tsoleridis on 20.06.17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryEntry: Object {
    
    @objc dynamic var date = NSDate()
    @objc dynamic var counterValue: Int = 0
    
}
