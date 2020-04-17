//
//  MainViewController+Animations.swift
//  Animation-iOS
//
//  Created by Yebin Kim on 2020/04/17.
//  Copyright © 2020 Yebin Kim. All rights reserved.
//

import UIKit

extension MainViewController {

    // MARK: - Actions
    func playStartAnimation() {
        self.view.addSubview(startView)
        self.view.addSubview(startLabel)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.repeat, .autoreverse, .curveEaseOut], animations: {
            self.startView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.startLabel.transform = CGAffineTransform(translationX: 0, y: 4)
        }, completion: nil)
    }
    
    func stopStartAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.startView.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.startLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        }, completion: { _ in
            self.startView.isHidden = true
            self.startLabel.isHidden = true
            
            self.startView.removeFromSuperview()
            self.startLabel.removeFromSuperview()
        })
    }
    
    // MARK: Add Content
    @objc
    func addTestView(sender: UITapGestureRecognizer) {
        if !startView.isHidden {
            stopStartAnimation()
        }
        
        guard sender.state == .ended else { return }
        testView.removeFromSuperview()
        self.view.addSubview(testView)
        
        let touchLocation: CGPoint = sender.location(in: self.view)
        testView.center = touchLocation
        testView.isHidden = false
        testView.alpha = 0
        testView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.curveEaseOut], animations: {
            self.testView.alpha = 1.0
            self.testView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    // MARK: Moving Animation
    @objc
    func playUpAnimation() {
        UIView.animate(withDuration: 0.01) {
            self.testView.transform.ty -= self.moveValue
        }
    }
    
    @objc
    func playLeftAnimation() {
        UIView.animate(withDuration: 0.01) {
            self.testView.transform.tx -= self.moveValue
        }
    }
    
    @objc
    func playRightAnimation() {
        UIView.animate(withDuration: 0.01) {
            self.testView.transform.tx += self.moveValue
        }
    }
    
    @objc
    func playDownAnimation() {
        UIView.animate(withDuration: 0.01) {
            self.testView.transform.ty += self.moveValue
        }
    }
    
    func playDoubleUpAnimation() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.curveEaseOut], animations: {
            self.testView.transform.ty -= self.moveDoubleValue
        }, completion: nil)
    }
    
    func playDoubleLeftAnimation() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.curveEaseOut], animations: {
            self.testView.transform.tx -= self.moveDoubleValue
        }, completion: nil)
    }
    
    func playDoubleRightAnimation() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.curveEaseOut], animations: {
            self.testView.transform.tx += self.moveDoubleValue
        }, completion: nil)
    }
    
    func playDoubleDownAnimation() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.curveEaseOut], animations: {
            self.testView.transform.ty += self.moveDoubleValue
        }, completion: nil)
    }
    
    // MARK: Rotating Animation
    func playRotationRightAnimation() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.curveEaseOut], animations: {
            self.testView.transform = self.testView.transform.rotated(by: self.rotateValue)
        }, completion: nil)
    }
    
    func playRotationLeftAnimation() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.curveEaseOut], animations: {
            self.testView.transform = self.testView.transform.rotated(by: -self.rotateValue)
        }, completion: nil)
    }
    
    // MARK: Scaling Animation
    func playScaleUpAnimation() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.curveEaseOut], animations: {
            self.testView.transform = self.testView.transform.scaledBy(x: self.scaleUpValue, y: self.scaleUpValue)
        }, completion: nil)
    }
    
    func playScaleDownAnimation() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [.curveEaseOut], animations: {
            self.testView.transform = self.testView.transform.scaledBy(x: self.scaleDownValue, y: self.scaleDownValue)
        }, completion: nil)
    }
    
    // MARK: Color Change Animation
    func playColorChangeAnimation(_ play: Bool) {
        if play {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changedGradation), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
            gradient.colors = gradientColorSet[currentGradient]
        }
    }
    
    @objc
    private func changedGradation() {
        if currentGradient < gradientColorSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let colorChange = CABasicAnimation(keyPath: "colors")
        colorChange.toValue = gradientColorSet[currentGradient]
        
        let positionChange = CABasicAnimation(keyPath: "startPoint")
        positionChange.fromValue = gradientEndPoint
        positionChange.toValue = gradientStartPoint
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [colorChange, positionChange]
        groupAnimation.duration = 1.0
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        groupAnimation.isRemovedOnCompletion = false
        
        gradient.add(groupAnimation, forKey: "groupAnimation")
    }
    
    // MARK: Shake Animation
    func playShakeAnimation() {
        let positionChange = CAKeyframeAnimation(keyPath: "transform.translation.x")
        positionChange.duration = 0.5
        positionChange.timingFunction = CAMediaTimingFunction(name: .easeOut)
        positionChange.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        
        testView.layer.add(positionChange, forKey: "position")
    }
    
    // MARK: Flip Animation
    func playFlipHorizontalAnimation() {
        UIView.transition(with: testView, duration: 1, options: .transitionFlipFromLeft, animations: nil, completion: { _ in
            self.isFlipHorizontal = !self.isFlipHorizontal
        })
    }
    
    func playFlipVerticalAnimation() {
        UIView.transition(with: testView, duration: 1, options: .transitionFlipFromTop, animations: nil, completion: { _ in
            self.isFlipVertical = !self.isFlipVertical
        })
    }
    
    // MARK: Shape Change Animation
    func playShapeChangeAnimation() {
        isShapeCircle = !isShapeCircle
        
        let shapeChange = CABasicAnimation(keyPath: "cornerRadius")
        shapeChange.duration = 0.5
        shapeChange.fillMode = .forwards
        shapeChange.isRemovedOnCompletion = false
        shapeChange.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        if isShapeCircle {
            shapeChange.fromValue = 0
            shapeChange.toValue = testView.bounds.width / 2
        } else {
            shapeChange.fromValue = testView.bounds.width / 2
            shapeChange.toValue = 0
        }
        
        testView.layer.add(shapeChange, forKey: "shape")
    }

}
