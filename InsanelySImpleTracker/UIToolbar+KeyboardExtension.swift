//
//  UIToolbar+KeyboardExtension.swift
//  InsanelySImpleTracker
//
//  Created by Konstantinos Tsoleridis on 08.06.17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func appendToolBarWithDismissKeyBoardButton() -> UIView {
        let doneToolbar: UIToolbar = UIToolbar()
        doneToolbar.barStyle = .default
        doneToolbar.sizeToFit()
        let doneButton: UIBarButtonItem  = UIBarButtonItem(image: #imageLiteral(resourceName: "DismissKeyboardIcon"), style: .done, target: self, action: #selector(self.doneButtonAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        doneToolbar.items = [flexSpace, doneButton]
        return doneToolbar
    }
    
    func doneButtonAction () {
        self.view.endEditing(true)
    }
    
}
