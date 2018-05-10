//
//  CommentAnimatedTransitioning.swift
//  TabletAssignmentSwift
//
//  Created by David Vallas on 4/9/16.


import UIKit

class HGAnimatedTrans: NSObject, UIViewControllerAnimatedTransitioning {
    
    let transitionSettings: HGTransitionSettings
    let isPresenting: Bool
    
    init(settings: HGTransitionSettings, presenting: Bool) {
        transitionSettings = settings
        isPresenting = presenting
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentedVC = presentedVC(context: transitionContext) else {
            print("Error: no presentedVC in transitionContext, not transitioning object")
            return
        }
        
        add(presentedVC: presentedVC, toContext: transitionContext)
        
        let i = initialFrame(presentedVC: presentedVC, context: transitionContext)
        let f = finalFrame(presentedVC: presentedVC, context: transitionContext)
        
        presentedVC.view.frame = i
        
        let animations = {
            presentedVC.view.frame = f
        }
        
        let completion = {
            [weak self] (value: Bool) in
            self?.remove(presentedVC: presentedVC)
            transitionContext.completeTransition(true)
        }
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay:0,
                       usingSpringWithDamping:300.0,
                       initialSpringVelocity:5.0,
                       options: .allowUserInteraction,
                       animations: animations,
                       completion: completion
        )
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionSettings.speed
    }
    
    fileprivate func initialFrame(presentedVC: UIViewController, context: UIViewControllerContextTransitioning) -> CGRect {
        
        // we are removing the view, initial frame will be the context's final frame
        if !isPresenting {
            let frame = context.finalFrame(for: presentedVC)
            return frame
        }
        
        // determine initial frame based off of direction in
        let container = context.containerView.bounds
        let p = transitionSettings.size.start
        let size = CGSize(width: container.width * p.wPercent, height: container.height * p.hPercent)
        let origin = transitionSettings.directionIn.origin(location: transitionSettings.position,
                                                           size: size,
                                                           container: container.size)
        return CGRect(origin: origin, size: size)
    }
    
    fileprivate func finalFrame(presentedVC: UIViewController, context: UIViewControllerContextTransitioning) -> CGRect {
        
        // we are presenting, final frame will be the context's final frame
        if isPresenting {
            let frame = context.finalFrame(for: presentedVC)
            return frame
        }
        
        // determine frame based off of direction out
        let container = context.containerView.bounds
        let p = transitionSettings.size.end
        let size = CGSize(width: container.width * p.wPercent, height: container.height * p.hPercent)
        let origin = transitionSettings.directionOut.origin(location: transitionSettings.position,
                                                            size: size,
                                                            container: container.size)
        return CGRect(origin: origin, size: size)
    }
    
    fileprivate func presentedVC(context: UIViewControllerContextTransitioning) -> UIViewController? {
        if isPresenting {
            return context.viewController(forKey: .to)
        }
        
        return context.viewController(forKey: .from)
    }
    
    fileprivate func add(presentedVC: UIViewController, toContext: UIViewControllerContextTransitioning) {
        if self.isPresenting {
            if let view = presentedVC.view {
                toContext.containerView.addSubview(view)
            }
        }
    }
    
    fileprivate func remove(presentedVC: UIViewController) {
        if !isPresenting {
            presentedVC.view.removeFromSuperview()
        }
    }
}

