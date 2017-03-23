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
    @IBOutlet var decreaseButton: UIButton!
    @IBOutlet var increaseButton: UIButton!

    var cellIdentifier = "countertCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func decreaseButtonPressed(_ sender: UIButton) {
        debugPrint("did press ddecrease button")
    }


    @IBAction func incraseButtonPressed(_ sender: UIButton) {
        debugPrint("did press increase button")
    }

}
