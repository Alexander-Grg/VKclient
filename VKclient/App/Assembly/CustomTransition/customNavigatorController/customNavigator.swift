//
//  customNavigator.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 25.09.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit

final class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var isStarted: Bool = false
    var isFinished: Bool = false
}
final class CustomNavigatorController: UINavigationController, UINavigationControllerDelegate {
    let interactiveTransition = CustomInteractiveTransition()
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(hand(_:)))
        recognizer.edges = [.left]
        view.addGestureRecognizer(recognizer)
    }
    @objc func hand(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            interactiveTransition.isStarted = true
            popViewController(animated: true)
        case .changed:
            guard (recognizer.view?.bounds.width) != nil else {
                interactiveTransition.isStarted = false
                interactiveTransition.cancel()
                return
            }
            let translation = recognizer.translation(in: view)
            let relativeTranslation = translation.x / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            interactiveTransition.isFinished = progress > 0.33
            interactiveTransition.update(progress)
        case .ended:
            interactiveTransition.isStarted = false
            interactiveTransition.isFinished ? interactiveTransition.finish() : interactiveTransition.cancel()
        case .cancelled:
            interactiveTransition.isStarted = false
            interactiveTransition.cancel()
        default:
            return
        }
    }
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return PopAnimator()
        case .push:
            return PushAnimator()
        default:
            return nil
        }
    }
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
    -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.isStarted ? interactiveTransition : nil }
}
