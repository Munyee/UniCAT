//
//  TextTableViewCell.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 6/28/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
