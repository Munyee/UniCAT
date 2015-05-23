//
//  DetailViewCell.swift
//  SidebarMenu
//
//  Created by Lye Guang Xing on 4/12/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class DetailViewCell: UITableViewCell {

    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventSubtitle: UILabel!
    @IBOutlet weak var countDown: UILabel!
    
    @IBOutlet weak var textContent: UILabel!
    @IBOutlet weak var photoContent: UIImageView!
    
    @IBOutlet weak var dateDetail: UILabel!
    @IBOutlet weak var timeDetail: UILabel!
    @IBOutlet weak var venueDetail: UILabel!
    @IBOutlet weak var mapDetail: UIImageView!
    
}