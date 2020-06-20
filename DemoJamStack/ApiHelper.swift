// 
// ApiHelper.swift
// 
// Created on 6/20/20.
// 

import UIKit
import Alamofire

struct ApiResponse {
    var auth: Bool?
    var token: String?
}

class ApiHelper {

    static let baseUrl = "https://radiant-dusk-57430.herokuapp.com"
    static var authUrl: String {
        "\(baseUrl)/api/auth"
    }
    
    static func logIn(params: [String: Any], completionSuccess: @escaping (ApiResponse) -> (), completionError: @escaping (Error, String?) -> ()) {
        let url = "\(authUrl)/login"
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            handleResponse(response: response, completionSuccess: completionSuccess, completionError: completionError)
        }
    }
    
    static func register(params: [String: Any], completionSuccess: @escaping (ApiResponse) -> (), completionError: @escaping (Error, String?) -> ()) {
        let url = "\(authUrl)/register"
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            handleResponse(response: response, completionSuccess: completionSuccess, completionError: completionError)
        }
    }
    
    private static func handleResponse(response: DataResponse<Any>, completionSuccess: @escaping (ApiResponse) -> (), completionError: @escaping (Error, String?) -> ()) {
        switch response.result {
        case .success:
            let res = response.result.value as? [String: Any]
            var ret = ApiResponse()
            if let auth = res?["auth"] as? Bool {
                ret.auth = auth
            }
            if let token = res?["token"] as? String {
                ret.token = token
            }
            completionSuccess(ret)
            
        case .failure(let error):
            var dataStr: String? = nil
            if let data = response.data {
                dataStr = String(data: data, encoding: .utf8)
            }
            completionError(error, dataStr)
        }
    }
}
