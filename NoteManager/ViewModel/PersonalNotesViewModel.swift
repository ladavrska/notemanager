//
//  PersonalNotesViewModel.swift
//  NoteManager
//
//  Created by Lada Vrska on 21/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import Foundation
import Alamofire
import Bond

public class PersonalNotesViewModel: ApiDataViewModel {
    
    public let personalNoteData = Observable<[PersonalNote]?>([])
    let noteDeleted = Observable<Bool?>(nil)
    
    override open var requestUrl: String{
        if let baseUrl = Bundle.main.infoDictionary!["BaseUrl"] as? String {
            let url = "\(baseUrl)/notes"
            return url
        }
        return ""
    }
    
    public var deleteUrl: String{
        if let baseUrl = Bundle.main.infoDictionary!["BaseUrl"] as? String {
            let url = "\(baseUrl)/notes"
            return url
        }
        return ""
    }
    
    override public func getApiData() {
        isLoading.value = true
        Alamofire.request(requestUrl).responseData { response in
            self.isLoading.value = false
            let decoder = JSONDecoder()
            let result: Result<[PersonalNote]> = decoder.decodeResponse(from: response)
            switch result {
            case .success:
                self.personalNoteData.value = result.value
            case .failure:
                var errorMessage = "Error fetching notes data"
                if let responseErrorData = response.data, let message = self.getResponseErrorMessage(errorData: responseErrorData) {
                    errorMessage = message
                }
                self.error.value = ApiError(message: errorMessage, object: nil)
            }
        }
    }
    
    public func deleteNote(_ id: Int) {
        isLoading.value = true
        var deleteUrl = ""
        if let baseUrl = Bundle.main.infoDictionary!["BaseUrl"] as? String {
            deleteUrl = "\(baseUrl)/notes/\(id)"
        }
        Alamofire.request(deleteUrl, method: .delete).responseJSON { response in
            self.isLoading.value = false
            guard response.result.isSuccess else {
                self.noteDeleted.value = false
                return
            }
            self.noteDeleted.value = true
        }
    }
}
