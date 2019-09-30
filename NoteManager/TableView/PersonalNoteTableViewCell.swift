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


public class PersonalNoteTableViewCell: BaseTableViewCell {
    
    let titleLabel = UILabel()
    
    override public func prepareView() {
        separatorColor = .lightGray
        prepareTitleLabel()
    }
    
    public func prepareTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(30)
            maker.trailing.equalToSuperview().offset(-30)
            maker.height.equalTo(45)
        }
        titleLabel.numberOfLines = 2        
    }
    
    override public func updateView(){
        guard let data = data as? PersonalNote else { return }
        titleLabel.text = data.title
    }
}

