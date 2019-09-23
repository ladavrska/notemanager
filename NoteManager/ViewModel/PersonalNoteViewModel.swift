//
//  PersonalNoteViewModel.swift
//  NoteManager
//
//  Created by Lada Vrska on 19/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit
import Alamofire
import Bond

public class PersonalNoteViewModel: ApiDataViewModel {
    
    let personalNote = Observable<PersonalNote>(PersonalNote())
    let newNotePosted = Observable<Bool?>(nil)
    let noteUpdated = Observable<Bool?>(nil)
    
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
    
    open var postUrl: String{
        if let baseUrl = Bundle.main.infoDictionary!["BaseUrl"] as? String {
            let url = "\(baseUrl)/notes"
            return url
        }
        return ""
    }
    
    public func applyMode(_ mode: DetailViewMode, to view: UITextView) {
        switch mode {
        case .view:
            view.textColor = .darkGray
        case .edit, .create:
            view.textColor = .black
        }
    }
    
    open func getApiData(id: Int) {
        let url = "\(requestUrl)/notes/\(id)"
        isLoading.value = true
        Alamofire.request(url).responseData { response in
            self.isLoading.value = false
            let decoder = JSONDecoder()
            let result: Result<PersonalNote> = decoder.decodeResponse(from: response)
            switch result {
            case .success:
                self.personalNote.value = result.value ?? PersonalNote()
            case .failure:
                print(result.error ?? "Error parsing data")
            }
        }
    }
    
    open func postNewNote() {
        isLoading.value = true
        let parameters = ["title": self.title]
        Alamofire.request(postUrl, method: .post, parameters: parameters).responseJSON { response in
            self.isLoading.value = false
            guard response.result.isSuccess else {
                print("Error while fetching data: \(String(describing: response.result.error))")
                return
            }
            self.newNotePosted.value = true
        }
    }
    
    open func putNote() {
        var url = ""
        if let baseUrl = Bundle.main.infoDictionary!["BaseUrl"] as? String {
            url = "\(baseUrl)/notes/\(self.id)"
        }
        isLoading.value = true
        print(getParameters())
        print("put url: \(url)")
        Alamofire.request(url, method: .put, parameters: getParameters()).responseJSON { response in
            self.isLoading.value = false
            guard response.result.isSuccess else {
                print("Error while updating data: \(String(describing: response.result.error))")
                self.noteUpdated.value = false
                return
            }
            self.noteUpdated.value = true
        }
    }
    
    func getParameters() -> [String:Any] {
        var dict: [String:Any] = [:]
        do {
            let dataAsDictionary = try self.personalNote.value.asDictionary()
            dict = dataAsDictionary
        } catch {
            print(error)
        }
        return dict
    }
}
