//
//  PersonalNoteTableViewCell.swift
//  NoteManager
//
//  Created by Lada Vrska on 15/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


open class PersonalNoteTableViewCell: BaseTableViewCell {
    
    
    internal let titleLabel = UILabel()
    internal let idLabel = UILabel()
    
    open override func prepareView() {
        separatorColor = .lightGray
        prepareTitleLabel()
        //styleCellToUnselected()
    }
    
    open func prepareTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(30)
            maker.trailing.equalToSuperview().offset(-30)
            maker.height.equalTo(21)
        }
    }
    
    override open func updateView(){
        guard let data = data as? PersonalNote else { return }
        titleLabel.text = data.title
        idLabel.text = String(data.id)
    }
    
    //MARK: Selected cell
    
    
    //    public func styleCellToUnselected() {
    //        self.contentView.backgroundColor = UIColor.white
    //        titleLabel.textColor = UIColor.black50PercentColor()
    //        idLabel.textColor = UIColor.deepNavyBlueColor()
    //        salaryTypeLabel.textColor = UIColor.deepNavyBlueColor()
    //        timeLabel.textColor = UIColor.deepNavyBlueColor()
    //        timeWorkDoneTitleLabel.textColor = UIColor.black50PercentColor()
    //        timeWorkDoneValueLabel.textColor = UIColor.deepNavyBlueColor()
    //    }
    
}

