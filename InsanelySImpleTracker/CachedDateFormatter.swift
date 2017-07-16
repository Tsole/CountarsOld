//
//  CachedDateFormatter.swift
//  Countars
//
//  Created by Tsole on 25/6/17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import Foundation
class CachedDateFormatter {

    static let monthYearFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM - YYYY"
        return dateFormatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

}
