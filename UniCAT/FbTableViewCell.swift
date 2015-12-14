//
//  FbTableViewCell.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 7/2/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class FbTableViewCell: UITableViewCell {

    @IBOutlet weak var facebook: UILabel!
    
    var link = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func tapped(sender: AnyObject) {
        if let url = NSURL(string: "\(link)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
