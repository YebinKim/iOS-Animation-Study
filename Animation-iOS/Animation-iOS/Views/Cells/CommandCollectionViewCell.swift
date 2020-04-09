//
//  CommandCollectionViewCell.swift
//  Animation-iOS
//
//  Created by Yebin Kim on 2020/04/09.
//  Copyright © 2020 Yebin Kim. All rights reserved.
//

import UIKit

protocol CommandCollectionViewCellDelegate {
    
    func commandButtonTapped(_ sender: UIButton)
    
}

class CommandCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var commandButton: UIButton!
    
    var delegate: CommandCollectionViewCellDelegate?
    
    @IBAction func commandButtonTapped(_ sender: UIButton) {
        delegate?.commandButtonTapped(sender)
    }
    
}
