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
    let isLoading = Observable<Bool?>(nil)
    
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
    
    // MARK: - ResponseError
    
    func getResponseErrorMessage(errorData: Data) -> String? {
        if let stringFromResponseErrorData = String(data: errorData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
            if let errorDict = self.convertToDictionary(text: stringFromResponseErrorData), let message = errorDict["message"] as? String {
                return message
            }
        }
        return nil
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
