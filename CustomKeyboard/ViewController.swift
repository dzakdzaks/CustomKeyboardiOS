//
//  ViewController.swift
//  CustomKeyboard
//
//  Created by Dzaky on 29/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionViewPad: UICollectionView!
    @IBOutlet weak var collectionViewPadHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: DisabledUITextField!
    
    var timer: Timer?
    
    var isDeviceNotHasPhysicalHomeButton: Bool {
        if #available(iOS 13.0, *), UIApplication.shared.windows[0].safeAreaInsets.bottom > 0 {
            return true
        } else {
            if let keyWindow = UIApplication.shared.keyWindow, keyWindow.safeAreaInsets.bottom > 0 {
                return true
            }
        }
        return false
    }
    
    private let keypads: [String] = ["1","2","3","4","5","6","7","8","9","0","000","⌫"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionViewPadHeight.constant = self.collectionViewPad.collectionViewLayout.collectionViewContentSize.height
        
        if isDeviceNotHasPhysicalHomeButton {
            buttonBottomConstraint.constant = 0
        } else {
            buttonBottomConstraint.constant = -16
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    private func setup() {
        textField.inputView = UIView()
        textField.inputAccessoryView = UIView()
        textField.delegate = self
        collectionViewPad.dataSource = self
        collectionViewPad.delegate = self
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let endPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        keypads.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let keypad = keypads[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeypadCell", for: indexPath) as? KeypadCell else {
            return UICollectionViewCell()
        }
        if keypad == "⌫" {
            cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(backspaceHold))
            cell.padLabel.addGestureRecognizer(longGesture)
        } else {
            cell.backgroundColor = UIColor(white: 1, alpha: 1.0)
        }
        cell.layer.cornerRadius = 10
        cell.setup(pad: keypad)
        cell.padLabel.tag = indexPath.row
        cell.padLabel.addTarget(self, action: #selector(padClicked), for: .touchUpInside)
        return cell
    }
    
    
    @objc func backspaceHold(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func handleTimer(timer: Timer) {
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        textField.deleteBackward()
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    @objc private func padClicked(sender: UIButton) {
        let pad = keypads[sender.tag]
        if pad == "⌫" {
            guard let text = textField.text, !text.isEmpty else {
                return
            }
            textField.deleteBackward()
        } else {
            textField.text?.append(contentsOf: pad)
        }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.size.width * 0.3 - 5, height: view.frame.size.width * 0.12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    //        let generator = UIImpactFeedbackGenerator(style: .light)
    //        generator.impactOccurred()
    //
    //        guard let cell = collectionView.cellForItem(at: indexPath) as? KeypadCell else {
    //            return
    //        }
    //        let pulse = PulseAnimation(numberOfPulse: 1, radius: cell.bounds.size, position: cell.contentView.center)
    //        pulse.animationDuration = 0.5
    //        pulse.setupPressedAnimation()
    //        pulse.backgroundColor = CGColor(gray: 0.5, alpha: 0.5)
    //        pulse.name = "pressed"
    //        cell.layer.insertSublayer(pulse, below: cell.layer)
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    //        let pad = keypads[indexPath.row]
    //        if pad == "⌫" {
    //            guard let text = textField.text, !text.isEmpty else {
    //                return
    //            }
    //            textField.text = String(text.dropLast())
    //        } else {
    //            textField.text = "\(textField.text ?? "")\(pad)"
    //        }
    //
    //        let generator = UIImpactFeedbackGenerator(style: .light)
    //        generator.impactOccurred()
    //
    //        guard let cell = collectionView.cellForItem(at: indexPath) as? KeypadCell else {
    //            return
    //        }
    //
    //        cell.layer.sublayers?
    //            .filter { $0.name == "pressed" }
    //            .forEach { $0.removeFromSuperlayer() }
    //        //        cell.layer.sublayers?.popLast()
    //    }
    
}


