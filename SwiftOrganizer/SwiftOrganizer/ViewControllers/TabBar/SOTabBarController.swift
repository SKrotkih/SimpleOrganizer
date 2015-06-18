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

    func reloadTabs(successBlock: (error: NSError?) -> Void){
        if let containerView = self.containerView, scrollView = self.scrollView{
            if self.tabsCount > 0{
                dispatch_async(dispatch_get_main_queue(), {
                    let subViews = containerView.subviews
                    //containerView.subviews.map({$0.removeFromSuperview()})
                    var x : CGFloat = 0
                    
                    for i in 0..<self.tabsCount{
                        let view: UIView = self.tabs[i]
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
                    
                    println("SIZE=\(NSStringFromCGSize(contentSize))")
                    
                    var containerFrame: CGRect = containerView.frame
                    containerFrame.size = contentSize
                    containerView.frame = containerFrame
                    scrollView.contentSize = contentSize

                    successBlock(error: nil)
                })
            } else {
                println("TabBarController: No one bar is presented!")
                successBlock(error: nil)
            }
        } else {
            println("TabBarController: ContainerView does not exist!")
            successBlock(error: nil)
        }
    }
}
