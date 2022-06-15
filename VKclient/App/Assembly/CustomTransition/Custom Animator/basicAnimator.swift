//
//  basicAnimator.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 9/25/21.
//

import UIKit

final class basicAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from)
        else {return}
        guard let destination = transitionContext.viewController(forKey: .to)
        else {return}
        
        let containerViewFrame = transitionContext.containerView.frame
        let sourceViewTargetFrame = CGRect(x: -containerViewFrame.width,
                                           y: 0,
                                           width: source.view.frame.width,
                                           height: source.view.frame.height)
        let destinationViewTargetFrame = source.view.frame
        transitionContext.containerView.addSubview(destination.view)
        
        destination.view.frame = CGRect(x: containerViewFrame.width,
                                        y: 0,
                                        width: source.view.frame.width,
                                        height: source.view.frame.height)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       animations: {
            source.view.frame = sourceViewTargetFrame
            destination.view.frame = destinationViewTargetFrame
        }) {finished in
            source.removeFromParent()
            transitionContext.completeTransition(finished)
        }
    }
    
}

