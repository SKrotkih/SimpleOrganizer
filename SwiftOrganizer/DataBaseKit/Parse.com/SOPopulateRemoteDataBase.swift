//
//  SOPopulateRemoteDataBase.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 9/8/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

public class SOPopulateRemoteDataBase {
    
    private var currentCategoryIndex = 0
    private var currentIcoIndex = 0
    private var currentTaskIndex = 0

    public func populateDefaultData(className: String, completionBlock: (error: NSError?) -> Void){
        switch className{
        case IcoClassName:
            self.populateIcons{(populateError: NSError?) -> Void in
                completionBlock(error: populateError)
            }
        case CategoryClassName:
            self.populateCategories{(populateError: NSError?) -> Void in
                completionBlock(error: populateError)
            }
        case TaskClassName:
            self.populateTasks{(populateError: NSError?) -> Void in
                completionBlock(error: populateError)
            }
        default:
            return
        }
    }
    
    // - MARK: Categories
    private func populateCategories(completionBlock: (error: NSError?) -> Void){
        self.currentCategoryIndex = 0
        self.populateNextCategory{(error: NSError?) -> Void in
            completionBlock(error: error)
        }
    }
    
    private func populateNextCategory(completionBlock: (error: NSError?) -> Void){
        if !(self.populateNextCategoryInBackground{(error: NSError?) -> Void in
            if error == nil{
                self.populateNextCategory(completionBlock)
            } else {
                completionBlock(error: error)
            }
            }){
                completionBlock(error: nil)
        }
    }
    
    private func populateNextCategoryInBackground(completionBlock: (error: NSError?) -> Void) -> Bool{
        let defaultCategories = [
            SOCategory(id:"1", name:"ToDo".localized, selected: true),
            SOCategory(id:"2", name:"Events".localized, selected: true),
            SOCategory(id:"3", name:"Life".localized, selected: true),
            SOCategory(id:"4", name:"Work".localized, selected: true)]
        
        if self.currentCategoryIndex < defaultCategories.count{
            let category: SOCategory = defaultCategories[self.currentCategoryIndex++]
            let object = PFObject(className: CategoryClassName)
            object[kFldRecordId] = category.recordid
            object[kCategoryFldName] = category.name
            object[kFldSelected] = category.selected
            object[kFldVisible] = true
            object.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
                if (success) {
                    completionBlock(error: nil)
                } else {
                    completionBlock(error: error)
                }
            }
        } else {
            return false
        }
        
