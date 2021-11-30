//
//  KeypadCell.swift
//  CustomKeyboard
//
//  Created by Dzaky on 29/11/21.
//

import UIKit

class KeypadCell: UICollectionViewCell {
    
    @IBOutlet weak var padLabel: UIButton!
    private var pad: String!
    
    func setup(pad: String) {
        self.pad = pad
        padLabel.setTitle(pad, for: .normal)
    }
    
}
