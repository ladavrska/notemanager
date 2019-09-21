//
//  ApiCollection.swift
//  NoteManager
//
//  Created by Lada Vrska on 21/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import Foundation

open class ApiCollection {
    open var data: [String: AnyObject]?
    
    public init(data: Dictionary<String, AnyObject>) {
            self.data = data
    }
}
