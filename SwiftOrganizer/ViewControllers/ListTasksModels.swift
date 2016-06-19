//
//  ListTasksModels.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/17/16.
//  Copyright (c) 2016 Sergey Krotkih. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

struct ListTasks
{
    struct FetchTasks
    {
        struct Request
        {
        }
        struct Response
        {
            var tasks: [Task]
        }
        struct ViewModel
        {
            struct DisplayedTask
            {
                var objectID: AnyObject?
                var title: String
                var date: String
                var categoryName: String
                var icons: [UIImage]
            }
            var displayedTasks: [DisplayedTask]
        }
    }
}