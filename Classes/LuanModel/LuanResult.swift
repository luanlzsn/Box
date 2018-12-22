//
//  FMResult.swift
//  Tocos
//
//  Created by luan on 2018/11/14.
//  Copyright © 2018 luan. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya
import RxSwift
import NVActivityIndicatorView
import Result

class LuanResult: LuanModel {
    
    var code: Int = 1
    var message: String = ""
    
    override func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
    }
}

class DicResult: LuanResult {
    var data: [String : Any]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["data"]
    }
}

enum RestError: Error, LocalizedError {
    
    case `default`(LuanResult)
    case reLogin
    
    var errorDescription: String? {
        switch self {
        case .default(let result):
            return result.message
        case .reLogin:
            return "token失效，请重新登录"
        }
    }
}

extension LuanResult {
    func validate<S: LuanResult>() throws -> S {
        if code == 0 {
            return self as! S
        } else if code == 2 {
            LuanManage.userInfo = nil
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            appdelegate?.window?.rootViewController = R.storyboard.login().instantiateInitialViewController()
            throw RestError.reLogin
        } else {
            throw RestError.default(self)
        }
    }
}

extension Observable where E: LuanResult {
    func validate() -> Observable<E> {
        return flatMap({ Observable.just(try $0.validate()) })
    }

    func showToastWhenFailured(`in` view: UIView? = UIApplication.shared.keyWindow) -> Observable<E> {
        return self.do(onError: { (error) in
            view?.makeToast(error.localizedDescription)
        })
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType: LuanResult {
    func validate() -> Single<ElementType> {
        return flatMap({ Single.just(try $0.validate()) })
    }
    
    func showToastWhenFailured(`in` view: UIView? = UIApplication.shared.keyWindow) -> Single<ElementType> {
        return self.do(onError: { (error) in
            view?.makeToast(error.localizedDescription)
        })
    }
}

protocol RestIndicatorDiming {
    var needDisplay: Bool { get }
}

class DefaultNetworkActivityPlugin: PluginType {
    public func willSend(_ request: RequestType, target: TargetType) {
        guard let diming = target as? RestIndicatorDiming, diming.needDisplay else { return }
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(), nil)
    }
    
    /// Called by the provider as soon as a response arrives, even if the request is canceled.
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        guard let diming = target as? RestIndicatorDiming, diming.needDisplay else { return }
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.timeoutInterval = 20
        return request
    }
    
}

final class ObjectWrapper<T: Mappable>: LuanResult {
    
    var data: T?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["data"]
    }
}

final class ArrayWrapper<T: Mappable>: LuanResult {
    
    var data: [T]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["data"]
    }
    
}
