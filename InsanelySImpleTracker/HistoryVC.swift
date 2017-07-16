//
//  HistoryTVC.swift
//  Countars
//
//  Created by Konstantinos Tsoleridis on 23.06.17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var historyEntries:[HistoryEntry] = []
    var daysArray:[Date] = []
    var monthsArray:[Date] = []
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        //        let currentDate = Date()
        //
        //        let calendar = Calendar.current
        //
        //        let month = calendar.component(.month, from: currentDate)
        //        let day = calendar.component(.day, from: currentDate)
        self.buildDaysArray()
        self.buildMonthsArray()
        
        debugPrint(daysArray)
        debugPrint(monthsArray)
    }
    
    
    func buildDaysArray () {
        let dates = historyEntries.map { $0.date }
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        for date in dates {
            var dayComponents = calendar.dateComponents([.year, .month, .day], from: date as Date)
            dayComponents.hour = 0
            dayComponents.minute = 0
            dayComponents.second = 0
            let adjustedDate = calendar.date(from: dayComponents)
            if !daysArray.contains(adjustedDate!) {
                daysArray.append(adjustedDate!)
            }
        }
    }
    
    func buildMonthsArray() {
        let dates = historyEntries.map { $0.date }
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        for date in dates {
            var monthComponents = calendar.dateComponents([.year, .month, .day], from: date as Date)
            monthComponents.hour = 0
            monthComponents.minute = 0
            monthComponents.second = 0
            monthComponents.day = 1
            let adjustedDate = calendar.date(from: monthComponents)
            if !monthsArray.contains(adjustedDate!) {
                monthsArray.append(adjustedDate!)
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historyEntries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = String(historyEntries[indexPath.row].counterValue)
        cell.detailTextLabel?.text = CachedDateFormatter.monthYearFormatter.string(from: historyEntries[indexPath.row].date as Date)
        cell.selectionStyle = .none
        
        return cell
    }
}

