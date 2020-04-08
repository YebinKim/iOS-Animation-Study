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
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCommandCollectionView()
        
        addGestureRecognizers()
        
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
    
    private func changeTestViewShape(_ randNum: Int) {
        if randNum == 1 {
            testView.layer.cornerRadius = testView.frame.width / 2
        } else {
            testView.layer.cornerRadius = 0
        }
    }
    
    @objc
    func addTestView(sender: UITapGestureRecognizer) {
        if !startView.isHidden {
            stopStartAnimation()
        }
        
        guard sender.state == .ended else { return }
        testView.removeFromSuperview()
        
        let randNum = Int.random(in: 1...10)
        changeTestViewShape(randNum)
        
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
    
    @objc
    func playUpAnimation() {
        UIView.animate(withDuration: 0.01) {
            self.testView.transform.ty -= 1
        }
    }
    
    @objc
    func playLeftAnimation() {
        UIView.animate(withDuration: 0.01) {
            self.testView.transform.tx -= 1
        }
    }
    
    @objc
    func playRightAnimation() {
        UIView.animate(withDuration: 0.01) {
            self.testView.transform.tx += 1
        }
    }
    
    @objc
    func playDownAnimation() {
        UIView.animate(withDuration: 0.01) {
            self.testView.transform.ty += 1
        }
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
    
}

// MARK: - UICollectionView Delegate, UICollectionView DataSource

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
