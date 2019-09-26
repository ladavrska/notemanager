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
    var viewModel = PersonalNotesViewModel()
    private let refreshControl = UIRefreshControl()
    
    override open func prepareView() {
        super.prepareView()
        prepareNavigationBar()
        prepareTableView()
        refreshControl.addTarget(self, action: #selector(refresData(_:)), for: .valueChanged)
        bind()
    }
    
    func bind(){
        _ = dataSource.deletedNoteId.observeNext { [weak self] noteId in
            guard let self = self, let id = noteId else {
                return
            }
            self.deleteNote(id)
        }.dispose(in: bag)
        
        _ = viewModel.isLoading.observeNext{ [weak self] isLoading in
            guard let self = self, let loading = isLoading else {return}
            if loading{
                DispatchQueue.main.async {
                    if !self.refreshControl.isRefreshing {
                        self.showActivityIndicator()
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.refreshControl.endRefreshing()
                }
            }
        }.dispose(in: bag)
        
        _ = viewModel.personalNoteData.observeNext{ [weak self] notes in
            guard let self = self else {return}
            if let personalNotes = notes {
                self.processResponse(personalNotes)
                self.tableView.reloadData()
            }
        }.dispose(in: bag)
        
        _ = viewModel.error.observeNext{ [weak self] value in
            guard let self = self, let error = value else {return}
            if let msg = error.message {
                DispatchQueue.main.async {
                    let alertLabel = AlertLabel(presenter: self, type: .error, message: msg)
                    alertLabel.show()
                }
            }
        }
        
        _ = viewModel.noteDeleted.observeNext{ noteDeleted in
            guard let deleted = noteDeleted  else {return}
            if deleted {
                print("Note deleted")
            } else {
                print("Error while deleting note")
            }
            // reloadData()
        }.dispose(in: bag)
    }
    
    // MARK: - TableView
    
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
        tableView.refreshControl = refreshControl
        registerCell()
    }
    
    func registerCell() {
        let cellClass = PersonalNoteTableViewCell.self
        let classIdentifier = String(describing: PersonalNoteTableViewCell.self)
        tableView.register(cellClass, forCellReuseIdentifier: classIdentifier)
        dataSource.reuseIdentifier = classIdentifier
    }

    // MARK: - Api request
    
    open override func getApiData() {
        viewModel.getApiData()
    }
    
    open func deleteNote(_ id: Int) {
        viewModel.deleteNote(id)
    }
    
    open func processResponse(_ data: [PersonalNote] ) {
        dataSource.clear()
        if !data.isEmpty {
            dataSource.setData(data: data)
        }
    }
    
    @objc private func refresData(_ sender: Any) {
        reloadData()
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
    
    // MARK: - UITableViewDelegate
    
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
