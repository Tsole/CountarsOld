//
//  String+Extension.swift
//  InsanelySImpleTracker
//
//  Created by Konstantinos Tsoleridis on 31.05.17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import Foundation

extension String  {
    var isNumber : Bool {
        get {
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
}
