//
//  CategoryTabBarItemInteractor.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

protocol CategoryTabBarItemInteractorInput
{
    func selectItem()
    func presentItem()
}

protocol CategoryTabBarItemInteractorOutput
{
    func redrawItem(data: Dictionary<String, AnyObject>)
}

class CategoryTabBarItemInteractor: CategoryTabBarItemInteractorInput
{
    var output: CategoryTabBarItemInteractorOutput!
    var category: TaskCategory!
    
    func presentItem() {
        let select =  self.category.selected
        let name = self.category.name
        let dict: Dictionary<String, AnyObject> = ["select": select, "name": name]
        self.output.redrawItem(dict)
    }
    
    func selectItem() {
        let select: Bool = !self.category.selected
        self.category.setSelected(select, completionBlock: {[weak self] (error) -> Void in
            if error == nil {
                self?.category.selected = select
                self?.presentItem()
            } else {
                showAlertWithTitle("Error of saving data".localized, message: error!.localizedDescription)
            }
            })
    }
}
