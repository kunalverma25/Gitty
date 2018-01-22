//
//  Server.swift
//  Gitty
//
//  Created by upandrarai on 20/01/18.
//  Copyright © 2018 Kunal. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Server {
    
    let baseURL = "https://api.github.com/"
    var loginURL = ""
    var profileURL = ""
    var otherUserProfileURL = ""
    var searchURL = ""
    
    init() {
        loginURL = baseURL + "authorizations"
        profileURL = baseURL + "user"
        otherUserProfileURL = baseURL + "users/"
        searchURL = baseURL + "search/users?q="
    }
    
    static func callAPI(_ url: URL, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?, encoding: ParameterEncoding = JSONEncoding.default, completion: @escaping (JSON?, Error?) -> ())  {
        var jsonResult: JSON? = nil
        var errorResult: Error? = nil
        var header : HTTPHeaders = [:]
        if headers == nil {
            if let basicAuth = UserDefaults.standard.value(forKey: "userToken") as? String {
                header = ["Authorization": basicAuth]
            }
        }
        else {
            header = headers!
        }
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: header).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                jsonResult = json
            case .failure(let error):
                errorResult = error
            }
            completion(jsonResult, errorResult)
        }
        
    }
}

