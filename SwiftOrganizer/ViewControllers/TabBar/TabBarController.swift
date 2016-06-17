//
//  TabBarController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 10/30/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class TabBarController: NSObject {
    var filterStateDelegate: SOChangeFilterStateDelegate?
    var scrollView: UIScrollView?
    var containerView: TabBarContainerView?
    var tabs: [UIView] = []
    var tabsCount: Int = 0
    
    init(scrollView aScrollView: UIScrollView, containerView aContainerView: TabBarContainerView){
        self.scrollView = aScrollView
        self.containerView = aContainerView
        super.init()
    }

    func clearTabs(){
        if let containerView = self.containerView{
            let _ = containerView.subviews.map({$0.removeFromSuperview()})
        }
    }
    
    func reloadTabs(completionBlock: (error: NSError?) -> Void){
        if self.tabsCount == 0{
            print("TabBarController: No one bar is presented!")
            completionBlock(error: nil)
            return
        }
        
        guard let containerView = self.containerView, let scrollView = self.scrollView else {
            print("TabBarController: ContainerView does not exist!")
            completionBlock(error: nil)
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.clearTabs()
            var x : CGFloat = 0
            
            for i in 0..<self.tabsCount{
                let view: UIView = self.tabs[i]
                var frame = view.frame
                let w: CGFloat = CGRectGetWidth(frame)
                frame.origin.x = x
                view.frame = frame
                containerView.addSubview(view)
                x += w
            }
            let h: CGFloat = CGRectGetHeight(scrollView.frame)
            let contentSize: CGSize = CGSizeMake(x, h)
            var containerFrame: CGRect = containerView.frame
            containerFrame.size = contentSize
            containerView.frame = containerFrame
            scrollView.contentSize = contentSize
            completionBlock(error: nil)
        })
    }

}
