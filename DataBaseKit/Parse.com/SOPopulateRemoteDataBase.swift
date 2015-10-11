//
//  SOPopulateRemoteDataBase.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 9/8/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import Parse

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
            SOCategory(object: nil, id:"1", selected: true, visible: true, name:"ToDo".localized),
            SOCategory(object: nil, id:"2", selected: true, visible: true, name:"Events".localized),
            SOCategory(object: nil, id:"3", selected: true, visible: true, name:"Life".localized),
            SOCategory(object: nil, id:"4", selected: true, visible: true, name:"Work".localized)]
        
        if self.currentCategoryIndex < defaultCategories.count{
            let category: SOCategory = defaultCategories[self.currentCategoryIndex++]
            let object = PFObject(className: CategoryClassName)
            object[kFldRecordId] = category.recordid
            object[kCategoryFldName] = category.name
            object[kFldSelected] = category.selected
            object[kFldVisible] = category.visible
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
            SOIco(object: nil, id:"1", selected: true, visible: true, name:"ico1".localized, imageName: "ico1"),
            SOIco(object: nil, id:"2", selected: true, visible: true, name:"ico2".localized, imageName: "ico2"),
            SOIco(object: nil, id:"3", selected: true, visible: true, name:"ico3".localized, imageName: "ico3"),
            SOIco(object: nil, id:"4", selected: true, visible: true, name:"ico4".localized, imageName: "ico4"),
            SOIco(object: nil, id:"5", selected: true, visible: true, name:"ico5".localized, imageName: "ico5"),
            SOIco(object: nil, id:"6", selected: true, visible: true, name:"ico6".localized, imageName: "ico6"),
            SOIco(object: nil, id:"7", selected: true, visible: true, name:"ico7".localized, imageName: "ico7"),
            SOIco(object: nil, id:"8", selected: true, visible: true, name:"ico8".localized, imageName: "ico8"),
            SOIco(object: nil, id:"9", selected: true, visible: true, name:"ico9".localized, imageName: "ico9"),
            SOIco(object: nil, id:"10", selected: true, visible: true, name:"ico10".localized, imageName: "ico10"),
            SOIco(object: nil, id:"11", selected: true, visible: true, name:"ico11".localized, imageName: "ico11"),
            SOIco(object: nil, id:"12", selected: true, visible: true, name:"ico12".localized, imageName: "ico12"),
            SOIco(object: nil, id:"13", selected: true, visible: true, name:"ico13".localized, imageName: "ico13"),
            SOIco(object: nil, id:"14", selected: true, visible: true, name:"ico14".localized, imageName: "ico14"),
            SOIco(object: nil, id:"15", selected: true, visible: true, name:"ico15".localized, imageName: "ico15"),
            SOIco(object: nil, id:"16", selected: true, visible: true, name:"ico16".localized, imageName: "ico16"),
            SOIco(object: nil, id:"17", selected: true, visible: true, name:"ico17".localized, imageName: "ico17")]
        
        if self.currentIcoIndex < defaultIcons.count{
            let ico: SOIco = defaultIcons[self.currentIcoIndex++]
            let object = PFObject(className: IcoClassName)
            object[kFldRecordId] = ico.recordid
            object[kFldSelected] = ico.selected
            object[kFldVisible] = ico.visible
            object[kIcoFldName] = ico.name
            object[kIcoFldImageName] = ico.imageName
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
