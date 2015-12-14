//
//  ProfileTableViewCell.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 6/23/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var photoFrame: UIView!
    @IBOutlet weak var interestCount: UILabel!
    @IBOutlet weak var contCount: UILabel!
    
    @IBOutlet weak var commentFrame: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        photoFrame.layer.cornerRadius = 10
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
