//
//  TabBarViewController.swift
//  UniCAT
//
//  Created by Munyee on 19/12/2015.
//  Copyright © 2015 Sweatshop Solutions. All rights reserved.
//

import Foundation

class TabBarViewController: UITabBarController {
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item.tag == 2){
            self.tabBarController?.selectedIndex = 3
        }
    }
    
}