//
//  TVDataSource.swift
//  NoteManager
//
//  Created by Lada Vrska on 15/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit
import Foundation

open class TVDataSource: NSObject, UITableViewDataSource{
    
    public var reuseIdentifier: String?
    open var data: [Any] = []
    
    public override init() {
        super.init()
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let reuseId = reuseIdentifier {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! BaseTableViewCell
            cell.data = getData(indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            data.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    open func clear() {
        self.data = []
    }
    
    open func setData(data: [Any]){
        self.data = data
    }
    
    open func getData(_ indexPath: IndexPath) -> Any? {
        return data[indexPath.row]
    }
    
    open func getDataCount() -> Int{
        return data.count
    }
}
