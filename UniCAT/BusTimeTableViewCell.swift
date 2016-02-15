//
//  BusTimeTableViewCell.swift
//  UniCAT
//
//  Created by Munyee on 14/02/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class BusTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leaving: UILabel!
    @IBOutlet weak var departure: UILabel!
    @IBOutlet weak var arriving: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let width = UIScreen.mainScreen().bounds.width/3
        self.rightConstraint.constant = width
        self.leftConstraint.constant = width
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
