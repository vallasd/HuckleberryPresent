//
//  CommentTransitioningDelegate.swift
//  TabletAssignmentSwift
//
//  Created by David Vallas on 4/9/16.


import UIKit

class HGTransDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    let transitionSettings: HGTransitionSettings
    fileprivate weak var vc: UIViewController?
    
    init(settings: HGTransitionSettings, viewController: UIViewController) {
        vc = viewController
        transitionSettings = settings
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = HGPresentController(presented: presented, presenting: presenting, settings: transitionSettings, viewController: vc)
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = HGAnimatedTrans(settings: transitionSettings, presenting: true)
        return animationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = HGAnimatedTrans(settings: transitionSettings, presenting: false)
        return animationController
    }
}
