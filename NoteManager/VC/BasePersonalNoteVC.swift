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

public class BasePersonalNoteVC: BaseViewController, UITextViewDelegate  {
    
    var input: InputView?
    var mode: DetailViewMode?
    var topOffset: CGFloat = 110
    var viewModel = PersonalNoteViewModel(note: PersonalNote())
    
    public convenience init(mode: DetailViewMode? = nil) {
        self.init()
        self.mode = mode
    }
    
    override public func prepareView() {
        super.prepareView()
        self.view.backgroundColor = .white
        prepareNavigationBar()
        prepareInput()
    }
    
    // MARK: - InputView
    
    func prepareInput() {
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
}

