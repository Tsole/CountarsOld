//
//  AddNewCounterCell.swift
//  InsanelySImpleTracker
//
//  Created by Tsole on 14/1/17.
//  Copyright © 2017 Tsole. All rights reserved.
//

import UIKit

protocol AddNewCounterCellDelegate {
    func didAddNewCounter(sender: AddNewCounterCell)
}

class AddNewCounterCell: UITableViewCell {

    var cellIdentifier = "addCounterCell"
    @IBOutlet var textField: UITextField!
    @IBOutlet var addButton: UIButton!
    var delegate: AddNewCounterCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didPressAddButton(_ sender: Any) {
        delegate?.didAddNewCounter(sender: self)
    }

}
