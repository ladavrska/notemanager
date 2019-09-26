//
//  PersonalNoteEditVC.swift
//  NoteManager
//
//  Created by Lada Vrska on 16/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import Bond

open class PersonalNoteEditVC: BasePersonalNoteVC  {
    
    private var originalNote: String?
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.request?.cancel()
    }
    
    override open func prepareView() {
        super.prepareView()
        if let inputMode = mode, let inputView = input {
            viewModel.applyMode(inputMode, to: inputView)
        }
        bindViewModel()
    }
    
    func bindViewModel() {
        _ = input?.reactive.text.observeNext { [weak self] text in
            guard let self = self else { return }
            self.viewModel.personalNote.value.title = text ?? ""
            if let origNote = self.originalNote  {
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItem?.isEnabled = text != origNote ? true : false
                }
            }
        }.dispose(in: bag)
        
        _ = viewModel.isLoading.observeNext{ [weak self] isLoading in
            guard let self = self, let loading = isLoading else {return}
            DispatchQueue.main.async {
                if loading{
                    self.showActivityIndicator()
                }else{
                    self.hideActivityIndicator()
                }
            }
        }.dispose(in: bag)
        
        _ = viewModel.personalNote.observeNext{ [weak self] note in
            guard let self = self else { return }
            if let inputView = self.input {
                self.viewModel.updateNote(inputView)
            }
        }.dispose(in: bag)
        
        _ = viewModel.noteUpdated.observeNext{ [weak self] noteUpdated in
            guard let self = self, let updated = noteUpdated else { return }
            if updated {
                DispatchQueue.main.async {
                    self.input?.resignFirstResponder()
                    let alertLabel = AlertLabel(presenter: self, type: .success, message: "Note updated")
                    alertLabel.onAlertShowCompleted = { () in
                        self.navigationController?.popViewController(animated: true)
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
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertLabel.show()
                }
            }
        }
    }
    
    // MARK: - InputView
    
    open override func prepareInput() {
        super.prepareInput()
        input?.isUserInteractionEnabled = mode == .view ? false : true
    }
    
    // MARK: - NavigationBar
    
    open override func prepareNavigationBarContent() {
        navigationItem.title = self.mode?.getTitle() ?? ""
        if let viewMode = mode {
            switch viewMode {
            case .view:
                navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(editTapped), imageName: "icon-pen")
            default: break
            }
        }
        if let navigationBarHeight = self.navigationController?.navigationBar.frame.height {
            topOffset = navigationBarHeight + 60
        }
    }

    @objc open func editTapped() {
        input?.isUserInteractionEnabled = true
        input?.textColor = .black
        mode = .edit
        input?.becomeFirstResponder()
        navigationItem.title = self.mode?.getTitle() ?? ""
        navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(saveTapped), imageName: "ico-checkmark")
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(closeTapped), imageName: "ico-close")
    }

    @objc open func saveTapped() {
        putNote()
    }

    @objc open func closeTapped() {
        if mode == .edit {
            if let enabled = navigationItem.rightBarButtonItem?.isEnabled, !enabled {
                self.navigationController?.popViewController(animated: true)
            } else {
                showNoteDiscardAlert()
            }
        }
    }

    open func showNoteDiscardAlert() {
        let alertController = UIAlertController(title: "Discard changes?", message: "Operation cannot be undone!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Api request
    
    open override func getApiData() {
        guard let noteId = entityId else { return }
        viewModel.getApiData(id: noteId)
    }
    
    open func putNote() {
        viewModel.putNote()
    }
    
    // MARK: - UITextViewDelegate

    @objc open func textViewDidBeginEditing(_ textView: UITextView) {
        originalNote = viewModel.title
    }
}
