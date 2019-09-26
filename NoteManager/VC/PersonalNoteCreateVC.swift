//
//  PersonalNoteCreateVC.swift
//  NoteManager
//
//  Created by Lada Vrska on 16/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

open class PersonalNoteCreateVC: BasePersonalNoteVC {
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input?.becomeFirstResponder()
    }
        
    override open func prepareView() {
        super.prepareView()
        viewModel = PersonalNoteViewModel(note: PersonalNote())
        if let inputMode = mode, let inputView = input {
            viewModel.applyMode(inputMode, to: inputView)
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        setBinding()
    }

    func setBinding() {
        _ = input?.reactive.text.observeNext { [weak self] text in
            guard let self = self else {return}
            self.viewModel.personalNote.value.title = text ?? ""
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.isEnabled = !(text?.isEmpty ?? true)
            }
        }.dispose(in: bag)
        
        _ = viewModel.isLoading.observeNext{ [weak self] isLoading in
            guard let self = self, let loading = isLoading else {return}
            DispatchQueue.main.async {
                if loading{
                    self.showActivityIndicator()
                } else {
                    self.hideActivityIndicator()
                }
            }
        }.dispose(in: bag)
        
        _ = viewModel.newNotePosted.observeNext{ [weak self] notePosted in
            guard let self = self, let posted = notePosted else { return }
            if posted {
                DispatchQueue.main.async {
                    self.input?.resignFirstResponder()
                    let alertLabel = AlertLabel(presenter: self, type: .success, message: "Note saved")
                    alertLabel.onAlertShowCompleted = { () in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertLabel.show()
                }
            }
        }.dispose(in: bag)
        
        _ = viewModel.error.observeNext{ [weak self] value in
            guard let self = self, let error = value else {return}
            if let msg = error.message {
                DispatchQueue.main.async {
                    self.input?.resignFirstResponder()
                    let alertLabel = AlertLabel(presenter: self, type: .error, message: msg)
                    alertLabel.onAlertShowCompleted = { () in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertLabel.show()
                }
            }
        }
    }
    
    // MARK: - NavigationBar
    
    open override func prepareNavigationBarContent() {
        navigationItem.title = "New Note"
        navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(createTapped), imageName: "ico-checkmark")
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(closeTapped), imageName: "ico-close")
        if let navigationBarHeight = self.navigationController?.navigationBar.frame.height {
            topOffset = navigationBarHeight + 60
        }
    }

    @objc open func closeTapped() {
        guard let newNoteText = input?.text, !newNoteText.isEmpty else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        showNoteDiscardAlert()
    }

    @objc open func createTapped() {
        postNewNote()
    }
    
    open func showNoteDiscardAlert() {
        let alertController = UIAlertController(title: "Discard changes?", message: "Operation cannot be undone!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
                self.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Api request
    
    open override func getApiData() {}
    
    open func postNewNote() {
        viewModel.postNewNote()
    }
}
