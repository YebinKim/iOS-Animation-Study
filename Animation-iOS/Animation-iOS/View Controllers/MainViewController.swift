//
//  MainViewController.swift
//  Animation-iOS
//
//  Created by Yebin Kim on 2020/04/07.
//  Copyright © 2020 Yebin Kim. All rights reserved.
//

import UIKit

// MARK: - MainViewController

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    @IBOutlet weak var commandCollectionView: UICollectionView!
    
    // MARK: - Properties
    lazy var testView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.backgroundColor = UIColor.red
        view.clipsToBounds = true
        view.isHidden = true
        
        return view
    }()
    
    lazy var startView: UIView = {
        let size = CGRect(x: 0, y: 0, width: 40, height: 40)
        let view = UIView(frame: size)
        view.backgroundColor = UIColor.clear
        view.alpha = 0.2
        view.clipsToBounds = true
        view.layer.cornerRadius = view.frame.width / 2
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.gray.cgColor
        view.center = self.view.center
        
        return view
    }()
    
    lazy var startLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "여기를 탭!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        label.center = CGPoint(x: self.view.center.x, y: self.view.center.y - startView.frame.height - 8)
        
        return label
    }()
    
    private var timer: Timer?
    
    private let moveValue: CGFloat = 1
    private let moveDoubleValue: CGFloat = 50
    private let rotateValue: CGFloat = 90 * (.pi / 180)
    private let scaleUpValue: CGFloat = 1.2
    private let scaleDownValue: CGFloat = 0.8
    
    private var isPlayGradient: Bool = false
    private var currentGradient: Int = 0
    private var gradientStartPoint: CGPoint = CGPoint(x: 0.0, y: 0.0) {
        didSet {
            gradient.startPoint = gradientStartPoint
        }
    }
    private var gradientEndPoint: CGPoint = CGPoint(x: 1.0, y: 1.0){
        didSet {
            gradient.endPoint = gradientEndPoint
        }
    }
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = self.testView.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.drawsAsynchronously = true
        self.testView.layer.addSublayer(gradient)
        
        return gradient
    }()
    private var gradientSet: [[CGColor]] = [[UIColor.red.cgColor, UIColor.orange.cgColor],
                                            [UIColor.orange.cgColor, UIColor.yellow.cgColor],
                                            [UIColor.yellow.cgColor, UIColor.green.cgColor],
                                            [UIColor.green.cgColor, UIColor.blue.cgColor],
                                            [UIColor.blue.cgColor, UIColor.purple.cgColor],
                                            [UIColor.purple.cgColor, UIColor.red.cgColor]]
    
    private lazy var commandArrays: [UIImage?] = [UIImage(systemName: "rotate.right"),
                                                  UIImage(systemName: "rotate.left"),
                                                  UIImage(systemName: "paintbrush"),
                                                  UIImage(systemName: "arrow.up.left.and.arrow.down.right"),
                                                  UIImage(systemName: "arrow.down.right.and.arrow.up.left"),
                                                  UIImage(systemName: "hammer"),
                                                  UIImage(systemName: "flip.horizontal"),
                                                  UIImage(systemName: "flip.horizontal")?.rotate(-(.pi / 2)),
                                                  UIImage(systemName: "star")]
    
    private var isShapeCircle: Bool = false
    
    private var isFlipHorizontal: Bool = false {
        didSet {
            if isFlipHorizontal {
                gradientStartPoint = CGPoint(x: 1.0, y: 0.0)
                gradientEndPoint = CGPoint(x: 0.0, y: 1.0)
            } else {
                gradientStartPoint = CGPoint(x: 0.0, y: 0.0)
                gradientEndPoint = CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    
    private var isFlipVertical: Bool = false {
        didSet {
            if isFlipVertical {
                gradientStartPoint = CGPoint(x: 0.0, y: 1.0)
                gradientEndPoint = CGPoint(x: 1.0, y: 0.0)
            } else {
                gradientStartPoint = CGPoint(x: 0.0, y: 0.0)
                gradientEndPoint = CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCommandCollectionView()
        
        addGestureRecognizers()
        
        gradient.colors = gradientSet[currentGradient]
        playStartAnimation()
    }
    
    // MARK: - Initializing
    private func initializeCommandCollectionView() {
        commandCollectionView.delegate = self
        commandCollectionView.dataSource = self
    }
    
    private func addGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addTestView))
        self.view.addGestureRecognizer(tapGesture)
    }
    
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
            gradient.colors = gradientSet[currentGradient]
        }
    }
    
    @objc
    private func changedGradation() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let colorChange = CABasicAnimation(keyPath: "colors")
        colorChange.toValue = gradientSet[currentGradient]
        
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
    
    // MARK: - IBActions
    @IBAction func arrowButtonTouchDown(_ sender: UIButton) {
        var action: Selector?
        
        switch sender {
        case upButton:
            action = #selector(playUpAnimation)
            case leftButton:
            action = #selector(playLeftAnimation)
            case rightButton:
            action = #selector(playRightAnimation)
            case downButton:
            action = #selector(playDownAnimation)
        default:
            break
        }
        
        guard action != nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: action!, userInfo: nil, repeats: true)
    }
    
    @IBAction func arrowButtonTouchUp(_ sender: UIButton) {
        timer?.invalidate()
    }
    
    @IBAction func arrowButtonTouchDownRepeat(_ sender: UIButton) {
        switch sender {
        case upButton:
            playDoubleUpAnimation()
            case leftButton:
            playDoubleLeftAnimation()
            case rightButton:
            playDoubleRightAnimation()
            case downButton:
            playDoubleDownAnimation()
        default:
            break
        }
    }
    
}

// MARK: - UICollectionView Delegate, UICollectionView DataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commandArrays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commandCell", for: indexPath) as? CommandCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.commandButton.setImage(commandArrays[indexPath.row], for: .normal)
        cell.delegate = self
        
        return cell
    }
    
}

// MARK: - CommandCollectionViewCellDelegate
extension MainViewController: CommandCollectionViewCellDelegate {
    
    func commandButtonTapped(_ sender: UIButton) {
        guard let indexPath = commandCollectionView.indexPathForItem(at: commandCollectionView.convert(sender.center,
                                                                                                       from: sender.superview)) else { return }
        
        switch indexPath.row {
        case 0:
            playRotationRightAnimation()
        case 1:
            playRotationLeftAnimation()
        case 2:
            isPlayGradient = !isPlayGradient
            sender.isSelected = isPlayGradient
            playColorChangeAnimation(sender.isSelected)
        case 3:
            playScaleUpAnimation()
        case 4:
            playScaleDownAnimation()
        case 5:
            playShakeAnimation()
        case 6:
            playFlipHorizontalAnimation()
        case 7:
            playFlipVerticalAnimation()
        case 8:
            playShapeChangeAnimation()
        default:
            break
        }
    }
    
}
