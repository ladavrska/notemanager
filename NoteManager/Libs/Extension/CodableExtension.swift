//
//  CodableExtension.swift
//  NoteManager
//
//  Created by Lada Vrska on 18/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
