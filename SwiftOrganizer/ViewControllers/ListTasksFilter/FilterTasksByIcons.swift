//
//  FilterTasksByIcons.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/28/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

class FilterTasksByIcons: FilterTasks {

    var icons: [TaskIco]!
    
    convenience init(_ icons: [TaskIco]) {
        self.init()
        self.icons = icons
    }
    
    func meetCriteria(tasks: [Task]) -> [Task] {
        var resultTasks: [Task] = []
        var selectedIcons: [String] = []
        
        for ico: TaskIco in self.icons {
            if ico.selected {
                let recordid = ico.recordid
                selectedIcons.append(recordid)
            }
        }
        for task in tasks {
            let icons = task.icons
            for recordid in icons {
                if selectedIcons.contains(recordid) {
                    resultTasks.append(task)
                    break
                }
            }
        }
        
        return resultTasks
    }
    
    
}
