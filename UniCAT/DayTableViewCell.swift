//
//  DayTableViewCell.swift
//  UniCAT
//
//  Created by Munyee on 23/01/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    @IBOutlet weak var day: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
