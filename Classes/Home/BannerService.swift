//
//  BannerService.swift
//  Box
//
//  Created by luan on 2018/11/30.
//  Copyright © 2018 luan. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import Moya_ObjectMapper

enum BannerService {
    case homeBanner
    case taskBanner
    case news
}

extension BannerService: TargetType, RestIndicatorDiming {
    var baseURL: URL {
        return kBasePath
    }
    
    var path: String {
        switch self {
        case .homeBanner:
            return "banner/indexBanner"
        case .taskBanner:
            return "banner/taskBanner"
        case .news:
            return "news/news"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var needDisplay: Bool {
        return true
    }
    
    
}

let bannerService = MoyaProvider<BannerService>(plugins: [NetworkLoggerPlugin(verbose: true, cURL: true), DefaultNetworkActivityPlugin()])
