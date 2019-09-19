//
//  PersonalNoteViewModel.swift
//  NoteManager
//
//  Created by Lada Vrska on 19/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit

public class PersonalNoteViewModel {
    
    var personalNote: PersonalNote
    
    public init(note: PersonalNote) {
        self.personalNote = note
    }
    
    var id: Int {
        return personalNote.id
    }
    
    var title: String {
        return personalNote.title
    }
    
    public func updateNote(_ view: InputView) {
        view.text = title
    }
    
    public func applyMode(_ mode: DetailViewMode, to view: UITextView) {
        switch mode {
        case .view:
            view.textColor = .darkGray
        case .edit, .create:
            view.textColor = .black
        }
    }
}
