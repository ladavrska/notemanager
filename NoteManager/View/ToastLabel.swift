//
//  ToastLabel.swift
//  NoteManager
//
//  Created by Lada Vrska on 20/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit

open class ToastLabel: UILabel {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    open func configure() {
        self.text = "Note saved"
        self.textAlignment = .center
        self.backgroundColor = .yellowGreenLight()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
        self.alpha = 0
    }
}
