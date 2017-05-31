//
//  ViewController.swift
//  InsanelySImpleTracker
//
//  Created by Tsole on 13/1/17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let countersManager = CountersManager.sharedInstance
    weak var actionToEnable : UIAlertAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        if countersManager.counters.count == 0 {
            CountersManager.sharedInstance.createPlaceholderCounters()
        }
        
        let deleteBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(showEditing(sender:)))
        self.navigationItem.leftBarButtonItem = deleteBarButtonItem
    }
    
    
    func showEditing(sender: UIBarButtonItem) {
        
        if (self.tableView.isEditing == true) {
            self.tableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "Edit"
        } else {
            self.tableView.isEditing = true
            self.navigationItem.leftBarButtonItem?.title = "Done"
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsCounter" {
            if let destinationVC = segue.destination as? CounterDetailViewController {
                let counterSelected = countersManager.counters[(tableView.indexPathForSelectedRow?.row)!]
                destinationVC.counter = counterSelected
            }
        }
    }
    
    
    @IBAction func addNewCounter(_ sender: Any) {
        self.tableView.isEditing = false
        let alertController = UIAlertController(title: "New Counter", message: "Enter the details of your new counter", preferredStyle: .alert)
        
        alertController.addTextField { (counterNameTextfield: UITextField) in
            counterNameTextfield.placeholder = "Name"
            counterNameTextfield.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        }
        
        alertController.addTextField { (initialCountTextField: UITextField) in
            initialCountTextField.placeholder = "0"
            initialCountTextField.text = "0"
            initialCountTextField.keyboardType = .numberPad
        }
        
        let createNewCounterAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (_ alertAction:UIAlertAction) -> Void in
            guard let nameEntered = alertController.textFields?[0].text else {
                return
            }
            if let countEntered = alertController.textFields?[1].text, countEntered.isNumber {
                CountersManager.sharedInstance.createCounter(counterName: nameEntered, initialCount: Int((alertController.textFields?[1].text)!)!)
            } else {
                CountersManager.sharedInstance.createCounter(counterName: nameEntered, initialCount: Int(0))
            }
            
            self.tableView.reloadData()
        })
        
        createNewCounterAction.isEnabled = false
        self.actionToEnable = createNewCounterAction
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(createNewCounterAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    
    func textChanged(_ sender:UITextField) {
        self.actionToEnable?.isEnabled  = (sender.text!.characters.count > 0)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return countersManager.counters.count
        } else {
            return 1
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countertCell") as! CounterCell
        cell.counter = countersManager.counters[indexPath.row]
        cell.titleLabel.text = countersManager.counters[indexPath.row].counterName
        cell.countLabel.text = String(countersManager.counters[indexPath.row].count)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("did select row at indexPath: " + String(describing: indexPath))
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var counterToDelete = CountersManager.sharedInstance.counters[indexPath.row]
            CountersManager.sharedInstance.deleteCounter(counter: &counterToDelete, completionHandler: {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            })
        }
    }
}


