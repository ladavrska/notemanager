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
    
    override open var requestUrl: String{
        if let baseUrl = Bundle.main.infoDictionary!["BaseUrl"] as? String {
            let url = "\(baseUrl)/notes"
            return url
        }
        return ""
    }
    
    override open func getApiData() {
        isLoading.value = true
        Alamofire.request(requestUrl).responseData { response in
            self.isLoading.value = false
            let decoder = JSONDecoder()
            let result: Result<[PersonalNote]> = decoder.decodeResponse(from: response)
            switch result {
            case .success:
                self.personalNoteData.value = result.value
            case .failure:
                print(result.error ?? "Error parsing data")
            }
        }
    }
}
