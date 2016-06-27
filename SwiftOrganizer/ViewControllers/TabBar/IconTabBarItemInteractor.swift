//
//  IconTabBarItemInteractor.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

protocol IconTabBarItemInteractorInput
{
    func selectItem()
    func presentItem()
}

protocol IconTabBarItemInteractorOutput
{
    func redrawItem(data: Dictionary<String, AnyObject>)
}

class IconTabBarItemInteractor: IconTabBarItemInteractorInput
{
    var output: IconTabBarItemInteractorOutput!
    var icon: TaskIco!
    
    func presentItem() {
        let select =  self.icon.selected
        let imageName = self.icon.imageName
        let dict: Dictionary<String, AnyObject> = ["select": select, "imagename": imageName]
        self.output.redrawItem(dict)
    }
    
    func selectItem() {
        let select: Bool = !self.icon.selected
        self.icon.setSelected(select, completionBlock: {[weak self] (error) -> Void in
            if error == nil {
                self?.icon.selected = select
                self?.presentItem()
            } else {
                showAlertWithTitle("Error of saving data".localized, message: error!.localizedDescription)
            }
            })
    }
}
