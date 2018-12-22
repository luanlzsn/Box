//
//  MineService.swift
//  Box
//
//  Created by luan on 2018/12/1.
//  Copyright © 2018 luan. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import Moya_ObjectMapper

enum UserService {
    case myAddress(String)                                  //地址列表
    case addAddress(String, String, String, String)         //添加地址
    case saveAddress(String, Int, String, String, String)   //修改地址
    case removeAddress(Int)                                 //删除地址
    case editPassword(String, String, String)               //修改密码
    
    case myIndex(String)                                    //个人信息
    case editHead(String, String)                           //修改头像
    case editName(String, String)                           //修改名称
    
    case bindAlipay(String, Int, String, String)            //绑定支付宝
    case unbindAlipay(String, Int, String)                  //解绑支付宝
    case extract(Int, Int)                                  //提现
    case extractList(String, Int, String)                   //提现列表
    case extractDetail(Int)                                 //提现详情
    
    case assetsList(String, Int, Int, String)               //资产列表
    
    case incomeList(String, String, Int, Int)               //收入列表
    case incomeDetail(Int)                                  //收入详情
    
    case myTeam(String, Int)                                //我的团队
    case teamDetail(Int)                                    //团队详情
    
    case alipayQrCode                                       //支付宝二维码
    
    case feedback(String, String, String)                   //已经反馈
    
    case logout(String)
}

extension UserService: TargetType, RestIndicatorDiming {
    var baseURL: URL {
        return kBasePath
    }
    
    var path: String {
        switch self {
        case .myAddress:
            return "user/myAddress"
        case .addAddress:
            return "user/addAddress"
        case .saveAddress:
            return "user/saveAddress"
        case .removeAddress:
            return "user/removeAddress"
            
        case .myIndex:
            return "user/myIndex"
        case .editHead:
            return "user/editHead"
        case .editName:
            return "user/editName"
        case .editPassword:
            return "user/editPassword"
            
        case .bindAlipay:
            return "user/bind"
        case .unbindAlipay:
            return "user/unbind"
        case .extract:
            return "user/tixian"
        case .extractList:
            return "user/tiXianDetail"
        case .extractDetail:
            return "user/tixianView"
            
        case .assetsList:
            return "user/balanceDetail"
            
        case .incomeList:
            return "user/incomeDetail"
        case .incomeDetail:
            return "user/incomeView"
            
        case .myTeam:
            return "user/myTeam"
        case .teamDetail:
            return "user/details"
            
        case .alipayQrCode:
            return "user/account"
            
        case .feedback:
            return "user/feedback"
            
        case .logout:
            return "user/logOut"
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
        case .myAddress(let token):
            return .requestParameters(parameters: ["token" : token], encoding: URLEncoding.default)
        case .addAddress(let token, let people, let phone, let content):
            return .requestParameters(parameters: ["token" : token, "people" : people, "phone" : phone, "content" : content], encoding: URLEncoding.default)
        case .saveAddress(let token, let addressId, let people, let phone, let content):
            return .requestParameters(parameters: ["token" : token, "id" : addressId, "people" : people, "phone" : phone, "content" : content], encoding: URLEncoding.default)
        case .removeAddress(let addressId):
            return .requestParameters(parameters: ["id" : addressId], encoding: URLEncoding.default)
            
        case .myIndex(let token):
            return .requestParameters(parameters: ["token" : token], encoding: URLEncoding.default)
        case .editHead(let token, let head):
            return .requestParameters(parameters: ["token" : token, "head" : head], encoding: URLEncoding.default)
        case .editName(let token, let name):
            return .requestParameters(parameters: ["token" : token, "name" : name], encoding: URLEncoding.default)
        case .editPassword(let token, let oldPassword, let newPassword):
            return .requestParameters(parameters: ["token" : token, "oldPassword" : oldPassword, "newPassword" : newPassword], encoding: URLEncoding.default)
            
        case .bindAlipay(let zfbPhone, let vid, let zfbName, let code):
            return .requestParameters(parameters: ["zfbPhone" : zfbPhone, "vid" : vid, "zfbName" : zfbName, "code" : code], encoding: URLEncoding.default)
        case .unbindAlipay(let zfbPhone, let vid, let code):
            return .requestParameters(parameters: ["zfbPhone" : zfbPhone, "vid" : vid, "code" : code], encoding: URLEncoding.default)
        case .extract(let vid, let money):
            return .requestParameters(parameters: ["vid" : vid, "money" : money], encoding: URLEncoding.default)
        case .extractList(let token, let start, let time):
            return .requestParameters(parameters: ["token" : token, "start" : start, "size" : 20, "time" : time], encoding: URLEncoding.default)
        case .extractDetail(let id):
            return .requestParameters(parameters: ["id" : id], encoding: URLEncoding.default)
            
        case .assetsList(let token, let start, let type, let time):
            if type == 0 {
                return .requestParameters(parameters: ["token" : token, "start" : start, "size" : 20, "time" : time], encoding: URLEncoding.default)
            } else {
                return .requestParameters(parameters: ["token" : token, "start" : start, "size" : 20, "type" : type, "time" : time], encoding: URLEncoding.default)
            }
            
        case .incomeList(let phone, let date, let start, let type):
            if type < 0 {
                return .requestParameters(parameters: ["vipPhone" : phone, "start" : start, "size" : 20, "date" : date], encoding: URLEncoding.default)
            } else {
                return .requestParameters(parameters: ["vipPhone" : phone, "start" : start, "size" : 20, "type" : type, "date" : date], encoding: URLEncoding.default)
            }
        case .incomeDetail(let id):
            return .requestParameters(parameters: ["id" : id], encoding: URLEncoding.default)
            
        case .myTeam(let token, let type):
            return .requestParameters(parameters: ["token" : token, "type" : type], encoding: URLEncoding.default)
        case .teamDetail(let vid):
            return .requestParameters(parameters: ["vid" : vid], encoding: URLEncoding.default)
            
        case .feedback(let token, let content, let images):
            return .requestParameters(parameters: ["token" : token, "content" : content, "images" : images], encoding: URLEncoding.default)
            
        case .logout(let token):
            return .requestParameters(parameters: ["token" : token], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var needDisplay: Bool {
        return true
    }
    
    
}

let userService = MoyaProvider<UserService>(plugins: [NetworkLoggerPlugin(verbose: true, cURL: true), DefaultNetworkActivityPlugin()])
