//
//  InputView.swift
//  NoteManager
//
//  Created by Lada Vrska on 15/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit

open class InputView: UITextView {
    
    public weak var inputViewDelegate: UITextViewDelegate?
    open var borderWidth = CGFloat(8.0)
    open var placeholderText = "New note ..."
    public var hasBorder: Bool = false
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
        //configure()
    }
    
    public convenience init(hasBorder: Bool) {
        
        self.init()
        self.hasBorder = hasBorder
        configure()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func configure() {
        self.font = .systemFont(ofSize: 18)
        self.textColor = .darkGray
        self.textAlignment = .left
        self.backgroundColor = .white
        if hasBorder {
            prepareBorder()
        }
        self.text = placeholderText
    }
    
    func prepareBorder() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.8
        self.layer.cornerRadius = 4.0
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        self.layer.masksToBounds = true
    }
    
}

extension InputView: UITextViewDelegate {
    
    @objc open func textViewDidChange(_ textView: UITextView) {
        inputViewDelegate?.textViewDidChange?(textView)
    }
    
    @objc open func textViewDidBeginEditing(_ textView: UITextView) {
        inputViewDelegate?.textViewDidBeginEditing?(textView)
    }
    
}

//extension InputArea: UITextViewDelegate {

/// Resize the placeholder when the UITextView bounds change
//    override open var bounds: CGRect {
//        didSet {
//            self.resizePlaceholder()
//        }
//    }

/// The UITextView placeholder text
//    public var placeholder: String? {
//        get {
//            var placeholderText: String?
//
//            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
//                placeholderText = placeholderLabel.text
//            }
//
//            return placeholderText
//        }
//        set {
//            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
//                placeholderLabel.text = newValue
//                placeholderLabel.sizeToFit()
//            } else {
//                self.addPlaceholder(newValue!)
//            }
//        }
//    }

/// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
///
/// - Parameter textView: The UITextView that got updated
//    public func textViewDidChange(_ textView: UITextView) {
//        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
//            placeholderLabel.isHidden = self.text.count > 0
//        }
//        inputViewDelegate?.textViewDidChange?(textView)
//    }

//    public func textViewDidEndEditing(_ textView: UITextView) {
//        inputViewDelegate?.textViewDidEndEditing?(textView)
//    }

//    public func textViewDidBeginEditing(_ textView: UITextView) {
//        inputViewDelegate?.textViewDidBeginEditing?(textView)
//    }


//}

