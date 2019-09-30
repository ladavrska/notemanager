//
//  ApiCollection.swift
//  NoteManager
//
//  Created by Lada Vrska on 21/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import Foundation

public class ApiCollection {
    public var data: [String: AnyObject]?
    
    public init(data: Dictionary<String, AnyObject>) {
            self.data = data
    }
}
