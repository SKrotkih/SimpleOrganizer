//
//  SOTabBarController.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 5/31/15.
//  Copyright (c) 2015 Sergey Krotkih. All rights reserved.
//

import UIKit

class SOTabBarController: NSObject {
    var filterStateDelegate: SOChangeFilterStateDelegate?
    var scrollView: UIScrollView?
    var containerView: SOTabBarContainerView?
    var tabs: [UIView] = []
    var tabsCount: Int = 0
    
    init(scrollView aScrollView: UIScrollView, containerView aContainerView: SOTabBarContainerView){
        self.scrollView = aScrollView
        self.containerView = aContainerView
        super.init()
    }

    func clearTabs(){
        if let containerView = self.containerView{
            containerView.subviews.map({$0.removeFromSuperview()})
        }
    }
    
    func reloadTabs(block: (error: NSError?) -> Void){
        if self.containerView != nil && self.scrollView != nil{
            if self.tabsCount > 0{
                dispatch_async(dispatch_get_main_queue(), {
                    self.clearTabs()
                    var x : CGFloat = 0
                    
                    for i in 0..<self.tabsCount{
                        let view: UIView = self.tabs[i]
                        var frame = view.frame
                        let w: CGFloat = CGRectGetWidth(frame)
                        frame.origin.x = x
                        view.frame = frame
                        self.containerView!.addSubview(view)
                        x += w
                    }
                    let h: CGFloat = CGRectGetHeight(self.scrollView!.frame)
                    var contentSize: CGSize = CGSizeMake(x, h)
                    var containerFrame: CGRect = self.containerView!.frame
                    containerFrame.size = contentSize
                    self.containerView!.frame = containerFrame
                    self.scrollView!.contentSize = contentSize
                    block(error: nil)
                })
            } else {
                println("TabBarController: No one bar is presented!")
                block(error: nil)
            }
        } else {
            println("TabBarController: ContainerView does not exist!")
            block(error: nil)
        }
    }
}
