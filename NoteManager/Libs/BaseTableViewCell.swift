//
//  BaseTableViewCell.swift
//  NoteManager
//
//  Created by Lada Vrska on 15/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit

open class BaseTableViewCell: UITableViewCell {
    
    public let horizontalSeparatorView = UIView()
    public var separatorColor: UIColor? {
        didSet {
            if separatorColor != nil {
                addSeparatorView()
            }
        }
    }
    
    open var cellSeparatorHeight: CGFloat {
        return 0.5
    }
    
    
    //private var panRecognizer: UIPanGestureRecognizer!
    
    open var data: Any? {
        didSet {
            if data != nil{
                updateView()
            }
        }
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        prepareView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func prepareView() {
        fatalError("\(#function) must be implemented in subclass.")
    }
    
    open func updateView() {
        fatalError("\(#function) must be implemented in subclass.")
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        setEditing(false, animated: false)
        //        self.styleSelected(selected: false)
    }
    
    fileprivate func addSeparatorView() {
        horizontalSeparatorView.backgroundColor = separatorColor
        addSubview(horizontalSeparatorView)
        
        horizontalSeparatorView.snp.makeConstraints({ maker in
            maker.bottom.equalToSuperview().offset(-cellSeparatorHeight)
            maker.width.equalToSuperview()
            maker.height.equalTo(cellSeparatorHeight)
        })
    }
    //
    
    
    //    open override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    //        if gestureRecognizer === panRecognizer, !(otherGestureRecognizer.view is UIScrollView || otherGestureRecognizer.view === contentView || otherGestureRecognizer.view is UIWindow) {
    //            tableView?.scrollViewDidScroll(tableView!)
    //            return true
    //        }
    //        return false
    //    }
    
    // handle transition of editing state called by tableView
    //    open override func setEditing(_ editing: Bool, animated: Bool) {
    //        super.setEditing(editing, animated: animated)
    //        if !editing, animated, max(stackLeadingWidthConstraint!.constant, stackTrailingWidthConstraint!.constant) > 0 {
    //            hideSwipeActions(force: true)
    //        }
    //    }
    
    //    open override func setSelected(_ selected: Bool, animated: Bool) {
    //        guard let dimaTV = self.superview as? DimaTableView else{
    //            self.styleSelected(selected: selected)
    //            super.setSelected(selected, animated: animated)
    //            return
    //        }
    //
    //        if let myIndexPath = tableView?.indexPath(for: self){
    //            if dimaTV.highlightRowAt == nil || dimaTV.highlightRowAt == myIndexPath{
    //                self.styleSelected(selected: selected)
    //            }
    //        }else{
    //            self.styleSelected(selected: selected)
    //        }
    //
    //        super.setSelected(selected, animated: animated)
    //    }
    
    //Override this method for custom select style
    open func styleSelected(selected: Bool){}
    
    
}