        return true
    }
    
    // - MARK: Icons
    private func populateIcons(completionBlock: (error: NSError?) -> Void){
        self.currentIcoIndex = 0
        self.populateNextIco{(error: NSError?) -> Void in
            completionBlock(error: error)
        }
    }
    
    private func populateNextIco(completionBlock: (error: NSError?) -> Void){
        if !(self.populateNextIcoInBackground{(error: NSError?) -> Void in
            if error == nil{
                self.populateNextIco(completionBlock)
            } else {
                completionBlock(error: error)
            }
            }){
                completionBlock(error: nil)
        }
    }
    
    private func populateNextIcoInBackground(completionBlock: (error: NSError?) -> Void) -> Bool{
        let defaultIcons = [
            SOIco(id:"1", name:"ico1".localized, imageName: "ico1", selected: true),
            SOIco(id:"2", name:"ico2".localized, imageName: "ico2", selected: true),
            SOIco(id:"3", name:"ico3".localized, imageName: "ico3", selected: true),
            SOIco(id:"4", name:"ico4".localized, imageName: "ico4", selected: true),
            SOIco(id:"5", name:"ico5".localized, imageName: "ico5", selected: true),
            SOIco(id:"6", name:"ico6".localized, imageName: "ico6", selected: true),
            SOIco(id:"7", name:"ico7".localized, imageName: "ico7", selected: true),
            SOIco(id:"8", name:"ico8".localized, imageName: "ico8", selected: true),
            SOIco(id:"9", name:"ico9".localized, imageName: "ico9", selected: true),
            SOIco(id:"10", name:"ico10".localized, imageName: "ico10", selected: true),
            SOIco(id:"11", name:"ico11".localized, imageName: "ico11", selected: true),
            SOIco(id:"12", name:"ico12".localized, imageName: "ico12", selected: true),
            SOIco(id:"13", name:"ico13".localized, imageName: "ico13", selected: true),
            SOIco(id:"14", name:"ico14".localized, imageName: "ico14", selected: true),
            SOIco(id:"15", name:"ico15".localized, imageName: "ico15", selected: true),
            SOIco(id:"16", name:"ico16".localized, imageName: "ico16", selected: true),
            SOIco(id:"17", name:"ico17".localized, imageName: "ico17", selected: true)]
        
        if self.currentIcoIndex < defaultIcons.count{
            let ico: SOIco = defaultIcons[self.currentIcoIndex++]
            let object = PFObject(className: IcoClassName)
            object[kFldRecordId] = ico.recordid
            object[kIcoFldName] = ico.name
            object[kIcoFldImageName] = ico.imageName
            object[kFldSelected] = ico.selected
            object[kFldVisible] = true
            object.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
                if (success) {
                    completionBlock(error: nil)
                } else {
                    completionBlock(error: error)
                }
            }
        } else {
            return false
        }
        
        return true
    }
    
    // - MARK: Tasks
    private func populateTasks(completionBlock: (error: NSError?) -> Void){
        self.currentTaskIndex = 0
        self.populateNextTask{(error: NSError?) -> Void in
            completionBlock(error: error)
        }
    }
    
    private func populateNextTask(completionBlock: (error: NSError?) -> Void){
        if !(self.populateNextTaskInBackground{(error: NSError?) -> Void in
            if error == nil{
                self.populateNextTask(completionBlock)
            } else {
                completionBlock(error: error)
            }
            }){
                completionBlock(error: nil)
        }
    }
    
    private func populateNextTaskInBackground(completionBlock: (error: NSError?) -> Void) -> Bool{
        let defaultTasks : [Dictionary<String, String>] = [
            [kTaskFldCategory: "1",
                kTaskFldIco1: "1",
                kTaskFldIco2: "3",
                kTaskFldIco3: "6",
                kTaskFldIco4: "2",
                kTaskFldIco5: "",
                kTaskFldIco6: "",
                kTaskFldTitle: "ToDo task"],
            [kTaskFldCategory: "2",
                kTaskFldIco1: "12",
                kTaskFldIco2: "11",
                kTaskFldIco3: "2",
                kTaskFldIco4: "1",
                kTaskFldIco5: "",
                kTaskFldIco6: "",
                kTaskFldTitle: "Events task"],
            [kTaskFldCategory: "3",
                kTaskFldIco1: "1",
                kTaskFldIco2: "3",
                kTaskFldIco3: "6",
                kTaskFldIco4: "2",
                kTaskFldIco5: "",
                kTaskFldIco6: "",
                kTaskFldTitle: "Life task"]]
        
        if self.currentTaskIndex < defaultTasks.count{
            let object = PFObject(className: TaskClassName)
            let dict: Dictionary<String, String> = defaultTasks[self.currentTaskIndex++]
            object[kTaskFldCategory] = dict[kTaskFldCategory]
            object[kTaskFldIco1] = dict[kTaskFldIco1]
            object[kTaskFldIco2] = dict[kTaskFldIco2]
            object[kTaskFldIco3] = dict[kTaskFldIco3]
            object[kTaskFldIco4] = dict[kTaskFldIco4]
            object[kTaskFldIco5] = dict[kTaskFldIco5]
            object[kTaskFldIco6] = dict[kTaskFldIco6]
            object[kTaskFldTitle] = dict[kTaskFldTitle]
            object[kTaskFldDate] = NSDate()
            object.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
                if (success) {
                    completionBlock(error: nil)
                } else {
                    completionBlock(error: error)
                }
            }
        } else {
            return false
        }
        
        return true
    }
    
}
