//
//  FilterTasksByCategories.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/28/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

class FilterTasksByCategories: FilterTasks {

    var categories: [TaskCategory]!
    
    convenience init(_ categories: [TaskCategory]) {
        self.init()
        self.categories = categories
    }
    
    func meetCriteria(tasks: [Task]) -> [Task] {
        var resultTasks: [Task] = []
        var selectedCategories: [String] = []
        for category: TaskCategory in self.categories {
            if category.selected {
                let recordid = category.recordid
                selectedCategories.append(recordid)
            }
        }
        for task in tasks {
            let category = task.category
            if selectedCategories.contains(category) {
                resultTasks.append(task)
            }
        }
        
        return resultTasks
    }
    
    
}
