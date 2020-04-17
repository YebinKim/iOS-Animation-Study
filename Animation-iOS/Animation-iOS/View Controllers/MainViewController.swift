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
    
    var timer: Timer?
    
    let moveValue: CGFloat = 1
    let moveDoubleValue: CGFloat = 50
    let rotateValue: CGFloat = 90 * (.pi / 180)
    let scaleUpValue: CGFloat = 1.2
    let scaleDownValue: CGFloat = 0.8
    
    var isPlayGradient: Bool = false
    var currentGradient: Int = 0
    var gradientStartPoint: CGPoint = CGPoint(x: 0.0, y: 0.0) {
        didSet {
            gradient.startPoint = gradientStartPoint
        }
    }
    var gradientEndPoint: CGPoint = CGPoint(x: 1.0, y: 1.0){
        didSet {
            gradient.endPoint = gradientEndPoint
        }
    }
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = self.testView.bounds
        gradient.colors = gradientColorSet[currentGradient]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.drawsAsynchronously = true
        self.testView.layer.addSublayer(gradient)
        
        return gradient
    }()
    var gradientColorSet: [[CGColor]] = [[UIColor.red.cgColor, UIColor.orange.cgColor],
                                         [UIColor.orange.cgColor, UIColor.yellow.cgColor],
                                         [UIColor.yellow.cgColor, UIColor.green.cgColor],
                                         [UIColor.green.cgColor, UIColor.blue.cgColor],
                                         [UIColor.blue.cgColor, UIColor.purple.cgColor],
                                         [UIColor.purple.cgColor, UIColor.red.cgColor]]
    
    var isFlipHorizontal: Bool = false {
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
    var isFlipVertical: Bool = false {
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
    
    var isShapeCircle: Bool = false
    
    private lazy var commandArrays: [UIImage?] = [UIImage(systemName: "rotate.right"),
                                                  UIImage(systemName: "rotate.left"),
                                                  UIImage(systemName: "paintbrush"),
                                                  UIImage(systemName: "arrow.up.left.and.arrow.down.right"),
                                                  UIImage(systemName: "arrow.down.right.and.arrow.up.left"),
                                                  UIImage(systemName: "hammer"),
                                                  UIImage(systemName: "flip.horizontal"),
                                                  UIImage(systemName: "flip.horizontal")?.rotate(-(.pi / 2)),
                                                  UIImage(systemName: "star")]
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCommandCollectionView()
        
        addGestureRecognizers()
        
        gradient.colors = gradientColorSet[currentGradient]
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
