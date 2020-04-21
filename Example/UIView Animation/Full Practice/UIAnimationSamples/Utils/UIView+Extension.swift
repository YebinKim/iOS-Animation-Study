/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

extension UIView {
  
  func move(to destination: CGPoint, duration: TimeInterval, options: UIView.AnimationOptions) {
    UIView.animate(withDuration: duration,
                   delay: 0,
                   options: options,
                   animations: {
                    self.center = destination
    },
                   completion: nil)
  }
  
  func rotate180(duration: TimeInterval, options: UIView.AnimationOptions) {
    UIView.animate(withDuration: duration,
                   delay: 0,
                   options: options,
                   animations: {
                    self.transform = self.transform.rotated(by: CGFloat.pi)
    },
                   completion: nil)
  }
  
  func addSubviewWithZoomInAnimation(_ view: UIView, duration: TimeInterval, options: UIView.AnimationOptions) {
    view.transform = view.transform.scaledBy(x: 0.01, y: 0.01)
    addSubview(view)
    
    UIView.animate(withDuration: duration,
                   delay: 0,
                   options: options,
                   animations: {
                    view.transform = CGAffineTransform.identity
    },
                   completion: nil)
  }
  
  func removeWithZoomOutAnimation(duration: TimeInterval, options: UIView.AnimationOptions) {
    UIView.animate(withDuration: duration,
                   delay: 0,
                   options: options,
                   animations: {
                    self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    },
                   completion: { _ in
                    self.removeFromSuperview()
    })
  }
  
  func addSubviewWithFadeAnimation(_ view: UIView, duration: TimeInterval, options: UIView.AnimationOptions) {
    view.alpha = 0.0
    addSubview(view)
    
    UIView.animate(withDuration: duration,
                   delay: 0,
                   options: options,
                   animations: {
                    view.alpha = 1.0
    },
                   completion: nil)
  }
  
  func removeWithSinkAnimation(steps: Int) {
    guard 1..<100 ~= steps else {
      fatalError("Steps must be between 0 and 100")
    }
    tag = steps
    _ = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(removeWithSinkAnimationRotateTimer), userInfo: nil, repeats: true)
  }
  
  @objc func removeWithSinkAnimationRotateTimer(timer: Timer) {
    let scale = transform.scaledBy(x: 0.9, y: 0.9)
    transform = scale.rotated(by: 0.314)
    alpha *= 0.98
    tag -= 1;
    if tag <= 0 {
      timer.invalidate()
      removeFromSuperview()
    }
  }
  
  func changeColor(to color: UIColor, duration: TimeInterval, options: UIView.AnimationOptions) {
    UIView.animate(withDuration: duration,
                   delay: 0,
                   options: options,
                   animations: {
                    self.backgroundColor = color
    },
                   completion: nil)
  }
  
}
