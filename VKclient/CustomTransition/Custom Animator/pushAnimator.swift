//
//  pushAnimator.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 9/25/21.
//

import UIKit

final class pushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = transitionContext.containerView.frame
        
        destination.view.transform = CGAffineTransform(translationX: source.view.bounds.width,
                                                       y: 0)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.75, animations: {
                let translation = CGAffineTransform(translationX: -200, y: 0)
                let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                source.view.transform = translation.concatenating(scale)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4, animations: {
                let translation = CGAffineTransform(translationX: source.view.bounds.width/2,
                                                    y: 0)
                let scale = CGAffineTransform(scaleX: 1.2, y: 1.2)
                destination.view.transform = translation.concatenating(scale)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                destination.view.transform = .identity
            })
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
    //        MARK: Animation with anchor point
    //        transitionContext.containerView.addSubview(destination.view)
    //        transitionContext.containerView.sendSubviewToBack(destination.view)
    //
    //        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
    //        destination.view.frame = transitionContext.containerView.frame
    //        destination.view.transform = CGAffineTransform(rotationAngle: -.pi/2)
    //
    //        source.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
    //        source.view.frame = transitionContext.containerView.frame
    //
    //        UIView.animate(
    //            withDuration: duration,
    //            animations: {
    //                source.view.transform = CGAffineTransform(rotationAngle: .pi/2)
    //                destination.view.transform = .identity
    //            }) { (isComplete) in
    //            if isComplete && !transitionContext.transitionWasCancelled {
    ////                source.removeFromParent()
    //            } else if transitionContext.transitionWasCancelled {
    //                destination.view.transform = .identity
    //            }
    //            transitionContext.completeTransition( isComplete && !transitionContext.transitionWasCancelled)
    //        }
    //
    //    }
}


