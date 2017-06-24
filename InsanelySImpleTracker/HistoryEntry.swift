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
    
    dynamic var date = NSDate()
    dynamic var counterValue: Int = 0
    
}
