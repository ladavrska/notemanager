//
//  PersonalNoteDetailVC.swift
//  NoteManager
//
//  Created by Lada Vrska on 15/09/2019.
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
            return "Add Note"
        }
    }
}

open class PersonalNoteDetailVC: BaseViewController, UITextViewDelegate  {
    
    var input: InputView?
    public var mode: DetailViewMode?
    var topOffset: CGFloat = 150
    
    public required init(mode: DetailViewMode? = nil) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if mode == .create {
            input?.becomeFirstResponder()
        }
    }
    
    public var data: [String:Any]? {
        didSet {
            guard data != nil else {
                return
            }
            updateView()
        }
    }
    
    override open func prepareView() {
        super.prepareView()
        self.view.backgroundColor = .white
        prepareNavigationBar()
        prepareInput()
    }
    
    override open func updateView(){
        super.updateView()
        guard let unwrapppedData = data else  {
            return
        }
        processResponse(unwrapppedData)
    }
    
    // MARK: - InputView
    
    open func prepareInput() {
        let inputView = InputView(hasBorder: false)
        view.addSubview(inputView)
        inputView.inputViewDelegate = self
        inputView.hasBorder = false
        inputView.isUserInteractionEnabled = mode == .view ? false : true
        inputView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(self.topOffset)
            maker.left.equalToSuperview().offset(30)
            maker.bottom.equalToSuperview().offset(-20)
            maker.right.equalToSuperview().offset(-30)
        }
        input = inputView
    }
    
    // MARK: - NavigationBar
    
    open override func prepareNavigationBarContent() {
        
        navigationItem.title = self.mode?.getTitle() ?? ""
        
        var rightBarButtonItems: [UIBarButtonItem] = []
        var leftBarButtonItems: [UIBarButtonItem] = []
        if let viewMode = mode {
            switch viewMode {
            case .view:
                let rightBarButtonItem = UIBarButtonItem(title:"Edit", style:.plain, target:self, action:#selector(editTapped))
                rightBarButtonItems.append(rightBarButtonItem)
            case .create:
                let rightBarButtonItem = UIBarButtonItem(title:"Save", style:.plain, target:self, action:#selector(createTapped))
                rightBarButtonItems.append(rightBarButtonItem)
                let leftBarButtonItem = UIBarButtonItem(title:"Close", style:.plain, target:self, action:#selector(closeTapped))
                leftBarButtonItems.append(leftBarButtonItem)
            default: break
            }
        }
        if !rightBarButtonItems.isEmpty {
            navigationItem.setRightBarButtonItems(rightBarButtonItems, animated: false)
        }
        if !leftBarButtonItems.isEmpty {
            navigationItem.setLeftBarButtonItems(leftBarButtonItems, animated: false)
        }
        
        if let navigationBarHeight = self.navigationController?.navigationBar.frame.height {
            topOffset = navigationBarHeight + 60
        }
    }
    
    @objc open func editTapped() {
        print("edit Tapped")
        
        input?.isUserInteractionEnabled = true
        input?.textColor = .black
        mode = .edit
        input?.becomeFirstResponder()
        
        let saveRightBarButtonItem = UIBarButtonItem(title:"Save",
                                                     style:.plain,
                                                     target:self,
                                                     action:#selector(saveTapped))
        
        navigationItem.setRightBarButtonItems([saveRightBarButtonItem], animated: false)
    }
    
    @objc open func saveTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc open func closeTapped() {
        guard let newNoteText = input?.text, !newNoteText.isEmpty else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        showNewNoteDiscardAlert()
    }
    
    open func showNewNoteDiscardAlert() {
        let alertController = UIAlertController(title: "Discard note?", message: "Operation cannot be undone!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc open func createTapped() {
        postNewNote()
    }
    
    // MARK: - Api request
    
    open override func getApiData() {
        
        guard let url = baseUrl, let noteId = entityId else {
            return
        }
        
        super.getApiData()
        
        Alamofire.request("\(url)/notes/\(noteId)")
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching data: \(String(describing: response.result.error))")
                    return
                }
                
                guard let noteData = response.result.value as? [String: Any] else {
                    print("Malformed data received")
                    return
                }
                self.data = noteData
                print("data: \(noteData)")
        }
    }
    
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
    
    open func processResponse(_ data: [String:Any] ) {
        let note = PersonalNote(id: data["id"] as? Int ?? 0, title: data["title"] as? String ?? "N/A")
        input?.text = note.title
    }
    
    // MARK: - UITextViewDelegate
    
    @objc open func textViewDidChange(_ textView: UITextView) {}
    
    @objc open func textViewDidBeginEditing(_ textView: UITextView) {
        guard let editMode = self.mode else {
            return
        }
        switch editMode {
        case .edit:
            textView.textColor = .black
        case .create:
            textView.textColor = .black
            if textView.text == input?.placeholderText {
                textView.text = ""
            }
        default:
            textView.text = nil
        }
    }
    
    @objc open func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = input?.placeholderText ?? ""
            textView.textColor = .darkGray
        }
    }
    
}
