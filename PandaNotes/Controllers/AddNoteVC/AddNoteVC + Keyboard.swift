//
//  AddNoteVC + Keyboard.swift
//  PandaNotes
//
//  Created by Philip Plamenov on 9.08.21.
//

import Foundation
import UIKit
extension AddNoteVC {
    func keyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard !isKeyboardAppear else { return }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var height = keyboardSize.size.height
            if #available(iOS 11.0, *) {
                let bottomInset = view.safeAreaInsets.bottom
                height -= bottomInset
            }
            textViewBottom.constant = height
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        isKeyboardAppear = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard isKeyboardAppear else { return }
        textViewBottom.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        isKeyboardAppear = false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
