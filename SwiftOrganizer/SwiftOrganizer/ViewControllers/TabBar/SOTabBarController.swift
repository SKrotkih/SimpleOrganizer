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
        if self.tabsCount > 0{
            if let containerView = self.containerView{
                containerView.subviews.map({$0.removeFromSuperview()})
            }
        }
    }
    
    func reloadTabs(block: (error: NSError?) -> Void){
        if let containerView = self.containerView, scrollView = self.scrollView{
            if self.tabsCount > 0{
                dispatch_async(dispatch_get_main_queue(), {[weak self] in
                    let subViews = containerView.subviews
                    var x : CGFloat = 0
                    
                    for i in 0..<self!.tabsCount{
                        let view: UIView = self!.tabs[i]
                        var frame = view.frame
                        let w: CGFloat = CGRectGetWidth(frame)
                        if subViews.filter({ el in el as! UIView == view }).count == 0 {
                            frame.origin.x = x
                            view.frame = frame
                            containerView.addSubview(view)
                        }

                        x += w
                    }
                    let h: CGFloat = CGRectGetHeight(scrollView.frame)
                    var contentSize: CGSize = CGSizeMake(x, h)
                    var containerFrame: CGRect = containerView.frame
                    containerFrame.size = contentSize
                    containerView.frame = containerFrame
                    scrollView.contentSize = contentSize

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
