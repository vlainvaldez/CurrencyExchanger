//
//  KeyboardManager.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/22/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public class KeyboardManager: NSObject {
    
    // MARK: - Delegate Properties
    public weak var delegate: KeyboardManagerDelegate?
    
    // MARK: Stored Properties
    public let scrollView: UIScrollView
    public let notificationCenter: NotificationCenter = NotificationCenter.default
    public var isKeyboardShown: Bool = false

    // MARK: - Initializers
    public init(scrollView: UIScrollView = UIScrollView()) {
        self.scrollView = scrollView
        self.scrollView.keyboardDismissMode = .interactive
    }

    // MARK: - Instance Methods
    public func beginObservingKeyboard() {
        self.notificationCenter.addObserver(
            self,
            selector: #selector(KeyboardManager.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        self.notificationCenter.addObserver(
            self,
            selector: #selector(KeyboardManager.keyboardDidHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    public func endObservingKeyboard() {
        self.notificationCenter.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        self.notificationCenter.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

}

// MARK: - Target Actions
extension KeyboardManager {

    @objc func keyboardWillShow(notification: Notification) {
        guard let info: CGRect = notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as? CGRect else { return }

        let contentInsets: UIEdgeInsets = UIEdgeInsets(
            top: self.scrollView.contentInset.top,
            left: 0.0,
            bottom: info.height,
            right: 0.0
        )

        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        self.isKeyboardShown = true
        
        if let delegate = self.delegate {
            delegate.kmScrollTo()
            delegate.kmDidShow(height: info.height)
        }
    }

    @objc func keyboardDidHide() {

        let contentInsets: UIEdgeInsets = UIEdgeInsets(
            top: self.scrollView.contentInset.top,
            left: 0.0,
            bottom: 0.0,
            right: 0.0
        )

        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        self.isKeyboardShown = false
        
        if let delegate = self.delegate {
            delegate.kmDidHide()
        }
    }
}
