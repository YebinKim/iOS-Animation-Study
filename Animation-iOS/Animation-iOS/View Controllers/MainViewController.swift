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
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCommandCollectionView()
    }
    
    // MARK: - Initializing
    
    private func initializeCommandCollectionView() {
        commandCollectionView.delegate = self
        commandCollectionView.dataSource = self
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
