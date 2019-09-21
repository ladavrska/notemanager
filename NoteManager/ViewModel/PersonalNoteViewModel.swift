//
//  PersonalNoteViewModel.swift
//  NoteManager
//
//  Created by Lada Vrska on 19/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit
import Bond

public class PersonalNoteViewModel {
    
    let personalNote = Observable<PersonalNote>(PersonalNote())
    
    public init(note: PersonalNote) {
        self.personalNote.value = note
    }
    
    var id: Int {
        return personalNote.value.id
    }
    
    var title: String {
        return personalNote.value.title
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
