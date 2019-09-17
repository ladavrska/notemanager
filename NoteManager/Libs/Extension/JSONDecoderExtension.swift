//
//  JSONDecoderExtension.swift
//  NoteManager
//
//  Created by Lada Vrska on 17/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import UIKit
import Alamofire

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        guard response.error == nil else {
            print(response.error!)
            return .failure(response.error!)
        }
        
        guard let responseData = response.data else {
            print("didn't get any data from API")
            return .failure(BackendError.parsing(reason:
                "Did not get data in response"))
        }
        
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("error trying to decode response")
            print(error)
            return .failure(error)
        }
    }
}

enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
    case parsing(reason: String)
}
