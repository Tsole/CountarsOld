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
    @IBOutlet weak var stepTextField: UITextField!
    
    var counter: Counter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.addDoneButtonOnKeyboard()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50 // or something
        
        guard let counter = counter else {
            return
        }
        
        renameTextField.text = counter.counterName
        countTextfield.text = String(describing: counter.count)
        stepTextField.text = String(describing: counter.step)
        
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(self.resetCounter))
        self.navigationItem.rightBarButtonItem = resetButton
    }
    
    
    func resetCounter() {
        guard var counter = counter else {
            return
        }
        CountersManager.sharedInstance.resetCounter(counter: &counter) {
            countTextfield.text = String(describing: counter.count)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        guard var counter = counter else {
            return
        }
        
        if countTextfield.text?.characters.count == 0 {
            countTextfield.text = counter.counterName
        }
        
        if stepTextField.text?.characters.count == 0 {
            stepTextField.text = String(counter.step)
        }
        
        //TODO: better handling of force unwrapping
        CountersManager.sharedInstance.updateCounter(counter: &counter, counterName: renameTextField.text!, count: Int(countTextfield.text!)!, step: Int(stepTextField.text!)!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        viewWillDisappear(true)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    //MARK: keyboard toolbar
    func addDoneButtonOnKeyboard() {
        renameTextField.inputAccessoryView = appendToolBarWithDismissKeyBoardButton()
        countTextfield.inputAccessoryView = appendToolBarWithDismissKeyBoardButton()
        stepTextField.inputAccessoryView = appendToolBarWithDismissKeyBoardButton()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHistory" {
            let historyTVC = segue.destination as! HistoryTVC
            guard let historyEntries = counter?.historyEntries else {
                return
            }
            historyTVC.histroyEntries = Array(historyEntries)
        }
        
        if segue.identifier == "showNotes" {
            let notesVC = segue.destination as! NotesViewController
            guard let counter = counter else {
                return
            }
            notesVC.counter = counter
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        if selectedCell?.reuseIdentifier == "showNotes" {
            self.performSegue(withIdentifier: "showNotes", sender: nil)
        }
        if selectedCell?.reuseIdentifier == "showHistory" {
            self.performSegue(withIdentifier: "showHistory", sender: nil)
        }
    }
    
}


