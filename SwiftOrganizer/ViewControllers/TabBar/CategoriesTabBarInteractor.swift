//
//  TabBarInteractor.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/16/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

protocol CategoriesTabBarInteractorInput
{
    func fetchCategories()
}

protocol CategoriesTabBarInteractorOutput
{
    func displayTabBarModel(model: [TaskCategory])
}

class CategoriesTabBarInteractor: CategoriesTabBarInteractorInput
{
    var output: CategoriesTabBarInteractorOutput!
    
    func fetchCategories(){
        SOFetchingData.sharedInstance.allCategories{(categories: [TaskCategory], fetchError: NSError?) in

            if let error = fetchError{
                showAlertWithTitle("Error while fetching icons data".localized, message: error.description)
                return
            }
            
            if categories.count == 0{
                showAlertWithTitle("Warning:".localized, message: "Categories data are not presented on Parse.com.".localized)
                return
            }
            self.output.displayTabBarModel(categories)
        }
    }
    
    
}
