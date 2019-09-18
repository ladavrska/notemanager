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


open class PersonalNoteEditVC: BasePersonalNoteVC, CanPrepareButton  {
    
    private var originalNote: String!
    public var data: PersonalNote? {
        didSet {
            guard data != nil else {
                return
            }
            updateView()
        }
    }
    
    override open func updateView(){
        super.updateView()
        input?.text = data?.title
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
                navigationItem.setRightBarButtonItems([prepareEditButton()], animated: false)
            default: break
            }
        }
        if let navigationBarHeight = self.navigationController?.navigationBar.frame.height {
            topOffset = navigationBarHeight + 60
        }
    }

    func prepareEditButton() -> UIBarButtonItem {
        let button = prepareIconButton(icon: "ico-compose", size: 65)
        button.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }

    func prepareSaveButton() -> UIBarButtonItem {
        let button = prepareIconButton(icon: "ico-checkmark-2", size: 65)
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }

    func prepareDiscardButton() -> UIBarButtonItem {
        let button = prepareIconButton(icon: "ico-close-circle", size: 60)
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }

    @objc open func editTapped() {
        input?.isUserInteractionEnabled = true
        input?.textColor = .black
        mode = .edit
        input?.becomeFirstResponder()
        navigationItem.title = self.mode?.getTitle() ?? ""
        navigationItem.setRightBarButtonItems([prepareSaveButton()], animated: false)
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.setLeftBarButtonItems([prepareDiscardButton()], animated: false)
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
        guard let url = baseUrl, let noteId = entityId else { return }
        Alamofire.request("\(url)/notes/\(noteId)", method: .put, parameters: getParameters(id: noteId))
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching data: \(String(describing: response.result.error))")
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }
    }
    
    func getParameters(id: Int) -> [String:AnyObject] {
        return [
            "id": id as AnyObject,
            "title": (data?.title ?? "N/A") as AnyObject
        ]
    }
    
    // MARK: - UITextViewDelegate
    
    @objc open func textViewDidChange(_ textView: UITextView) {
        guard let note = textView.text else {
            return
        }
        navigationItem.rightBarButtonItem?.isEnabled = note != originalNote ? true : false
        data?.title = note
    }

    @objc open func textViewDidBeginEditing(_ textView: UITextView) {
        guard let editMode = self.mode else {
            return
        }
        originalNote = data?.title
        switch editMode {
        case .edit:
            textView.textColor = .black
        default:
            textView.text = nil
        }
    }
}
