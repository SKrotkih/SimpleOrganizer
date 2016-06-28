//
//  FilterTasksORcriteria.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/28/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

class FilterTasksORcriteria: FilterTasks {
    
    var firstCriteria: FilterTasks!
    var secondCriteria: FilterTasks!
    
    convenience init(firstCriteria: FilterTasks, secondCriteria: FilterTasks) {
        self.init()
        self.firstCriteria = firstCriteria
        self.secondCriteria = secondCriteria
    }
    
    func meetCriteria(tasks: [Task]) -> [Task] {
        var firstCriteriaTasks = self.firstCriteria.meetCriteria(tasks)
        let secondCriteriaTasks = self.secondCriteria.meetCriteria(tasks)
        for task in secondCriteriaTasks {
            if firstCriteriaTasks.contains(task) == false {
               firstCriteriaTasks.append(task)
            }
        }
        return firstCriteriaTasks
    }
}
