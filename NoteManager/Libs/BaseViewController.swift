//
//  BaseViewController.swift
//  NoteManager
//
//  Created by Lada Vrska on 15/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import Foundation
import UIKit

open class BaseViewController: UIViewController {
    
    open var baseUrl: String = "http://private-9aad-note10.apiary-mock.com"
    open var entityId: Int?
    open var entityTitle: String?   // Use for Nav Bar title, create enum for titles
    open var entityData: Any?
    
    public let viewWidth = UIScreen.main.bounds.size.width
    public let viewHeight = UIScreen.main.bounds.size.height
    
    
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
        //hideNavigationBar()
        //prepareActivityIndicator()
    }
    
    
    open func reloadData(){
        getApiData()
    }
    
    open func updateView(){
        //activityIndicator?.hideActivityIndicator()
    }
    
    //MARK: - API request
    open func getApiData() {
        //activityIndicator?.showActivityIndicator()
    }
    
    //    open func hideNavigationBar() {
    //        if self.navigationController != nil {
    //            self.navigationController?.isNavigationBarHidden = true
    //        }
    //    }
    
    open func prepareNavigationBar() {
        guard let navController = self.navigationController else {
            return
        }
        
        let navBar = navController.navigationBar
        //navBar.barStyle = .black
        navBar.tintColor = .black
        navBar.barTintColor = .green
        navBar.isTranslucent = true
        
        prepareNavigationBarContent()
    }
    
    open func prepareNavigationBarContent() {}
    
    open func prepareTitleAsImage() {
        //        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        //        imageView.contentMode = .scaleAspectFit
        //
        //        let image = UIImage(named: "Apple_Swift_Logo")
        //        imageView.image = image
        //
        //        navigationItem.titleView = imageView
    }
    
    
}

