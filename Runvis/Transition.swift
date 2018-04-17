//
//  Transition.swift
//  Ear Training
//
//  Created by 王富生 on 2017/4/28.
//  Copyright © 2017年 王富生. All rights reserved.
//

import UIKit

class Transition: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        let fromView = fromVC?.view
        
        let toVC = transitionContext.viewController(forKey: .to)
        let toView = toVC?.view
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromView!)
        containerView.addSubview(toView!)
        
        toView?.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            fromView?.alpha = 0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                toView?.alpha = 1
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        })
    }
}
 
