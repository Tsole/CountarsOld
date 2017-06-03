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
        
        guard var counter = counter else {
            return
        }
        
        //if the uses presses the back button while the counterTextfield is beeing editet and it is empty, automatically assign the value zero to the counter
        guard let currentCount = countTextfield.text?.characters.count, currentCount != 0 else {
            CountersManager.sharedInstance.updateCounter(counter: &counter, counterName: renameTextField.text!, count: 0, notes: textView.text)
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
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 30))
        doneToolbar.barStyle       = .default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem  = UIBarButtonItem(image: #imageLiteral(resourceName: "DismissKeyboardIcon"), style: .done, target: self, action: #selector(self.doneButtonAction))
        let addDate: UIBarButtonItem = UIBarButtonItem(title: "Add Date", style: .plain, target: self, action: #selector(self.didPressAddDateButton))
        
        var items = [UIBarButtonItem]()
        items.append(addDate)
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
    
    
    func didPressAddDateButton() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        self.textView.text.append(dateFormatter.string(from:currentDate))
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
