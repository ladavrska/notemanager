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
    var viewModel = PersonalNoteViewModel(note: PersonalNote())
    let successLabel = ToastLabel()
    
    public convenience init(mode: DetailViewMode? = nil) {
        self.init()
        self.mode = mode
    }
    
    override open func prepareView() {
        super.prepareView()
        self.view.backgroundColor = .white
        prepareNavigationBar()
        prepareInput()
        prepareSuccessLabel()
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
    
    // MARK: - successLabel
    
    open func prepareSuccessLabel() {
        self.view.addSubview(successLabel)
        successLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().offset(-100)
            maker.width.equalTo(150)
            maker.height.equalTo(40)
            maker.centerX.equalToSuperview()
        }
    }
    
    func showSucces(text: String) {
        self.input?.resignFirstResponder()
        self.successLabel.text = text
        UIView.animate(withDuration: 1.3, delay: 0.8, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.successLabel.alpha = 1
            self.view.layoutIfNeeded()
            
        }, completion: { finished in
            if self.mode == .create {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func showError() {
        // TODO: implement
        if self.mode == .create {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

