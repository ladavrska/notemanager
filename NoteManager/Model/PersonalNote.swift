//
//  PersonalNote.swift
//  NoteManager
//
//  Created by Lada Vrska on 15/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import Foundation

public struct PersonalNote: Codable {
    var id: Int
    var title: String
    
    init(id: Int = 0, title: String = "") {
        self.id = id
        self.title = title
    }
}
