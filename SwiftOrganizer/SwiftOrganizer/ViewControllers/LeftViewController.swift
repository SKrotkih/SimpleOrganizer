//
//  LeftViewController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 7/29/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case Main = 0
    case Preferences
    case Documents
    case DocumentPicker
    case FaceTimeCall
    case Settings
    case About
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class LeftViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var menus = ["Organizer".localized, "Preferences".localized, "My Documents".localized, "External Documents".localized, "Make Call".localized, "Settings".localized, "About".localized]
    var mainViewController: UIViewController!
    var preferencesViewController: UIViewController!
    var settingsViewController: UIViewController!
    var documentsViewController: UIViewController!
    var documentPickerViewController: UIViewController!
    var goViewController: UIViewController!
    var aboutViewController: UIViewController!
    var phoneCallViaFaceTimeViewController: UIViewController!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)

        let documentsViewController = storyboard.instantiateViewControllerWithIdentifier("DocumentsViewController") as! SODocumentsViewController
        self.documentsViewController = UINavigationController(rootViewController: documentsViewController)
        
        let preferencesViewController = storyboard.instantiateViewControllerWithIdentifier("PreferencesViewController") as! SOPreferencesViewController
        self.preferencesViewController = UINavigationController(rootViewController: preferencesViewController)
        
        let documentPickerViewController = storyboard.instantiateViewControllerWithIdentifier("DocumentPickerViewController") as! SODocumentPickerViewController
        self.documentPickerViewController = UINavigationController(rootViewController: documentPickerViewController)

        let thePhoneCallViaFaceTimeViewController = storyboard.instantiateViewControllerWithIdentifier("FaceTimeCallPhoneViewController") as! SOMakeCallViewController
        self.phoneCallViaFaceTimeViewController = UINavigationController(rootViewController: thePhoneCallViaFaceTimeViewController)
        
        let settingsViewController = storyboard.instantiateViewControllerWithIdentifier("SOSettingsViewController") as! SOSettingsViewController
        self.settingsViewController = UINavigationController(rootViewController: settingsViewController)
        
        let aboutViewController = storyboard.instantiateViewControllerWithIdentifier("SOAboutViewController") as! SOAboutViewController
        self.aboutViewController = UINavigationController(rootViewController: aboutViewController)
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}

    // MARK: - UITableViewDelegate, UITableViewDataSource

extension LeftViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: BaseTableViewCell = BaseTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: BaseTableViewCell.identifier)
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.textLabel?.font = UIFont.italicSystemFontOfSize(18)
        cell.textLabel?.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        cell.textLabel?.text = menus[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
}

    // MARK: - Change View Controller

extension LeftViewController: LeftMenuProtocol {
    func changeViewController(menu: LeftMenu) {
        switch menu {
        case .Main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .Preferences:
            self.slideMenuController()?.changeMainViewController(self.preferencesViewController, close: true)
        case .Documents:
            self.slideMenuController()?.changeMainViewController(self.documentsViewController, close: true)
            break
        case .DocumentPicker:
            self.slideMenuController()?.changeMainViewController(self.documentPickerViewController, close: true)
            break
        case .FaceTimeCall:
            self.slideMenuController()?.changeMainViewController(self.phoneCallViaFaceTimeViewController, close: true)
            break
        case .Settings:
            self.slideMenuController()?.changeMainViewController(self.settingsViewController, close: true)
            break
        case .About:
            self.slideMenuController()?.changeMainViewController(self.aboutViewController, close: true)
            break
        default:
            break
        }
    }
}

