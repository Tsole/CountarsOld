//
//  NotesViewController.swift
//  Countars
//
//  Created by Konstantinos Tsoleridis on 16.07.17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    weak var counter: Counter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        // Do any additional setup after loading the view.
        guard let counter = counter else {
            return
        }
        
        if  counter.counterNotes.characters.count > 0 {
            textView.text = counter.counterNotes
        } else {
            textView.textColor = UIColor.lightGray
            textView.text = "You can enter some notes here."
        }
        
        let doneAndDateToolbar: UIToolbar = UIToolbar()
        doneAndDateToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem  = UIBarButtonItem(image: #imageLiteral(resourceName: "DismissKeyboardIcon"), style: .done, target: self, action: #selector(self.doneButtonAction))
        let addDate: UIBarButtonItem = UIBarButtonItem(title: "Add Date", style: .plain, target: self, action: #selector(self.didPressAddDateButton))
        
        doneAndDateToolbar.items = [addDate,flexSpace,doneButton]
        doneAndDateToolbar.sizeToFit()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        textView.inputAccessoryView = doneAndDateToolbar
    }
    
    //scroll for textview in order to show keyboard
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            self.textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        // If you want it to apply to a regular scroll view, just take out the last two lines - they are in there so that the text view readjusts itself so the user doesn't lose their place while editing
        let selectedRange = textView.selectedRange
        self.textView.scrollRangeToVisible(selectedRange)
    }
    
    
    @objc func didPressAddDateButton() {
        self.textView.text.append(CachedDateFormatter.dateFormatter.string(from:Date()))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension NotesViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard var counter = counter else {
            return
        }
        CountersManager.sharedInstance.updateCounterNotes(counter: &counter, notes: textView.text)
    }
}
