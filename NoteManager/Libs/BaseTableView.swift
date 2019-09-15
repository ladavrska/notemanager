//
//  BaseTableView.swift
//  NoteManager
//
//  Created by Lada Vrska on 15/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit

open class BaseTableView: UITableView, UITableViewDelegate  {
    
    let noDataLabel = UILabel()
    private var editingCell: UITableViewCell?
    open var tapActionsEnabled: Bool = true
    open var swipeActionsEnabled: Bool = true
    
    public init(frame: CGRect = CGRect.zero){
        super.init(frame: frame, style: .plain)
        self.delegate = self
        self.frame = frame
        prepareNoDataLabel()
        prepareView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func prepareView() {}
    
    override open func reloadData() {
        super.reloadData()
        
        let number = dataSource?.numberOfSections?(in: self) ?? 0
        showNoDataLabel(show: number == 0)
    }
        
    open func prepareNoDataLabel(){
        noDataLabel.text = "No data"
        noDataLabel.textAlignment = .center
        noDataLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        noDataLabel.textColor = UIColor.darkGray
        noDataLabel.alpha = 0.5
    }
    
    open func showNoDataLabel(show: Bool){
        if show{
            self.addSubview(noDataLabel)
        } else {
            noDataLabel.removeFromSuperview()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        noDataLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return swipeActionsEnabled
    }
    
    // hide swipe actions on table view scroll
//    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        editingCell?.setEditing(false, animated: true)
//        editingCell = nil
//    }
    
}
