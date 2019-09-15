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
    
}

