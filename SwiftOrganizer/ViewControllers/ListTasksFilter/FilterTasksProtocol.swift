//
//  FilterTasksProtocol.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/28/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import Foundation

protocol FilterTasks {
    func meetCriteria(tasks: [Task]) -> [Task]
}
