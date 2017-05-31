//
//  CounterDetailViewController.swift
//  InsanelySImpleTracker
//
//  Created by Konstantinos Tsoleridis on 24.05.17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import UIKit

class CounterDetailViewController: UITableViewController {
    
    @IBOutlet weak var renameTextField: UITextField!
    @IBOutlet weak var countTextfield: UITextField!
    @IBOutlet var textView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var counter: Counter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textView.delegate = self
        self.addDoneButtonOnKeyboard()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50 // or something
        
        guard let counter = counter else {
            return
        }
        
        renameTextField.text = counter.counterName
        countTextfield.text = String(describing: counter.count)
        textView.text = counter.counterNotes
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //        stopObservingKeyboardChanges()
        
        guard var counter = counter else {
            return
        }
     CountersManager.sharedInstance.updateCounter(counter: &counter, counterName: renameTextField.text!, count: Int(countTextfield.text!)!, notes: textView.text)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    //MARK: keyboard toolbar
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.renameTextField.inputAccessoryView = doneToolbar
        self.countTextfield.inputAccessoryView = doneToolbar
        self.textView.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction() {
        self.renameTextField.resignFirstResponder()
        self.countTextfield.resignFirstResponder()
        self.textView.resignFirstResponder()
    }
}

extension CounterDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }
}
