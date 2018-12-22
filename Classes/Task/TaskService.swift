//
//  TaskService.swift
//  Box
//
//  Created by luan on 2018/12/1.
//  Copyright © 2018 luan. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import Moya_ObjectMapper

enum TaskService {
    case taskList(String)                   //领取任务列表
    case uploadImg([UIImage])               //上传图片
    case receiveTask(String, Int)           //领取任务
    case putTaskList(String)                //提交任务列表
    case submitTask(Int, String)            //提交任务
    case taskRecord(String, Int, Int)       //任务记录
}

extension TaskService: TargetType, RestIndicatorDiming {
    var baseURL: URL {
        return kBasePath
    }
    
    var path: String {
        switch self {
        case .taskList:
            return "task/list"
        case .uploadImg:
            return "task/uploadImg"
        case .receiveTask:
            return "task/getTask"
        case .putTaskList:
            return "task/putList"
        case .submitTask:
            return "task/put"
        case .taskRecord:
            return "task/taskRecord"
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
        case .taskList(let token):
            return .requestParameters(parameters: ["token" : token], encoding: URLEncoding.default)
        case .uploadImg(let imageArray):
            var array = [Moya.MultipartFormData]()
            for image in imageArray {
                array.append(Moya.MultipartFormData(provider: .data(image.jpegData(compressionQuality: 0.25) ?? Data()), name: "files", fileName: "image.png", mimeType: "image/png"))
            }
            return .uploadMultipart(array)
        case .receiveTask(let token, let tid):
            return .requestParameters(parameters: ["token" : token, "tid" : tid], encoding: URLEncoding.default)
        case .putTaskList(let token):
            return .requestParameters(parameters: ["token" : token], encoding: URLEncoding.default)
        case .submitTask(let id, let image):
            return .requestParameters(parameters: ["id" : id, "image" : image], encoding: URLEncoding.default)
        case .taskRecord(let phone, let status, let start):
            if status < 0 {
                return .requestParameters(parameters: ["vipPhone" : phone, "start" : start, "size" : 20], encoding: URLEncoding.default)
            } else {
                return .requestParameters(parameters: ["vipPhone" : phone, "status" : status, "start" : start, "size" : 20], encoding: URLEncoding.default)
            }
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var needDisplay: Bool {
        return true
    }
    
    
}

let taskService = MoyaProvider<TaskService>(plugins: [NetworkLoggerPlugin(verbose: true, cURL: true), DefaultNetworkActivityPlugin()])
