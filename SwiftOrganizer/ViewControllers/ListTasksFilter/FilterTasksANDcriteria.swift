//
//  FilterTasksANDcriteria.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/28/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

class FilterTasksANDcriteria: FilterTasks {

    var firstCriteria: FilterTasks!
    var secondCriteria: FilterTasks!

    convenience init(_ firstCriteria: FilterTasks, _ secondCriteria: FilterTasks) {
        self.init()
        self.firstCriteria = firstCriteria
        self.secondCriteria = secondCriteria
    }
    
    func meetCriteria(tasks: [Task]) -> [Task] {
        let firstCriteriaTasks = self.firstCriteria.meetCriteria(tasks)
        let resultTasks = self.secondCriteria.meetCriteria(firstCriteriaTasks);
        return resultTasks
    }
}
