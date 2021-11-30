//
//  PulseAnimation.swift
//  CustomKeyboard
//
//  Created by Dzaky on 30/11/21.
//

import Foundation
import UIKit

class PulseAnimation: CALayer {
    
    var animationGroup = CAAnimationGroup()
    var animationDuration: TimeInterval = 1
    var radius: CGSize = CGSize(width: 100, height: 100)
    var numberOfPulse: Float = 10
 
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init (numberOfPulse: Float = 10, radius: CGSize, position: CGPoint) {
        super.init()
        self.backgroundColor = UIColor.black.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.numberOfPulse = numberOfPulse
        self.position = position
        
        self.bounds = CGRect(x: 0, y: 0, width: radius.width, height: radius.height)
        self.cornerRadius = 10
    }
    
    func setupTapAnimation() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.setupTapAnimationGroup()
            DispatchQueue.main.async {
                self.add(self.animationGroup, forKey: "pulse")
            }
        }
    }
    
    func setupPressedAnimation() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.setupPressedAnimationGroup()
            DispatchQueue.main.async {
                self.add(self.animationGroup, forKey: "pulse")
            }
        }
    }
    
    private func setupTapAnimationGroup() {
        self.animationGroup.duration = animationDuration
        self.animationGroup.repeatCount = numberOfPulse
        let defaultCurve = CAMediaTimingFunction(name: .default)
        self.animationGroup.timingFunction = defaultCurve
        self.animationGroup.animations = [scaleTapAnimation(), createTapOpacityAnimation()]
    }
    
    private func setupPressedAnimationGroup() {
        self.animationGroup.fillMode = .forwards
        self.animationGroup.isRemovedOnCompletion = false
        self.animationGroup.duration = animationDuration
        self.animationGroup.repeatCount = numberOfPulse
        let defaultCurve = CAMediaTimingFunction(name: .default)
        self.animationGroup.timingFunction = defaultCurve
        self.animationGroup.animations = [scalePressedAnimation(), createPressedOpacityAnimation()]
    }
    
    private func scaleTapAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: 0)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationDuration
        return scaleAnimation
    }
    
    private func scalePressedAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: 0)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationDuration
        return scaleAnimation
    }
    
    private func createTapOpacityAnimation() -> CAKeyframeAnimation {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.keyTimes = [0, 0.3, 1]
        opacityAnimation.values = [0.4, 0.8, 0]
        return opacityAnimation
    }
    
    private func createPressedOpacityAnimation() -> CAKeyframeAnimation {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.keyTimes = [0, 0.3, 1]
        opacityAnimation.values = [0.4, 0.6, 0.8]
        return opacityAnimation
    }
    
}
