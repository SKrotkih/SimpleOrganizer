//
//  EditTaskDetailCell.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 7/11/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class EditTaskDetailCell: UITableViewCell {
    var input: EditTask.FetchTask.Response!
    
    func displayContent(){
        assert(false, "You need to override this method in the child class!")    
    }
    
    func stringData() -> String{
        assert(false, "You need to override this method in the child class!")
        
        return ""
    }
    
}
