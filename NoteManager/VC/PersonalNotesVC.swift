//
//  PersonalNotesVC.swift
//  NoteManager
//
//  Created by Lada Vrska on 15/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

open class PersonalNotesVC: BaseViewController, UITableViewDelegate {
    public var tableView = BaseTableView()
    public var dataSource = TVDataSource()
    var topOffset: CGFloat = 90
    
    public var data: [PersonalNote]? {
        didSet {
            guard data != nil else {
                return
            }
            updateView()
        }
    }
    
    override open func prepareView() {
        super.prepareView()
        prepareNavigationBar()
        prepareTableView()
        setBinding()
    }
    
    override open func updateView(){
        super.updateView()
        guard let noteData = data else  {
            return
        }
        processResponse(noteData)
        tableView.reloadData()
    }
    
    func setBinding() {
        _ = dataSource.deletedNoteId.observeNext { noteId in
            guard let id = noteId else {
                return
            }
            self.deleteNote(id)
        }
    }
    
    func prepareTableView() {
        
        tableView = BaseTableView()
        tableView.rowHeight = 60.0
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{ maker in
            maker.top.equalToSuperview().offset(topOffset)
            maker.bottom.leading.trailing.equalToSuperview()
        }
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.swipeActionsEnabled = true
        
        registerCell()
    }
    
    func registerCell() {
        let cellClass = PersonalNoteTableViewCell.self
        let classIdentifier = String(describing: PersonalNoteTableViewCell.self)
        tableView.register(cellClass, forCellReuseIdentifier: classIdentifier)
        dataSource.reuseIdentifier = classIdentifier
    }
    
    open override func getApiData() {
        super.getApiData()
        guard let url = baseUrl else { return }
        
        Alamofire.request("\(url)/notes")
            .validate()
            .responseData { response in
                let decoder = JSONDecoder()
                let result: Result<[PersonalNote]> = decoder.decodeResponse(from: response)
                switch result {
                case .success:
                    self.data = result.value
                case .failure:
                    print(result.error ?? "Error parsing data")
                }
            }
    }
    
    open func deleteNote(_ id: Int) {
        guard let url = baseUrl  else { return }
        
        Alamofire.request("\(url)/notes/\(id)", method: .delete)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching data: \(String(describing: response.result.error))")
                    return
                }
                guard let successData = response.result.value as? [String: Any] else {
                    print("Malformed data received")
                    return
                }
                print("Note DELETE success data: \(successData)")
            }
    }
    
    open func processResponse(_ data: [PersonalNote] ) {
        dataSource.clear()
        if !data.isEmpty {
            dataSource.setData(data: data)
        }
    }
    
    // MARK: - NavigationBar
    
    open override func prepareNavigationBarContent() {
        navigationItem.title = "My Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(didTapCreateNote), imageName: "icon-plus")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if let navigationBarHeight = self.navigationController?.navigationBar.frame.height {
            topOffset = navigationBarHeight
        }
    }
    
    // MARK: UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = dataSource.getData(indexPath) as? PersonalNote else {return}
        self.goToDetail(id: data.id)
    }
    
    open func goToDetail(id: Int) {
        let detailVC = PersonalNoteEditVC(mode: .view)
        detailVC.entityId = id
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc open func didTapCreateNote() {
        let createVC = PersonalNoteCreateVC(mode: .create)
        let createNC = UINavigationController(rootViewController: createVC)
        present(createNC, animated: true)

    }
}

