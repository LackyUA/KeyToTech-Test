//
//  MainViewController.swift
//  KeyToTech-Test
//
//  Created by Dima Dobrovolskyy on 9/12/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import UIKit

/// <#Description#>
final class MainViewController: UIViewController {
    
    // MARK: - Constants
    
    private let textFieldPlaceholders = ["Enter lower bounds", "Enter upper bounds"]
    
    // MARK: - Properies
    
    private typealias Bounds = (lower: Int, upper: Int)
    private var bounds: Bounds!
    
    // MARK: - IBOutlets
    
    @IBOutlet private var separators: [UIView]!
    @IBOutlet private var textViews: [UITextField]!
    @IBOutlet weak var showCommentsButton: UIButton!
    @IBOutlet private weak var validationLabel: UILabel! {
        didSet {
            self.validationLabel.alpha = 0
        }
    }
    @IBOutlet private weak var image: UIImageView! {
        didSet {
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotateAnimation.fromValue = 0.0
            rotateAnimation.toValue = CGFloat(.pi * 2.0)
            rotateAnimation.duration = 40.0
            rotateAnimation.repeatCount = 30.0
            
            self.image.layer.add(rotateAnimation, forKey: nil)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func commentButtonDidTapped(_ sender: UIButton) {
        hideKeyboard()
        if validate() {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: CommentsViewController.self)) as? CommentsViewController {
                
                vc.bounds = bounds
                
                let viewWithNavBar = UINavigationController(rootViewController: vc)
                present(viewWithNavBar, animated: true)
            }
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Configuration UI
    
    /// Initial configurations.
    private func configure() {
        configureTextViews()
        configureTapGesture()
        confgiureKeyboardNotifications()
    }

    /// Method for configuring text fields placeholder appearance.
    private func configureTextViews() {
        textViews.enumerated().forEach { (index, textView) in
            let palceholderAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray(),
                NSAttributedString.Key.font: UIFont.regularWithSize(20)
            ]
            
            textView.tintColor = .lightGray
            textView.attributedPlaceholder = NSAttributedString(
                string: textFieldPlaceholders[index],
                attributes: palceholderAttributes
            )
        }
    }
    
    /// Method for configuring tap gesture which hiding keyboard.
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    /// Method for configuring notifications when keyboard hiding/showing.
    private func confgiureKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Keyboard notification methods
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.keyWindow
                    let bottomPadding = window?.safeAreaInsets.bottom ?? 0
                    self.view.frame.origin.y -= keyboardSize.height + bottomPadding
                } else {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: - Validation
    
    /// Methods for validation input text in fields.
    ///
    /// - Returns: validation success.
    private func validate() -> Bool {
        for textView in textViews {
            if let text = textView.text, text == "" {
                validationLabel.text = "All fields must be filled."
                showCommentsButton.shake()
                highlight(with: .red, and: 1)
                
                return false
            }
        }
        
        if
            let lowerBounds = Int(textViews[0].text ?? ""),
            let upperBounds = Int(textViews[1].text ?? ""),
            upperBounds > lowerBounds
        {
            bounds = (lower: lowerBounds, upper: upperBounds)
            highlight(with: .lightGray, and: 0)
            
            return true
        } else {
            validationLabel.text = "Upper bounds should be heigher then lower."
            showCommentsButton.shake()
            highlight(with: .red, and: 1)
            
            return false
        }
    }
    
    /// Method for highlight UI components in case of validation failure.
    private func highlight(with color: UIColor, and alpha: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.separators.forEach { $0.backgroundColor = color }
            self.validationLabel.alpha = alpha
        }
    }
    
}
