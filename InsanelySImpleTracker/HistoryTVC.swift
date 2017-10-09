//
//  HistoryTVC.swift
//  Countars
//
//  Created by Konstantinos Tsoleridis on 23.06.17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryTVC: UITableViewController {
    
    var histroyEntries:[HistoryEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return histroyEntries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = String(histroyEntries[indexPath.row].counterValue)
        cell.detailTextLabel?.text = CachedDateFormatter.dateFormatter.string(from: histroyEntries[indexPath.row].date as Date)
        cell.selectionStyle = .none

        return cell
    }
}
