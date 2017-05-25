//
//  KeyboardHandler.swift
//  InsanelySImpleTracker
//
//  Created by Konstantinos Tsoleridis on 24.05.17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardHandler: class {
    
    var bottomConstraint: NSLayoutConstraint! { get set }
    
    func keyboardWillShow(_ notification: Notification)
    func keyboardWillHide(_ notification: Notification)
    func startObservingKeyboardChanges()
    func stopObservingKeyboardChanges()
}


extension KeyboardHandler where Self: UIViewController {
    
    func startObservingKeyboardChanges() {
        
        // NotificationCenter observers
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (notification) in
            self.keyboardWillShow(notification)
        }
        
        // Deal with rotations
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, queue: nil) { (notification) in
            self.keyboardWillShow(notification)
        }
        
        // Deal with keyboard change (emoji, numerical, etc.)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextInputCurrentInputModeDidChange, object: nil, queue: nil) { (notification) in
            self.keyboardWillShow(notification)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { (notification) in
            self.keyboardWillHide(notification)
        }
    }
    
    
    func keyboardWillShow(_ notification: Notification) {
        
        let verticalPadding: CGFloat = 5 // Padding between the bottom of the view and the top of the keyboard
        
        guard let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = value.cgRectValue.height
        
        // Here you could have more complex rules, like checking if the textField currently selected is actually covered by the keyboard, but that's out of this scope.
        self.bottomConstraint.constant = keyboardHeight + verticalPadding
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    
    func keyboardWillHide(_ notification: Notification) {
        self.bottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    
    func stopObservingKeyboardChanges() {
        NotificationCenter.default.removeObserver(self)
    }
    
}
