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


open class PersonalNoteEditVC: BasePersonalNoteVC  {
    
    private var originalNote: String?
    public var data: PersonalNote? {
        didSet {
            guard let noteData = data else {
                return
            }
            viewModel = PersonalNoteViewModel(note: noteData)
            updateView()
        }
    }
    
    override open func updateView(){
        super.updateView()
        guard let inputView = input else {
            return
        }
        viewModel?.updateNote(inputView)
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
        guard let url = baseUrl, let noteId = entityId else { return }
        super.getApiData()
        Alamofire.request("\(url)/notes/\(noteId)")
            .validate()
            .responseData { response in
                let decoder = JSONDecoder()
                let result: Result<PersonalNote> = decoder.decodeResponse(from: response)
                switch result {
                case .success:
                    self.data = result.value
                case .failure:
                    print(result.error ?? "Error parsing data")
                }
        }
    }
    
    open func putNote() {
        guard let url = baseUrl, let id = viewModel?.id else { return }
        Alamofire.request("\(url)/notes/\(id)", method: .put, parameters: getParameters())
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching data: \(String(describing: response.result.error))")
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }
    }
    
    func getParameters() -> [String:Any] {
        var dict: [String:Any] = [:]
        do {
            let dataAsDictionary = try self.viewModel?.personalNote.asDictionary()
            dict = dataAsDictionary ?? [:]
        } catch {
             print(error)
        }
        return dict
    }
    
    // MARK: - UITextViewDelegate
    
    @objc open func textViewDidChange(_ textView: UITextView) {
        guard let note = textView.text, let origNote = originalNote else {
            return
        }
        navigationItem.rightBarButtonItem?.isEnabled = note != origNote ? true : false
        viewModel?.personalNote.title = note
    }

    @objc open func textViewDidBeginEditing(_ textView: UITextView) {
        originalNote = viewModel?.title
        if let inputMode = mode, let inputView = input {
            viewModel?.applyMode(inputMode, to: inputView)
        }
    }
}
