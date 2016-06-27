//
//  IconsTabBarView.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/26/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import UIKit

class IconsTabBarView: TabBarView {
    var output: IconsTabBarInteractorInput!
    
    override func awakeFromNib(){
        IconsTabBarConfigurator.sharedInstance.configure(self)
        self.output.fetchIcons()
    }
}
