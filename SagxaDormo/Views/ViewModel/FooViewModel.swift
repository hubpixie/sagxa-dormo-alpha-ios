//
//  FooViewModel.swift
//  SagxaDormo
//
//  Created by venus.janne on 2019/01/24.
//  Copyright © 2019 com.venuso-janne. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FooViewModel {
    typealias GetUserApi = ((Int, ((Int, User?) -> Void)?) -> Void)
    
    private  var _get_user_api: GetUserApi?
    private var _get_user_completionHandler: ((Int, User?) -> Void)?
    private let _disposeBag = DisposeBag()

    func doGetUser(completionHandler : ((Int, User?) -> Void)?) {
        
        let call_user_api: GetUserApi = {(retries: Int, completionHandler: ((Int, User?) -> Void)?) -> Void in
            let param: UserParam = UserParam(nickname: "aaa", email: nil)
            
            SDApiClient.prepareSimpleHeaders()
            SDApiCore.getUser(body: param).subscribe(
                onNext: {user -> Void in
                    completionHandler?(0, user)
            }, onError: { [weak self] error  in
                if let error = SDApiClient.errorInfo(error: error) {
                    if error.errorCode == SDApiClient.HttpStatusCode.notFound.rawValue {
                        completionHandler?(error.errorCode, nil)
                    } else {
                        self?.handleFailure(retires: retries, error: error)
                    }
                }
            }).disposed(by: self._disposeBag)
        }
        self._get_user_api = call_user_api
        self._get_user_completionHandler = completionHandler
        call_user_api(0, completionHandler)
    }
    
    func doUpdateUser(param: UserParam, completionHandler : ((Bool) -> Void)?) {
        
        SDApiClient.prepareSimpleHeaders()
        SDApiCore.updateUser(body: param).subscribe(
            onNext: {
                completionHandler?(true)
        }, onError: { [weak self] error  in
            if let error = SDApiClient.errorInfo(error: error) {
                print("error = \(String(data: error.errorData!, encoding: .utf8)!)")
                //self?.statusCode = error.errorCode
                completionHandler?(false)
            }
        }).disposed(by: self._disposeBag)
    }
    
    func doRegisterUser(param: User, completionHandler : ((Bool) -> Void)?) {
        
        SDApiClient.prepareSimpleHeaders()
        SDApiCore.registerUser(body: param).subscribe(
            onNext: {
                completionHandler?(true)
        }, onError: { [weak self] error  in
            if let error = SDApiClient.errorInfo(error: error) {
                print("error = \(String(data: error.errorData!, encoding: .utf8)!)")
                //self?.statusCode = error.errorCode
                completionHandler?(false)
            }
        }).disposed(by: self._disposeBag)
    }
    
    func handleFailure(retires: Int, error: SDApiClient.ErrorInfo) {
        switch error.errorCode {
        case 401:
            if retires <= 1 {
                self._get_user_api?(retires + 1, self._get_user_completionHandler)
            }
        case 403:
            break
        default:
            break
        }
    }

}

