//
//  RepeatVC.swift
//  Countars
//
//  Created by Konstantinos Tsoleridis on 07.08.17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import UIKit

enum RepeatIntervall: Int {
    case never = 0
    case daily
    case weekly
    case mothly
    case yearly
    
    func description() -> String {
        switch self {
        case .never:
            return "Never"
        case .daily:
            return "Every Day"
        case .weekly:
            return "Every Week"
        case .mothly:
            return "Every Month"
        case . yearly:
            return "Every Year"
        }
    }
    
    static func descriptionBasedOnInt(int: Int) -> String {
        if int == 0 {
            return "Never"
        }
        
        if int == 1 {
            return "Every Day"
        }
        
        if int == 2 {
            return "Every Week"
        }
        
        if int == 3 {
            return "Every Month"
        }
        
        if int == 4 {
            return "Every Year"
        }
        
        return "default interval"
    }
}


protocol RepeatVCDelegate {
    func repeatVC(sender: RepeatVC, didChoose intervall: RepeatIntervall?)
}


class RepeatVC: UITableViewController {
    
    @IBOutlet  var intervallCells: [UITableViewCell]!
    
    var repeatIntervall: RepeatIntervall = .daily
    var counter: Counter?
    var delegate: RepeatVCDelegate?
    
    
    override func viewDidLoad() {
        
        guard counter != nil else {
            return
        }
        
        repeatIntervall = RepeatIntervall(rawValue: (counter?.repeatIntervall)!)!
        
        for (index,cell) in intervallCells.enumerated() {
            if index == repeatIntervall.rawValue {
                cell.accessoryType = .checkmark
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        for cell in intervallCells {
            cell.accessoryType = .none
        }
        selectedCell?.accessoryType = .checkmark
        repeatIntervall = RepeatIntervall(rawValue: indexPath.row)!
        guard counter != nil else {
            return
        }
        CountersManager.sharedInstance.updateRepeatInterval(repeatInterval: repeatIntervall.rawValue, counter: &counter!)
    }
}
