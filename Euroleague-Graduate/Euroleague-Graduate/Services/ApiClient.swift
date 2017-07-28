//
//  TurkishAirlinesAPIClient.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/19/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import Alamofire

class ApiClient {
    
    private static let baseUrl = "http://www.euroleague.net/euroleague/api/"
    
    static func getRequestFrom(url: String,
                               parameters: Parameters,
                               headers: HTTPHeaders,
                               completion: @escaping (Data?, Error?)->Void){
        Alamofire.request(baseUrl + url,
                          method: .get,
                          parameters: parameters,
                          headers: headers)
            .response { response in
                if let data = response.data {
                    completion(data, nil)
                }
        }
    }
    
    static func postRequestTo(url: String,
                              parameters: Parameters,
                              headers: HTTPHeaders,
                              completion: @escaping (Data?, Error?)->Void){
        Alamofire.request(baseUrl + url,
                          method: .post,
                          parameters: parameters,
                          headers: headers)
            .response { response in
                
        }
    }
}
