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

open class PersonalNoteCreateVC: BasePersonalNoteVC, CanPrepareButton {
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input?.becomeFirstResponder()
    }
    
    // MARK: - NavigationBar
    
    open override func prepareNavigationBarContent() {
        navigationItem.title = "New Note"
        navigationItem.setRightBarButtonItems([prepareCreateButton()], animated: false)
        navigationItem.setLeftBarButtonItems([prepareDiscardButton()], animated: false)
        if let navigationBarHeight = self.navigationController?.navigationBar.frame.height {
            topOffset = navigationBarHeight + 60
        }
    }

    func prepareDiscardButton() -> UIBarButtonItem {
        let button = prepareIconButton(icon: "ico-close-circle", size: 60)
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }

    func prepareCreateButton() -> UIBarButtonItem {
        let button = prepareIconButton(icon: "ico-checkmark-2", size: 65)
        button.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
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
        let parameters: [String: String] = ["title": input?.text ?? "N/A" as String]

        Alamofire.request("\(url)/notes", method: .post, parameters: parameters)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching data: \(String(describing: response.result.error))")
                    return
                }
                self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - UITextViewDelegate
    
        @objc open func textViewDidBeginEditing(_ textView: UITextView) {
            textView.textColor = .black
            if textView.text == input?.placeholderText {
                textView.text = ""
            }
        }
}
