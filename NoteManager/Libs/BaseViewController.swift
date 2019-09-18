//
//  BaseViewController.swift
//  NoteManager
//
//  Created by Lada Vrska on 15/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

open class BaseViewController: UIViewController {
    
    open var baseUrl: String? = Bundle.main.infoDictionary!["BaseUrl"] as? String
    open var entityId: Int?
    open var activityIndicator: UIActivityIndicatorView?
    open var firstTimeAppearing = true
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        prepareView()
        getApiData()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstTimeAppearing = false
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !firstTimeAppearing{
            reloadData()
        }
    }
    
    open func prepareView(){
        prepareActivityIndicator()
    }
    
    
    open func reloadData(){
        getApiData()
    }
    
    open func updateView(){
        activityIndicator?.removeFromSuperview()
    }
    
    //MARK: - API request
    open func getApiData() {
        activityIndicator?.startAnimating()
    }
    
    open func prepareNavigationBar() {
        guard let navController = self.navigationController else {
            return
        }
        
        let navBar = navController.navigationBar
        navBar.tintColor = .black
        navBar.barTintColor = .yellowGreenDark()
        navBar.isTranslucent = true
        
        prepareNavigationBarContent()
    }
    
    open func prepareNavigationBarContent() {}
    
    //MARK: Activity indicator
    open func prepareActivityIndicator() {
        
        if activityIndicator == nil {
            let activityInd = UIActivityIndicatorView(style: .gray)
            view.addSubview(activityInd)
            activityInd.snp.makeConstraints{ maker in
                maker.edges.equalToSuperview()
            }
            activityInd.layer.zPosition = 100
            activityIndicator = activityInd
        }
    }
}

