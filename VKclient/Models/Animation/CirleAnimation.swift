//
//  CirleAnimation.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 14.05.2022.
//

import Foundation
import UIKit

class CirleAnimation {
    
    let circle1: UIImageView
    let circle2: UIImageView
    let circle3: UIImageView

    func animationLoading() {
        
        self.circle1.alpha = 0
        self.circle2.alpha = 0
        self.circle3.alpha = 0
        
        UIView.animateKeyframes(withDuration: 7,
                                delay: 0,
                                options: [.repeat, .autoreverse],
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 0.5,
                               animations: { self.circle1.alpha = 1})
            UIView.addKeyframe(withRelativeStartTime: 0.33,
                               relativeDuration: 0.5,
                               animations: { self.circle2.alpha = 1})
            UIView.addKeyframe(withRelativeStartTime: 0.66,
                               relativeDuration: 0.5,
                               animations: { self.circle3.alpha = 1})
        },
                                completion: nil)
    }
    
    init(circle1: UIImageView, circle2: UIImageView, circle3: UIImageView){
        self.circle1 = circle1
        self.circle2 = circle2
        self.circle3 = circle3
    }
}
