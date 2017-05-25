//
//  RoundedRectUIButton.swift
//  InsanelySImpleTracker
//
//  Created by Konstantinos Tsoleridis on 24.05.17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import UIKit

class RoundedRectUIButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.backgroundColor = .clear
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        let blueColor = UIColor.init(red: 92/255 , green: 143/255, blue: 220/255, alpha: 1)
        self.layer.borderColor = blueColor.cgColor
        
    }
 

}
