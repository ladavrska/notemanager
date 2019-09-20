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
            viewModel?.applyMode(inputMode, to: inputView)
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        setBinding()
    }

    func setBinding() {
        _ = input?.reactive.text.observeNext { text in
            self.viewModel?.personalNote.title = text ?? ""
            self.navigationItem.rightBarButtonItem?.isEnabled = !(text?.isEmpty ?? true)
        }.dispose(in: bag)
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
        guard let url = baseUrl else { return }
        let parameters = ["title": viewModel?.personalNote.title ?? ""]
        Alamofire.request("\(url)/notes", method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching data: \(String(describing: response.result.error))")
                    return
                }
                self.showSucces()
            }
    }
}
