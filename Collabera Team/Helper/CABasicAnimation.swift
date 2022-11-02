//
//  CABasicAnimation.swift
//  Collabera Team
//
//  Created by vinay kumar bg on 30/10/22.
//

import UIKit

extension UIView {
    
    enum BasicAnimType: String {
        case transformScale = "transform.scale"
        case fillStroke = "strokeEnd"
        
        func value() -> String {
            return self.rawValue
        }
    }
    
    struct BasicAnimData {
        
        var keyPath: String
        var delay: Double
        var toValue: Float
        var duration: CFTimeInterval
        var fillMode: CAMediaTimingFillMode?
        var autoreverses: Bool
        var repeatCount: Float
        var isRemovedOnCompletion: Bool
        var timingFunction: CAMediaTimingFunction?
        var animId: String?
        var animIdKey: String?
        
        init(keyPath: BasicAnimType, delay: Double = 0, toValue: Float, duration: CFTimeInterval, fillMode: CAMediaTimingFillMode? = nil,
             autoreverses: Bool, isRemovedOnCompletion: Bool, repeatCount: Float,
             timingFunction: CAMediaTimingFunction? = nil, animId: String? = nil, animIdKey: String? = nil) {
            
            self.keyPath = keyPath.value()
            self.delay = delay
            self.toValue = toValue
            self.duration = duration
            self.fillMode = fillMode
            self.isRemovedOnCompletion = isRemovedOnCompletion
            self.autoreverses = autoreverses
            self.repeatCount = repeatCount
            self.timingFunction = timingFunction
            self.animId = animId
            self.animIdKey = animIdKey
        }
    }
    
    func createBaseAnimation(animData: BasicAnimData) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: animData.keyPath)
        animation.beginTime = CACurrentMediaTime() + animData.delay
        animation.toValue = animData.toValue
        animation.duration = animData.duration
        animation.isRemovedOnCompletion = animData.isRemovedOnCompletion
        animation.autoreverses = animData.autoreverses
        animation.repeatCount = animData.repeatCount

        if let fillMode = animData.fillMode {
            animation.fillMode = fillMode
        }

        if let timingFunction = animData.timingFunction {
            animation.timingFunction = timingFunction
        }

        if let animId = animData.animId, let animIdKey = animData.animIdKey {
            animation.setValue(animId, forKey: animIdKey)
        }

        return animation
    }
    
}
