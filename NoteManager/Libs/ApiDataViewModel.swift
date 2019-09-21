//
//  ApiDataViewModel.swift
//  NoteManager
//
//  Created by Lada Vrska on 21/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import Bond
import Alamofire
import Bond

public struct ApiError {
    public let message: String?
    public let object: Error?
}

open class ApiDataViewModel {
    public let apiCollection = Observable<ApiCollection>(ApiCollection(data: [:]))
    let error = Observable<ApiError?>(nil)
    let isLoading = Observable<Bool>(false)
    
    open var requestUrl: String{
        if let baseUrl = Bundle.main.infoDictionary!["BaseUrl"] as? String {
            return baseUrl
        }
        return ""
    }
    
    open func getApiData(){
        isLoading.value = true
        Alamofire.request(requestUrl, method: .get).responseJSON { response in
            self.isLoading.value = false
            switch response.result {
            case .success(let JSON as [String:Any]):
                self.apiCollection.value = ApiCollection(data: JSON as [String:AnyObject])
                self.error.value = nil
            default:
                self.error.value = ApiError(message: nil, object: response.error)
            }
        }
    }
}
