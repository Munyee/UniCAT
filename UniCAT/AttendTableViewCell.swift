//
//  AttendTableViewCell.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 7/3/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class AttendTableViewCell: UITableViewCell {

    @IBOutlet weak var goingButton: UIButton!
    @IBOutlet weak var maybeButton: UIButton!
    @IBOutlet weak var notInterestedButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
