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

    func reloadTabs(){
        if let containerView = self.containerView{
            containerView.subviews.map({$0.removeFromSuperview()})
            var x : CGFloat = 0
            
            for view: UIView in tabs{
                let w: CGFloat = CGRectGetWidth(view.frame)
                view.frame.origin.x = x
                x += w
                containerView.addSubview(view)
            }
            
            if let scrollView = self.scrollView{
                let h: CGFloat = CGRectGetHeight(scrollView.frame)
                var contentSize: CGSize = CGSizeMake(x, h)
                var containerFrame: CGRect = containerView.frame
                containerFrame.size = contentSize
                containerView.frame = containerFrame
                scrollView.contentSize = contentSize
            }
        }
    }
}
