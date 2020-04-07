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
        view.backgroundColor = UIColor.red
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        return view
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCommandCollectionView()
        
        playStartAnimation()
    }
    
    // MARK: - Initializing
    
    private func initializeCommandCollectionView() {
        commandCollectionView.delegate = self
        commandCollectionView.dataSource = self
    }
    
    // MARK: - Actions
    
    func playStartAnimation() {
        let size = CGRect(x: 0, y: 0, width: 40, height: 40)
        let ring = UIView(frame: size)
        ring.backgroundColor = UIColor.clear
        ring.alpha = 0.2
        ring.clipsToBounds = true
        ring.layer.cornerRadius = ring.frame.width / 2
        ring.layer.borderWidth = 4
        ring.layer.borderColor = UIColor.gray.cgColor
        ring.center = self.view.center
        
        let label = UILabel(frame: CGRect.zero)
        label.text = "여기를 탭!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        label.center = CGPoint(x: self.view.center.x, y: self.view.center.y - ring.frame.height - 8)
        
        self.view.addSubview(ring)
        self.view.addSubview(label)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.repeat, .autoreverse, .curveEaseOut], animations: {
            ring.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            label.transform = CGAffineTransform(translationX: 0, y: 4)
        }, completion: nil)
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
