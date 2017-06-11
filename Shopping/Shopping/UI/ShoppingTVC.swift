//
//  ShoppingTVC.swift
//  Shopping
//
//  Created by Tobias Baube on 11.06.17.
//  Copyright © 2017 Tobias Baube. All rights reserved.
//

import UIKit

class ShoppingTVC: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var amountStepper: UIStepper!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBAction func amountChanged(_ sender: UIStepper) {
        self.amountLabel.text = String(Int(sender.value))
    }
}
