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
    @IBOutlet var textView: UITextView!

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

        if  counter.counterNotes.characters.count > 0 {
            textView.text = counter.counterNotes
        } else {
            textView.textColor = UIColor.lightGray
            textView.text = "You can enter some notes here."
        }

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
        CountersManager.sharedInstance.updateCounter(counter: &counter, counterName: renameTextField.text!, count: Int(countTextfield.text!)!, notes: textView.text, step: Int(stepTextField.text!)!)
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
        //TODO: move it to an extension of UIToolBar
        let doneAndDateToolbar: UIToolbar = UIToolbar()
        doneAndDateToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem  = UIBarButtonItem(image: #imageLiteral(resourceName: "DismissKeyboardIcon"), style: .done, target: self, action: #selector(self.doneButtonAction))
        let addDate: UIBarButtonItem = UIBarButtonItem(title: "Add Date", style: .plain, target: self, action: #selector(self.didPressAddDateButton))

        doneAndDateToolbar.items = [addDate,flexSpace,doneButton]
        doneAndDateToolbar.sizeToFit()

        renameTextField.inputAccessoryView = appendToolBarWithDismissKeyBoardButton()
        countTextfield.inputAccessoryView = appendToolBarWithDismissKeyBoardButton()
        countTextfield.inputAccessoryView = appendToolBarWithDismissKeyBoardButton()
        stepTextField.inputAccessoryView = appendToolBarWithDismissKeyBoardButton()
        textView.inputAccessoryView = doneAndDateToolbar
    }


    func didPressAddDateButton() {
        self.textView.text.append(CachedDateFormatter.dateFormatter.string(from:Date()))
    }


    @IBAction func didPressShowHistoryButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showHistory", sender: nil)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHistory" {
            var historyTVC = segue.destination as! HistoryTVC
            guard let historyEntries = counter?.historyEntries else {
                return
            }
            historyTVC.histroyEntries = Array(historyEntries)
        }
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


    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }


    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "You can enter some notes here."
            textView.textColor = UIColor.lightGray
        }
    }
}
