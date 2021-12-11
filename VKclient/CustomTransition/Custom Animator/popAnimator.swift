//
//  popAnimator.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 25.09.2021.
//

import UIKit

final class popAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard  let source = transitionContext.viewController(forKey: .from) else { return }
        guard  let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = transitionContext.containerView.frame
        let translation = CGAffineTransform(translationX: -200, y: 0)
        let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
        destination.view.transform = translation.concatenating(scale)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75, animations: {
                destination.view.transform = .identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                let translation = CGAffineTransform(translationX: source.view.bounds.width/2,
                                                    y: 0)
                let scale = CGAffineTransform(scaleX: 1.2, y: 1.2)
                source.view.transform = translation.concatenating(scale)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4, animations: {
                source.view.transform = CGAffineTransform(translationX: source.view.bounds.width,
                                                          y: 0)
            })
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
    
    //    MARK: Animation with anchor point
    //        transitionContext.containerView.addSubview(destination.view)
    //        transitionContext.containerView.sendSubviewToBack(destination.view)
    //
    //                destination.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
    //        setAnchorPoint(anchorPoint: CGPoint(x: 0, y: 0), forView: destination.view)
    //        destination.view.frame = transitionContext.containerView.frame
    //        destination.view.transform = CGAffineTransform(rotationAngle: .pi/2)
    //
    //        UIView.animate(
    //            withDuration: duration,
    //            animations: {
    //                source.view.transform = CGAffineTransform(rotationAngle: -.pi/2)
    //                destination.view.transform = .identity
    //            }) { (isComplete) in
    //
    //                if isComplete && !transitionContext.transitionWasCancelled {
    //                    source.removeFromParent()
    //                } else if transitionContext.transitionWasCancelled {
    //                    destination.view.transform = .identity
    //                }
    //                transitionContext.completeTransition( isComplete && !transitionContext.transitionWasCancelled)
    //                destination.view.isHidden = false
    //            }
    //
    //    }
    //
    //    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
    //        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x,
    //                               y: view.bounds.size.height * anchorPoint.y)
    //
    //
    //        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x,
    //                               y: view.bounds.size.height * view.layer.anchorPoint.y)
    //
    //        newPoint = newPoint.applying(view.transform)
    //        oldPoint = oldPoint.applying(view.transform)
    //
    //        var position = view.layer.position
    //        position.x -= oldPoint.x
    //        position.x += newPoint.x
    //
    //        position.y -= oldPoint.y
    //        position.y += newPoint.y
    //
    //        view.layer.position = position
    //        view.layer.anchorPoint = anchorPoint
    //    }
}

