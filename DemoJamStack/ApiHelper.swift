// 
// ApiHelper.swift
// 
// Created on 6/20/20.
// 

import UIKit
import Alamofire

struct AuthResponse {
    var auth: Bool?
    var token: String?
}

struct InfoResponse {
    var name: String?
    var email: String?
    var age: Int?
    var gender: Int?
    var id: String?
}

class ApiHelper {

    static let baseUrl = "https://radiant-dusk-57430.herokuapp.com"
    static var authUrl: String {
        "\(baseUrl)/api/auth"
    }
    
    static func logIn(params: [String: Any], completionSuccess: @escaping (AuthResponse) -> (), completionError: @escaping (Error, String?) -> ()) {
        let url = "\(authUrl)/login"
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            handleResponse(response: response, completionSuccess: completionSuccess, completionError: completionError)
        }
    }
    
    static func register(params: [String: Any], completionSuccess: @escaping (AuthResponse) -> (), completionError: @escaping (Error, String?) -> ()) {
        let url = "\(authUrl)/register"
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            handleResponse(response: response, completionSuccess: completionSuccess, completionError: completionError)
        }
    }
    
    static func getInfo(token: String, completionSuccess: @escaping (InfoResponse) -> (), completionError: @escaping (Error, String?) -> ()) {
        let url = "\(authUrl)/me"
        let header = ["x-access-token": token]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case .success:
                let res = response.result.value as? [String: Any]
                var ret = InfoResponse()
                if let name = res?["name"] as? String {
                    ret.name = name
                }
                if let email = res?["email"] as? String {
                    ret.email = email
                }
                if let age = res?["age"] as? Int {
                    ret.age = age
                }
                if let gender = res?["gender"] as? Int {
                    ret.gender = gender
                }
                if let id = res?["id"] as? String {
                    ret.id = id
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
    
    private static func handleResponse(response: DataResponse<Any>, completionSuccess: @escaping (AuthResponse) -> (), completionError: @escaping (Error, String?) -> ()) {
        switch response.result {
        case .success:
            let res = response.result.value as? [String: Any]
            var ret = AuthResponse()
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
