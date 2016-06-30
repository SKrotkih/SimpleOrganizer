//
//  CategoriesTabBarView.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/26/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import UIKit

class CategoriesTabBarView: TabBarView {
    var output: CategoriesTabBarInteractorInput!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        CategoriesTabBarConfigurator.sharedInstance.configure(self)
        self.output.fetchCategories()
    }
    
    override func notify(notification: SOObserverNotification) {
        if notification.type == .SODataBaseTypeChanged || notification.type == .SODataBaseDidChange {
            self.output.fetchCategories()
        }
    }
    
}
