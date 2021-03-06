//
//  EditTaskCategoryPresenter.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/20/16.
//  Copyright (c) 2016 Sergey Krotkih. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol EditTaskCategoryPresenterInput
{
    func generateViewModel()
}

protocol EditTaskCategoryPresenterOutput: class
{
    func redrawView(viewModel: EditTaskCategoryViewModel)
}

class EditTaskCategoryPresenter: EditTaskCategoryPresenterInput
{
    weak var output: EditTaskCategoryPresenterOutput!
    var responce: EditTaskCategoryResponse!
    var taskCategoryId: String!
    
    func presentResponce(response: EditTaskCategoryResponse) {
        self.responce = response
    }
    
    func presentTaskCategory(taskCategoryId: String) {
        self.taskCategoryId = taskCategoryId
    }
    
    func generateViewModel(){
        var dataSource: [Dictionary<String, AnyObject>] = []
        let categories = self.responce.categories
        for category: TaskCategory in categories {
            let categoryName: String = category.name;
            let categoryId: String = category.recordid;
            let selected: String = self.taskCategoryId == categoryId ? "yes": "no"
            dataSource.append(["name": categoryName, "selected": selected])
        }
        let viewModel = EditTaskCategoryViewModel(viewDataSource: dataSource)
        output.redrawView(viewModel)
    }
    
}
