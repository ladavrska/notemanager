//
//  AlertLabel.swift
//  NoteManager
//
//  Created by Lada Vrska on 23/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit

public enum AlertType{
    case success
    case error
    
    public func getAlertTypeColor() -> UIColor {
        switch self {
        case .success:
            return .yellowGreenLight()
        case .error:
            return .red
        }
    }
}

public class AlertLabel: UILabel {
    
    weak var presenterVC: UIViewController?
    var alertType: AlertType?
    var message: String = ""
    
    var onAlertShowCompleted: (() -> ())?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public convenience init(presenter: UIViewController, type: AlertType, message: String) {
        self.init()
        self.presenterVC = presenter
        self.alertType = type
        self.message = message
        
        configure()
        prepareAlertLabel()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    public func configure() {
        self.textAlignment = .center
        self.backgroundColor = self.alertType?.getAlertTypeColor()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
        self.alpha = 0
        self.text = message
        self.textColor = .white
    }
    
    public func prepareAlertLabel() {
        presenterVC?.view.addSubview(self)
        self.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().offset(-100)
            maker.width.equalTo(300)
            maker.height.equalTo(40)
            maker.centerX.equalToSuperview()
        }
    }
    
    public func show() {
        UIView.animate(withDuration: 1.3, delay: 0.8, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.alpha = 1
            self.layoutIfNeeded()
        }, completion: { finished in
            self.alpha = 0
            self.onAlertShowCompleted?()
        })
    }
    
}
