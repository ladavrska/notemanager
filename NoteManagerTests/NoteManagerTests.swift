//
//  NoteManagerTests.swift
//  NoteManagerTests
//
//  Created by Lada Vrska on 15/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import XCTest
@testable import NoteManager

class NoteManagerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPersonalNote() {
        let note = PersonalNote(id: 3, title: "Personal note test title")
        XCTAssertEqual(note.id, 3)
        XCTAssertEqual(note.title, "Personal note test title")
    }

}
