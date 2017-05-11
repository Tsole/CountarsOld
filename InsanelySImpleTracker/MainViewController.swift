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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)

        countersManager.deleteAllEntries()

        debugPrint("Number of counters: " + String(countersManager.counters.count))

        if countersManager.counters.count == 0 {
            countersManager.createCounter(counterName: "counter1")
            countersManager.createCounter(counterName: "counter2")
            countersManager.createCounter(counterName: "counter3")
        }

        debugPrint("Number of counters: " + String(countersManager.counters.count))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else {
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countertCell")
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCounterCell") as! AddNewCounterCell
            return cell
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("did select row at indexPath: " + String(describing: indexPath))
    }
}

