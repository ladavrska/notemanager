//
//  TVDataSource.swift
//  NoteManager
//
//  Created by Lada Vrska on 15/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit
import Foundation
import Bond

public class TVDataSource: NSObject, UITableViewDataSource{
    
    public var reuseIdentifier: String?
    public var data: [Any] = []
    public var deletedNoteId = Observable<Int?>(nil)
    
    public override init() {
        super.init()
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let reuseId = reuseIdentifier {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! BaseTableViewCell
            cell.data = getData(indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deletedNoteId.value = (data[indexPath.row] as! PersonalNote).id
            data.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    public func clear() {
        self.data = []
    }
    
    public func setData(data: [Any]){
        self.data = data
    }
    
    public func getData(_ indexPath: IndexPath) -> Any? {
        return data[indexPath.row]
    }
    
    public func getDataCount() -> Int{
        return data.count
    }
}
