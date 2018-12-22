//
//  LoginService.swift
//  Box
//
//  Created by luan on 2018/11/30.
//  Copyright © 2018 luan. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import Moya_ObjectMapper

enum LoginService {
    case login(String, String)                  //登录
    case sendCode(String)                       //注册发送验证码
    case registNext(String, String)             //注册校验验证码
    case regist(String, String, String)         //注册
    case forgetPassword(String, String)         //忘记密码校验验证码
    case forgetNext(String, String)             //忘记密码
}

extension LoginService: TargetType, RestIndicatorDiming {
    var baseURL: URL {
        return kBasePath
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login/login"
        case .sendCode:
            return "regist/sendCode"
        case .registNext:
            return "regist/next"
        case .regist:
            return "regist/save"
        case .forgetPassword:
            return "user/forgetPassword"
        case .forgetNext:
            return "user/forgetNext"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .login(let phone, let password):
            return .requestParameters(parameters: ["phone" : phone, "password" : password], encoding: URLEncoding.default)
        case .sendCode(let phone):
            return .requestParameters(parameters: ["phone" : phone], encoding: URLEncoding.default)
        case .registNext(let phone, let code):
            return .requestParameters(parameters: ["phone" : phone, "code" : code], encoding: URLEncoding.default)
        case .regist(let phone, let password, let code):
            return .requestParameters(parameters: ["phone" : phone, "password" : password, "code" : code], encoding: URLEncoding.default)
        case .forgetPassword(let phone, let code):
            return .requestParameters(parameters: ["phone" : phone, "code" : code], encoding: URLEncoding.default)
        case .forgetNext(let phone, let password):
            return .requestParameters(parameters: ["phone" : phone, "newPassword" : password], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var needDisplay: Bool {
        return true
    }
    
}

let loginService = MoyaProvider<LoginService>(plugins: [NetworkLoggerPlugin(verbose: true, cURL: true), DefaultNetworkActivityPlugin()])
