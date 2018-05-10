//
//    HGPresent  (subclass of UIPresentationController)
//
//    Allows user to easily present viewcontrollers on top of presenting view controller
//
//    The MIT License (MIT)
//
//    Copyright (c) 2018 David C. Vallas (david_vallas@yahoo.com) (dcvallas@twitter)
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE

import UIKit

class HGPresentController: UIPresentationController, UIAdaptivePresentationControllerDelegate {
    
    let transitionSettings: HGTransitionSettings
    fileprivate weak var vc: UIViewController?
    fileprivate var chromeView: UIView?
    
    init(presented: UIViewController, presenting: UIViewController?, settings: HGTransitionSettings, viewController: UIViewController?) {
        transitionSettings = settings
        vc = viewController
        super.init(presentedViewController: presented, presenting: presenting)
        if let color = settings.chrome {
            chromeView = UIView()
            chromeView?.backgroundColor = color
            chromeView?.alpha = 0.0
            if transitionSettings.chromeDismiss {
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.chromeViewTapped))
                chromeView?.addGestureRecognizer(tap)
            }
        }
    }
    
    @objc func chromeViewTapped(gesture: UIGestureRecognizer) {
        if (gesture.state == UIGestureRecognizerState.ended) {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame = CGRect()
        let bounds = containerView!.bounds
        frame.size = bounds.size // if chrome is nil, we will make the container and presentedView frames the same size
        
        // if we have a chrome, we use percentages to determine the presented view size in relation to container view
        if chromeView != nil {
            let p = transitionSettings.size.displayed
            let size = CGSize(width: bounds.width * p.wPercent, height: bounds.height * p.hPercent)
            frame.size = size
        }
        
        frame.origin = transitionSettings.position.origin(size: frame.size, container: bounds.size)
        return frame
    }
    
    override func presentationTransitionWillBegin() {
        
        containerView?.frame = containerFrame
        presentedView?.alpha = transitionSettings.fade.fadeIn ? 0.0 : 1.0
        
        if let c = chromeView {
            c.frame = containerView!.bounds
            c.alpha = 0.0
            containerView?.insertSubview(c, at: 0)
        }
        
        if let c = presentedViewController.transitionCoordinator {
            let transition = {
                [weak self] (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                self?.alphaForPresent()
            }
            c.animate(alongsideTransition: transition, completion:nil)
        } else {
            alphaForPresent()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let coordinator = presentedViewController.transitionCoordinator
        if (coordinator != nil) {
            coordinator!.animate(alongsideTransition: { [weak self]
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                self?.alphaForDismiss()
                }, completion:nil)
        } else {
            alphaForDismiss()
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        chromeView?.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
    
    fileprivate func alphaForPresent() {
        chromeView?.alpha = 1.0
        presentedView?.alpha = 1.0
    }
    
    fileprivate func alphaForDismiss() {
        chromeView?.alpha = 0.0
        presentedView?.alpha = transitionSettings.fade.fadeOut ? 0.0 : 1.0
    }
    
    fileprivate var containerFrame: CGRect {
        
        // we arent using a chrome, make container frame same size and location as presented view.
        if chromeView == nil {
            let appDelegate  = UIApplication.shared.delegate
            let root = appDelegate!.window!!.rootViewController!
            let rootSafeArea = root.view.safeArea
            let insets = root.view.safeAreaInsets
            let p = transitionSettings.size.displayed
            let size = CGSize(width: rootSafeArea.width * p.wPercent, height: rootSafeArea.height * p.hPercent)
            let origin = transitionSettings.position.origin(size: size, container: rootSafeArea.size)
            let adjustedOrigin = CGPoint(x: origin.x + insets.left, y: origin.y + insets.top)
            let rect = CGRect(origin: adjustedOrigin, size: size)
            return rect
        } else {
            
            // we want to try to use the safe area defined by the (actual) presenting vc
            if !transitionSettings.entireScreen {
                if let viewController = vc {
                    let safeAreaInsets = viewController.view.safeArea
                    return safeAreaInsets
                }
            }
            
            // use entire screen's safe area (default)
            let appDelegate  = UIApplication.shared.delegate
            let root = appDelegate!.window!!.rootViewController!
            let rootSafeArea = root.view.safeArea
            return rootSafeArea
        }
    }
    
}
