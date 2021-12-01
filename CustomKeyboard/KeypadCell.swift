//
//  KeypadCell.swift
//  CustomKeyboard
//
//  Created by Dzaky on 29/11/21.
//

import UIKit

class KeypadCell: UICollectionViewCell {
    
    @IBOutlet weak var padLabel: RippleButton!
    private var pad: String!
    
    func setup(pad: String) {
        self.pad = pad
        padLabel.trackTouchLocation = true
        padLabel.shadowRippleEnable = false
        padLabel.setTitle(pad, for: .normal)
    }
    
}
