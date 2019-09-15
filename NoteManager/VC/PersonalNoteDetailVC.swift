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
    case add
    
    // implement get title string
}

open class PersonalNoteDetailVC: BaseViewController, UITextViewDelegate  {
    
    var input: InputView?
    public var mode: DetailViewMode?
    var topOffset: CGFloat = 90
    
    public required init(mode: DetailViewMode? = nil) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            maker.top.equalToSuperview().offset(topOffset)
            maker.left.equalToSuperview().offset(20)
            maker.bottom.equalToSuperview().offset(-20)
            maker.right.equalToSuperview().offset(-20)
        }
        //inputView.returnKeyType = .done
        input = inputView
    }
    
    // MARK: - NavigationBar
    
    open override func prepareNavigationBarContent() {
        navigationItem.title = "Note Detail"
        
        let rightBarButtonItem = UIBarButtonItem(title:"Edit",
                                                 style:.plain,
                                                 target:self,
                                                 action:#selector(editTapped))
        
        navigationItem.setRightBarButtonItems([rightBarButtonItem], animated: false)
        
        if let navigationBarHeight = self.navigationController?.navigationBar.frame.height {
            topOffset = navigationBarHeight
        }
    }
    
    @objc open func editTapped() {
        print("edit Tapped")
        
        input?.isUserInteractionEnabled = true
        input?.textColor = .black
        mode = .edit
        input?.becomeFirstResponder()
        // show keyboard
        
        let saveRightBarButtonItem = UIBarButtonItem(title:"Save",
                                                     style:.plain,
                                                     target:self,
                                                     action:#selector(saveTapped))
        
        navigationItem.setRightBarButtonItems([saveRightBarButtonItem], animated: false)
    }
    
    @objc open func saveTapped() {
        print("save Tapped")
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Api request
    
    open override func getApiData() {
        print("getApiData")
        super.getApiData()
        
        guard let noteId = entityId else {
            return
        }
        
        let url = "\(baseUrl)/notes/\(noteId)"
        print("detailUrl: \(url)")
        Alamofire.request(url)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    //completion(nil)
                    return
                }
                
                guard let noteData = response.result.value as? [String: Any] else {
                    print("Malformed data received")
                    //completion(nil)
                    return
                }
                self.data = noteData
                print("data: \(noteData)")
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
        case .edit, .add:
            textView.textColor = .black
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
