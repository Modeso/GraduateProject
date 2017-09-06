//
//  TurkishAirlinesAPIClient.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 7/19/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import Foundation
import Alamofire

public class ApiClient {

    private static var baseUrl = "http://www.euroleague.net/euroleague/api/"

    public static func getRequestFrom(url: String,
                                      parameters: Parameters,
                                      headers: HTTPHeaders,
                                      completion: @escaping (Data?, Error?) -> Void) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 10
//        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        Alamofire.request(baseUrl + url,
                        method: .get,
                        parameters: parameters,
                        headers: headers)
            .response { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let data = response.data, response.error == nil {
                    completion(data, nil)
                } else {
                    completion(nil, response.error)
                }
        }
    }

    public static func postRequestTo(url: String,
                                     parameters: Parameters,
                                     headers: HTTPHeaders,
                                     completion: @escaping (Data?, Error?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        Alamofire.request(baseUrl + url,
                        method: .post,
                        parameters: parameters,
                        headers: headers)
            .response { _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
