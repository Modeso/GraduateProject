//
//  TurkishAirlinesAPIClient.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/19/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import Alamofire

class TurkishAirlinesApiClient {
    
    static func getRequestFrom(url: String,
                               parameters: Parameters,
                               headers: HTTPHeaders,
                               completion: @escaping (Data?, Error?)->Void){
        Alamofire.request(url,
                          method: .get,
                          parameters: parameters,
                          headers: headers)
            .response { response in
                if let data = response.data {
                    let utf8Text = String(data: data, encoding: .utf8)
                    print("Data: \(utf8Text)")
                    completion(data, nil)
                }
                else if let error = response.error {
                    completion(nil, error)
                }
        }
    }
    
    static func postRequestTo(url: String,
                              parameters: Parameters,
                              headers: HTTPHeaders,
                              completion: @escaping (Data?, Error?)->Void){
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters,
                          headers: headers)
            .response { response in
                
        }
    }
}
