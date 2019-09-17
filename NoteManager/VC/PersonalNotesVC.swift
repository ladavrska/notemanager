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
    
    public var data: [[String:Any]]? {
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
        guard let unwrapppedData = data else  {
            return
        }
        processResponse(unwrapppedData)
        tableView.reloadData()
    }
    
    func setBinding() {
        _ = dataSource.deletedNoteId.observeNext { noteId in
            guard let id = noteId else {
                return
            }
            print("ObserveNext Id of deleted: \(id)")
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
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching data: \(String(describing: response.result.error))")
                    return
                }
                
                guard let notesData = response.result.value as? [[String: Any]] else {
                    print("Malformed data received")
                    return
                }
                self.data = notesData
                print("data: \(notesData)")
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
    
    open func processResponse(_ data: [[String:Any]] ) {
        dataSource.clear()
        let notes = data.compactMap { note in
            return PersonalNote(id: note["id"] as? Int ?? 0, title: note["title"] as? String ?? "N/A")
        }
        if !notes.isEmpty {
            dataSource.setData(data: notes)
        }
    }
    
    // MARK: - NavigationBar
    
    open override func prepareNavigationBarContent() {
        navigationItem.title = "My Notes"
        navigationItem.setRightBarButtonItems([prepareAddButton()], animated: false)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if let navigationBarHeight = self.navigationController?.navigationBar.frame.height {
            topOffset = navigationBarHeight
        }
    }
    
    func prepareAddButton() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ico-add-circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCreateNote), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        return UIBarButtonItem(customView: button)
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
        let createVC = PersonalNoteCreateVC()
        let createNC = UINavigationController(rootViewController: createVC)
        present(createNC, animated: true)

    }
    
    
}

