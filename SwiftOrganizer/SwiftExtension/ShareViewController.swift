//
//  ShareViewController.swift
//  SwiftExtension
//
//  Created by Sergey Krotkih on 7/17/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

    var imageData: NSData?
    
    func showAudienceSelection(){
        let controller = AudienceSelectionViewController(style: .Plain)
        controller.audience = audienceConfigurationItem.value
        controller.delegate = self
        pushConfigurationViewController(controller)
    }
    
    override func isContentValid() -> Bool {
        if let data = imageData{
            if count(contentText) > 0{
                return true
            }
        }
        
        return false
    }

    override func presentationAnimationDidFinish(){
        super.presentationAnimationDidFinish()
        placeholder = "Your comments".localized
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        let contentType = kUTTypeImage as NSString
        
        for attachment in content.attachments as! [NSItemProvider]{
            
            if attachment.hasItemConformingToTypeIdentifier(contentType as String){
                let dispatchQueue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                
                dispatch_async(dispatchQueue, {[weak self] in
                    let strongSelf = self!
                    attachment.loadItemForTypeIdentifier(contentType as String, options: nil, completionHandler: {(content: NSSecureCoding!, error: NSError!) in
                        
                        if let data = content as? NSData{ dispatch_async(dispatch_get_main_queue(), {
                            strongSelf.imageData = data
                            strongSelf.validateContent()
                        })
                        }
                    })
                    }) }
            
            break
        }
    }

    override func didSelectPost() {
        
        // Enter here what need to do after user taps the Post button
        
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }
    
    lazy var audienceConfigurationItem: SLComposeSheetConfigurationItem = {
        let item = SLComposeSheetConfigurationItem()
        item.title = "Audience".localized
        item.value = AudienceSelectionViewController.defaultAudience()
        item.tapHandler = self.showAudienceSelection
        return item
        }()
    
    override func configurationItems() -> [AnyObject]! {
        return [audienceConfigurationItem]
    }
    

}

    // MARK: - AudienceSelectionViewControllerDelegate protocol implementation

extension ShareViewController: AudienceSelectionViewControllerDelegate{
    func audienceSelectionViewController(sender: AudienceSelectionViewController,
        selectedValue: String) {
            audienceConfigurationItem.value = selectedValue
            popConfigurationViewController()
    }
}
