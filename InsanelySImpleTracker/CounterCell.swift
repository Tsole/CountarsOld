//
//  CounterCell.swift
//  InsanelySImpleTracker
//
//  Created by Tsole on 14/1/17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import UIKit

class CounterCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var decreaseButton: RoundedRectUIButton!
    @IBOutlet var increaseButton: RoundedRectUIButton!
    
    var counter: Counter?

    var cellIdentifier = "countertCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func decreaseButtonPressed(_ sender: UIButton) {
        guard let counter = counter else {
            return
        }
        CountersManager.sharedInstance.decreaseCoutnerValue(counter: &self.counter!)
        countLabel.text = String(describing: counter.count)
    }


    @IBAction func incraseButtonPressed(_ sender: UIButton) {
        guard let counter = counter else {
            return
        }
        CountersManager.sharedInstance.increaseCoutnerValue(counter: &self.counter!)
        countLabel.text = String(describing: counter.count)
    }

}
