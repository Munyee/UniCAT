//
//  SubTableViewCell.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 6/23/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class SubTableViewCell: UITableViewCell {

    @IBOutlet weak var subLabel: UILabel!
    
    @IBOutlet weak var countFrame: UIView!
    @IBOutlet weak var countNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        countFrame.layer.cornerRadius = 17
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
