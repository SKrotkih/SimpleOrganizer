//
//  SOPreferencesViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 9/3/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

enum SOPreferencesRowItem: Int {
    case CategoryPreferencesEditor = 0
    case IconsPreferencesEditor
}

class SOPreferencesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Preferences".localized
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    private func didSelectController(aChoice: SOPreferencesRowItem){
        var viewController: UIViewController!
        var storyboard = UIStoryboard(name: "Preferences", bundle: nil)
        
        switch aChoice {
        case .CategoryPreferencesEditor:
            viewController = storyboard.instantiateViewControllerWithIdentifier("PreferenceCategoriesViewController") as! SOPreferenceCategoriesViewController
        case .IconsPreferencesEditor:
            viewController = storyboard.instantiateViewControllerWithIdentifier("PreferenceIconsViewController") as! SOPreferenceIconsViewController
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SOPreferencesViewController: UITableViewDataSource, UITableViewDelegate{

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PreferrencesCell") as! UITableViewCell
        let itemIndex: SOPreferencesRowItem = SOPreferencesRowItem(rawValue: indexPath.row)!

        switch itemIndex {
        case .CategoryPreferencesEditor:
            cell.textLabel?.text = "Categories".localized
        case .IconsPreferencesEditor:
            cell.textLabel?.text = "Icons".localized
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let itemIndex: SOPreferencesRowItem = SOPreferencesRowItem(rawValue: indexPath.row)!
        self.didSelectController(itemIndex)
    }
}

