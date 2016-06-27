//
//  IconsTabBarInteractor.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

protocol IconsTabBarInteractorInput
{
    func fetchIcons()
}

protocol IconsTabBarInteractorOutput
{
    func displayTabBarModel(model: [TaskIco])
}

class IconsTabBarInteractor: IconsTabBarInteractorInput
{
    var output: IconsTabBarInteractorOutput!
    
    func fetchIcons(){
        SOFetchingData.sharedInstance.allIcons{(icons: [TaskIco], fetchError: NSError?) in
            if let error = fetchError{
                showAlertWithTitle("Error while fetching icons data".localized, message: error.description)
                return
            }
            
            if icons.count == 0{
                showAlertWithTitle("Warning:".localized, message: "Icons data are not presented on Parse.com.".localized)
                return
            }
            self.output.displayTabBarModel(icons)
        }
    }
    
    
}
