//
//  TabBarView.swift
//  SwiftOrganizer
//
//  Created by Sergey Krotkih on 6/26/16.
//  Copyright © 2016 Sergey Krotkih. All rights reserved.
//

import UIKit

class TabBarView: UIView, SOObserverProtocol {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var widthContainerConstraint: NSLayoutConstraint?

    var tabs: [UIView] = []
    
    override func awakeFromNib(){
        registerEventsOnObservers()
    }

    deinit {
        removeEventsFromObservers()
    }
    
    private func registerEventsOnObservers() {
        SOObserversManager.sharedInstance.addObserver(self, type: .SODataBaseTypeChanged)
        SOObserversManager.sharedInstance.addObserver(self, type: .SODataBaseDidChange)
    }
    
    private func removeEventsFromObservers() {
        SOObserversManager.sharedInstance.removeObserver(self, type: .SODataBaseTypeChanged)
        SOObserversManager.sharedInstance.removeObserver(self, type: .SODataBaseDidChange)
    }

    func notify(notification: SOObserverNotification) {
    }
}

extension TabBarView: TabBarPresenterOutput {

    func displayTabs(tabs: [UIView]){
        self.tabs = tabs
        
        if self.tabs.count == 0{
            print("TabBarView: No one bar is presented!")
            return
        }
        
        guard let containerView = self.containerView, let scrollView = self.scrollView else {
            assert(false, "TabBarView: Containerview and Scrollview have to be defined!")
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.clearTabs()
            var x : CGFloat = 0
            
            for view in self.tabs{
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
            self.widthContainerConstraint?.constant = contentSize.width
        })
    }
    
    private func clearTabs(){
        if let containerView = self.containerView{
            let _ = containerView.subviews.map({$0.removeFromSuperview()})
        }
    }
    
}
