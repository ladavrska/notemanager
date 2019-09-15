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
        print("[PersonalNotesVC] prepareView")
        prepareNavigationBar()
        prepareTableView()
    }
    
    override open func updateView(){
        super.updateView()
        guard let unwrapppedData = data else  {
            return
        }
        processResponse(unwrapppedData)
        tableView.reloadData()
    }
    
    func prepareTableView() {
        
        tableView = BaseTableView()
        tableView.rowHeight = 80.0
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{ maker in
            //maker.top.equalTo(topBarView!.snp.bottom)
            //            maker.top.equalToSuperview().offset(90)    // !!!!
            //maker.top.equalTo(self.navigationController?.navigationBar.snp.bottom ?? 90)
            maker.top.equalToSuperview().offset(topOffset)
            maker.bottom.leading.trailing.equalToSuperview()
        }
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.swipeActionsEnabled = true
        
        var cellClass: BaseTableViewCell.Type!
        cellClass = PersonalNoteTableViewCell.self
        let classIdentifier = String(describing: cellClass)
        tableView.register(cellClass, forCellReuseIdentifier: classIdentifier)
        dataSource.reuseIdentifier = classIdentifier
    }
    
    func registerCell() {
        let cellClass = PersonalNoteTableViewCell.self
        let classIdentifier = String(describing: PersonalNoteTableViewCell.self)
        tableView.register(cellClass, forCellReuseIdentifier: classIdentifier)
        dataSource.reuseIdentifier = classIdentifier
    }
    
    open override func getApiData() {
        print("getApiData")
        super.getApiData()
        
        let url = "\(baseUrl)/notes"
        
        Alamofire.request(url)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    //completion(nil)
                    return
                }
                
                guard let notesData = response.result.value as? [[String: Any]] else {
                    print("Malformed data received")
                    //completion(nil)
                    return
                }
                self.data = notesData
                print("data: \(notesData)")
        }
    }
    
    open func processResponse(_ data: [[String:Any]] ) {
        
        print("processResponse")
        dataSource.clear()
        let notes = data.compactMap { note in
            return PersonalNote(id: note["id"] as? Int ?? 0, title: note["title"] as? String ?? "N/A")
        }
        print("transformed data for DataSource: \(notes)")
        if !notes.isEmpty {
            dataSource.setData(data: notes)
        }
    }
    
    // MARK: - NavigationBar
    
    open override func prepareNavigationBarContent() {
        navigationItem.title = "Notes list"
        
        let rightBarButtonItem = UIBarButtonItem(title:"Create",
                                                 style:.plain,
                                                 target:self,
                                                 action:#selector(didTapCreateNote))
        
        navigationItem.setRightBarButtonItems([rightBarButtonItem], animated: false)
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
        let detailVC = PersonalNoteDetailVC(mode: .view)
        detailVC.entityId = id
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc open func didTapCreateNote() {
        print("didTapCreateNote")
        let createVC = PersonalNoteDetailVC(mode: .add)
        //navigationController?.pushViewController(detailVC, animated: true)
        
        let createNC = UINavigationController(rootViewController: createVC)
        
        present(createNC, animated: true)
        
        // preseent modally instead !!!
    }
    
    
}

