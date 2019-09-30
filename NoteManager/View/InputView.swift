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
    public var borderWidth = CGFloat(8.0)
    public var hasBorder: Bool = false
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
    }
    
    public convenience init(hasBorder: Bool) {
        self.init()
        self.hasBorder = hasBorder
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func configure() {
        self.font = .systemFont(ofSize: 18)
        self.textAlignment = .left
        self.backgroundColor = .white
        if hasBorder {
            prepareBorder()
        }
    }
    
    func prepareBorder() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.8
        self.layer.cornerRadius = 4.0
        self.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        self.layer.masksToBounds = true
    }
}

extension InputView: UITextViewDelegate {
    
    @objc public func textViewDidChange(_ textView: UITextView) {
        inputViewDelegate?.textViewDidChange?(textView)
    }
    
    @objc public func textViewDidBeginEditing(_ textView: UITextView) {
        inputViewDelegate?.textViewDidBeginEditing?(textView)
    }
}

