//
//  CounterDetailViewController.swift
//  InsanelySImpleTracker
//
//  Created by Konstantinos Tsoleridis on 24.05.17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import UIKit
import DateToolsSwift

class CounterDetailViewController: UITableViewController {
    
    @IBOutlet weak var renameTextField: UITextField!
    @IBOutlet weak var countTextfield: UITextField!
    @IBOutlet weak var stepTextField: UITextField!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var repeatLabel: UILabel!
    
    var counter: Counter?
    var launchedFromNotification = false
    
    var reminderCellsHidden: Bool {
        guard let counter = counter else {
            return false
        }
        return !counter.hasReminder
    }
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addDoneButtonOnKeyboard()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50 // or something
        
        setUpUI()
        
        let doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismiss(animated:completion:)))
        if launchedFromNotification {
            self.navigationItem.leftBarButtonItem = doneButton
        }
        
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(self.resetCounter))
        self.navigationItem.rightBarButtonItem = resetButton
        
    }
    
    
    @objc func setUpUI() {
        
        guard let counter = counter else {
            return
        }
        
        if reminderCellsHidden {
            reminderSwitch.isOn = false
        } else {
            reminderSwitch.isOn = true
        }
        
        navigationItem.title = counter.counterName
        
        renameTextField.text = counter.counterName
        countTextfield.text = String(describing: counter.count)
        stepTextField.text = String(describing: counter.step)
        
        dateTextField.delegate = self
        countTextfield.delegate = self
        stepTextField.delegate = self
        renameTextField.delegate = self
        
        dateFormatter.dateFormat = "EEE, MMM d, yyyy HH:mm"
        
        dateTextField.text = dateFormatter.string(from: Date())
        repeatLabel.text = RepeatIntervall.descriptionBasedOnInt(int: counter.repeatIntervall)
        
        tableView.reloadData()
    }
    
    
    @objc func resetCounter() {
        guard let localCounter = counter else {
            return
        }
        CountersManager.sharedInstance.resetCounter(counter: &counter!) {
            countTextfield.text = String(localCounter.count)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.setUpUI), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.view.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        viewWillDisappear(true)
    }
    
    
    @IBAction func didCickRemindMeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            CountersManager.sharedInstance.updateReminderStatus(hasReminder: true, counter: &counter!)
            tableView.reloadData()
        } else {
            CountersManager.sharedInstance.updateReminderStatus(hasReminder: false, counter: &counter!)
            tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row != 0 && reminderCellsHidden {
            return 0
        }
        return UITableViewAutomaticDimension
    }
    
    
    @IBAction func didClickDateTextField(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        sender.inputView = datePickerView
        dateTextField.tintColor = UIColor.clear
        dateTextField.textColor = UIColor.blue
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    
    //MARK: keyboard toolbar
    func addDoneButtonOnKeyboard() {
        renameTextField.inputAccessoryView = appendToolBarWithDismissKeyBoardButton()
        countTextfield.inputAccessoryView = appendToolBarWithDismissKeyBoardButton()
        stepTextField.inputAccessoryView = appendToolBarWithDismissKeyBoardButton()
        dateTextField.inputAccessoryView = appendToolBarWithDismissKeyBoardButton()
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
        
        if segue.identifier == "showRepeatVC" {
            let repeatVC = segue.destination as! RepeatVC
            guard let counter = counter else {
                return
            }
            repeatVC.counter = counter
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
        
        if selectedCell?.reuseIdentifier == "showRepeatVC" {
            self.performSegue(withIdentifier: "showRepeatVC", sender: nil)
        }
    }
}


extension CounterDetailViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard var counter = counter else {
            return
        }
        
        if textField == dateTextField {
            dateTextField.textColor = UIColor.lightGray
            let delegate = UIApplication.shared.delegate as? AppDelegate
            let selectedDate = dateFormatter.date(from: dateTextField.text!)
            delegate?.scheduleNotification(at: selectedDate!, counter: counter)
        }
        
        if countTextfield.text?.characters.count == 0 {
            countTextfield.text = String(describing:counter.count)
        }
        
        if stepTextField.text?.characters.count == 0 {
            stepTextField.text = String(describing: counter.step)
        }
        
        //TODO: better handling of force unwrapping
        CountersManager.sharedInstance.updateCounter(counter: &counter, counterName: renameTextField.text!, count: Int(countTextfield.text!)!, step: Int(stepTextField.text!)!)
    }
}


