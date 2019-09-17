//
//  CanPrepareButton.swift
//  NoteManager
//
//  Created by Lada Vrska on 17/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit

public protocol CanPrepareButton: class {
    func prepareIconButton(icon: String, size: CGFloat, color: UIColor?) -> UIButton
}

public extension CanPrepareButton {
    public func prepareIconButton(icon: String, size: CGFloat, color: UIColor? = .black) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: icon)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = color
        button.frame = CGRect(x: 0, y: 0, width: size, height: size)
        return button
    }
}
