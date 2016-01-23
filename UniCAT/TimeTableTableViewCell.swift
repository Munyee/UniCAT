//
//  TimeTableTableViewCell.swift
//  UniCAT
//
//  Created by Munyee on 23/01/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class TimeTableTableViewCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var subject: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
