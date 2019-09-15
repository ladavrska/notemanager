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
    public var defaultSectionVisibility = true
    
    //open var data: [[Any]] = [] {
    open var data: [Any] = [] {
        didSet {
            isSectionVisible = Array<Bool>(repeating: defaultSectionVisibility, count: data.count)
        }
    }
    
    public override init() {
        super.init()
    }
    
    public var isSectionVisible: [Bool]!
    
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    //
    //    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    //        guard let sourceData = getData(sourceIndexPath) else { return }
    //        removeItem(indexPath: sourceIndexPath)
    //        insertItem(indexPath: destinationIndexPath, data: sourceData)
    //    }
    
    /// Override this method for creating custom cell and set up data to cell
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let reuseId = reuseIdentifier {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! BaseTableViewCell
            cell.data = getData(indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    
    //    open func clear(section: Int? = nil) {
    //        if let sect = section{
    //            if data.indices.contains(sect){
    //                self.data[sect] = []
    //            }
    //        }else{
    //            self.data = []
    //        }
    //    }
    
    open func clear() {
        self.data = []
    }
    
    //    open func appendData(section: Int = 0, data: Any){
    //        if !self.data.indices.contains(section){
    //            self.data.insert([], at: section)
    //        }
    //        self.data[section].append(data)
    //    }
    //
    //    open func addData(row: Int, section: Int = 0, data: Any){
    //        if !self.data.indices.contains(section){
    //            self.data.insert([], at: section)
    //        }
    //        self.data[section].insert(data, at: row)
    //    }
    
    //    open func setData(section: Int = 0, data: [Any]){
    //        if !self.data.indices.contains(section){
    //            self.data.insert(data, at: section)
    //        }else{
    //            self.data[section] = data
    //        }
    //    }
    
    open func setData(data: [Any]){
        //        self.data.insert(data, at: 0)
        
        self.data = data
    }
    
    
    
    open func getData(_ indexPath: IndexPath) -> Any?{
        //        guard case 0..<data.count = indexPath.section, case 0..<(data.count = indexPath.row else{
        //            return nil
        //        }
        
        return data[indexPath.row]
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            print("delete")
            // handle delete (by removing the data from your array and updating the tableview)
            
            //            tableView.beginUpdates()
            //            Names.removeAtIndex(indexPath!.row)
            //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: nil)
            //            tableView.endUpdates()
        }
    }
    
    
    
    //    open func getDataArray(_ section: Int = 0) -> [Any]?{
    //        if self.data.indices.contains(section){
    //            return data[section]
    //        }
    //        return nil
    //    }
    
    //    open func updateItem(indexPath: IndexPath, data: Any){
    //        guard case 0..<self.data.count = indexPath.section, case 0..<self.data[indexPath.section].count = indexPath.row else{
    //            return
    //        }
    //
    //        self.data[indexPath.section][indexPath.row] = data
    //    }
    //
    //    open func removeItem(indexPath: IndexPath){
    //        guard case 0..<self.data.count = indexPath.section, case 0..<self.data[indexPath.section].count = indexPath.row else{
    //            return
    //        }
    //
    //        self.data[indexPath.section].remove(at: indexPath.row)
    //    }
    
    // There is +1 because you can insert item. For example to index 4 if you have 0..3
    //    open func insertItem(indexPath: IndexPath, data: Any){
    //        guard case 0..<self.data.count = indexPath.section, case 0..<self.data[indexPath.section].count+1 = indexPath.row else{
    //            return
    //        }
    //        self.data[indexPath.section].insert(data, at: indexPath.row)
    //    }
    
    
    //    open func getDataCount(section: Int = 0) -> Int{
    //        return getDataArray(section)?.count ?? 0
    //    }
    
}
