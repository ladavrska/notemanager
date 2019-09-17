//
//  BasePersonalNoteVC.swift
//  NoteManager
//
//  Created by Lada Vrska on 16/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

public enum DetailViewMode {
    case view
    case edit
    case create
    
    public func getTitle() -> String {
        switch self {
        case .view:
            return "Note Detail"
        case .edit:
            return "Edit Note"
        case .create:
            return "New Note"
        }
    }
}

open class BasePersonalNoteVC: BaseViewController, UITextViewDelegate  {
    
    var input: InputView?
    public var mode: DetailViewMode?
    var topOffset: CGFloat = 110
    
    public convenience init(mode: DetailViewMode? = nil) {
        self.init()
        self.mode = mode
    }
    
    override open func prepareView() {
        super.prepareView()
        self.view.backgroundColor = .white
        prepareNavigationBar()
        prepareInput()
    }
    
    // MARK: - InputView
    
    open func prepareInput() {
        let inputView = InputView(hasBorder: false)
        view.addSubview(inputView)
        inputView.inputViewDelegate = self
        inputView.hasBorder = false
        inputView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(self.topOffset)
            maker.left.equalToSuperview().offset(30)
            maker.bottom.equalToSuperview().offset(-20)
            maker.right.equalToSuperview().offset(-30)
        }
        input = inputView
    }
    
    // MARK: - UITextViewDelegate
    
    @objc open func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = input?.placeholderText ?? ""
            textView.textColor = .darkGray
        }
    }
}

