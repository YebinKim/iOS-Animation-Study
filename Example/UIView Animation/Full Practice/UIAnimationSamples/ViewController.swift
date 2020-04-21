/// Copyright (c) 2018 Razeware LLC
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

class ViewController: UIViewController {
  
  /// The currently selected curve to be used for all animations
  var selectedCurve: UIView.AnimationCurve = .easeInOut
  
  /// A list of colors to be used when animating the background color
  let colors: [UIColor] = [.white, .red, .green, .orange, .yellow, .lightGray, .darkGray]
  
  /// The ⬇️ button that rotates and moves around the screen
  @IBOutlet var movingButton: UIButton!
  
  /// The fake HUD view
  @IBOutlet var hud: FakeHUD?
  
  @IBAction func moveTo(button: UIButton) {
    let destination = self.view.convert(button.center, from: button.superview)
    movingButton.move(to: destination.applying(CGAffineTransform(translationX: 0.0, y: -70.0)),
                      duration: 1.0,
                      options: selectedCurve.animationOption)
  }
  
  @IBAction func rotate(button: UIButton) {
    button.rotate180(duration: 1.0, options: selectedCurve.animationOption)
  }
  
  @IBAction func zoomIn(button: UIButton) {
    let pickerVC = AnimationCurvePickerViewController(style: .grouped)
    pickerVC.delegate = self
    pickerVC.view.bounds = CGRect(x: 0, y: 0, width: 280, height: 300)
    pickerVC.view.center = view.center
    
    addChild(pickerVC)
    self.view.addSubviewWithZoomInAnimation(pickerVC.view, duration: 1.0, options: selectedCurve.animationOption)
    pickerVC.didMove(toParent: self)
  }
  
  @IBAction func showHUD() {
    let nib = UINib.init(nibName: "FakeHUD", bundle: nil)
    nib.instantiate(withOwner: self, options: nil)
    if let hud = hud {
      hud.center = view.center
      self.view.addSubviewWithFadeAnimation(hud, duration: 1.0, options: selectedCurve.animationOption)
    }
  }
  
  @IBAction func dismissHUD() {
    hud?.removeWithSinkAnimation(steps: 75)
  }
  
  @IBAction func changeBackgroundColor() {
    self.view.changeColor(to: colors.randomElement()!, duration: 1.0, options: selectedCurve.animationOption)
  }
  
}

// MARK: AnimationCurvePickerViewControllerDelegate
extension ViewController: AnimationCurvePickerViewControllerDelegate {
  
  func animationCurvePickerViewController(_ controller: AnimationCurvePickerViewController, didSelectCurve curve: UIView.AnimationCurve) {
    selectedCurve = curve
    
    controller.willMove(toParent: nil)
    controller.view.removeWithZoomOutAnimation(duration: 1.0, options: selectedCurve.animationOption)
    controller.removeFromParent()
  }
  
}
