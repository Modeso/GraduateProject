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
    
    private static var baseUrl = "http://www.euroleague.net/euroleague/api/"
    
    static func getRequestFrom(url: String,
                               parameters: Parameters,
                               headers: HTTPHeaders,
                               completion: @escaping (Data?, Error?)->Void){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(baseUrl + url,
                          method: .get,
                          parameters: parameters,
                          headers: headers)
            .response { response in
                if let data = response.data {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completion(data, nil)
                }
        }
    }
    
    static func postRequestTo(url: String,
                              parameters: Parameters,
                              headers: HTTPHeaders,
                              completion: @escaping (Data?, Error?)->Void){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(baseUrl + url,
                          method: .post,
                          parameters: parameters,
                          headers: headers)
            .response { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
