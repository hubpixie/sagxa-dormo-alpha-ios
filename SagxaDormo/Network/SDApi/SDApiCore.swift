//
//  SDAPICore.swift
//  SagxaDormo
//
//  Created by x.yang on 2018/11/17.
//  Copyright © 2018年 x.yang. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwaggerClient

class SDApiCore {
    /**
     ユーザー取得
     
     - parameter completion: completion handler to receive the data and the error objects
     */
    class func getUser(body: UserParam?, completion: @escaping ((_ data: User?,_ error: Error?) -> Void)) {
        getUserWithRequestBuilder(body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    /**
     ユーザー取得

     - returns: Observable<User>
     */
    class func getUser(body: UserParam?) -> Observable<User> {
        return Observable.create { observer -> Disposable in
            getUser(body: body) { data, error in
                if let error = error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     SagxaDormoユーザー情報取得
     - GET /client/user
     - #### 処理概要 * ユーザーの検索は、Firebaseの識別子(ユーザーUID)で行うため、GETパラメータにuser_id等は不要 * Firebaseに存在するユーザーが、SagxaDormoDBにも存在するか検索する(存在しなければ404を返す)
     - BASIC:
     - type: http
     - name: bearerAuth
     
     - returns: RequestBuilder<User>
     */
    class func getUserWithRequestBuilder(body: UserParam?) -> RequestBuilder<User> {
        let path = "/users/_"
        let URLString = SDApiClient.webApiPath + path
        let parameters: [String: Any]? = nil//JSONEncodingHelper.encodingParameters(forEncodableObject: body)
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(["user[name]": body?.nickname])

        let requestBuilder: RequestBuilder<User>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    

    /**
     SagxaDormoユーザー登録
     
     - parameter body: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    class func registerUser(body: User? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        registerUserWithRequestBuilder(body: body).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }

    /**
     SagxaDormoユーザー登録
     
     - parameter body: (body)  (optional)
     - returns: Observable<Void>
     */
    class func registerUser(body: User? = nil) -> Observable<Void>  {
        return Observable.create { observer -> Disposable in
            registerUser(body: body) { data, error in
                if let error = error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }
    

    /**
     SagxaDormoユーザー登録
     - POST /client/user
     - #### 処理概要 * すでにユーザが登録されていないかチェック(登録されている場合は409を返す) * SagxaDormoDBにユーザを登録する * ベリトランス側にアカウントを作成する(AccountAddRequestDto)
     - BASIC:
     - type: http
     - name: bearerAuth
     
     - parameter body: (body)  (optional)
     
     - returns: RequestBuilder<Void>
     */
    class func registerUserWithRequestBuilder(body: User? = nil) -> RequestBuilder<Void> {
        let path = "/users"
        let URLString = SDApiClient.webApiPath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     SagxaDormoユーザー情報変更
     
     - parameter body: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    class func updateUser(body: UserParam? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        updateUserWithRequestBuilder(body: body).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }

    /**
     SagxaDormoユーザー情報変更
     
     - parameter body: (body)  (optional)
     - returns: Observable<Void>
     */
    class func updateUser(body: UserParam? = nil) -> Observable<Void>  {
        return Observable.create { observer -> Disposable in
            updateUser(body: body) { data, error in
                if let error = error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }
    

    /**
     SagxaDormoユーザー情報変更
     - PUT /client/user
     - #### 処理概要 * SagxaDormoDBにユーザーが存在するかチェック(存在しなければ404を返す) * SagxaDormoDBのユーザー情報を更新する(電話番号、生年月日、性別、ニックネーム、FCMトークン) * Firebaseの情報を更新する(メールアドレス)※パスワードはクライアント側で更新してください * メールアドレス変更時は、Firebaseの情報を更新し、メールアドレス変更確認メールをユーザーに送信する
     - BASIC:
     - type: http
     - name: bearerAuth
     
     - parameter body: (body)  (optional)
     
     - returns: RequestBuilder<Void>
     */
    class func updateUserWithRequestBuilder(body: UserParam? = nil) -> RequestBuilder<Void> {
        let path = "/users"
        let URLString = SDApiClient.webApiPath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(["user[nickname]": body?.nickname])

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true )
    }
    
    /**
     SagxaDormoユーザー退会
     
     - parameter completion: completion handler to receive the data and the error objects
     */
    class func deleteUser(completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        deleteUserWithRequestBuilder().execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    /**
     SagxaDormoユーザー退会
     
     - parameter body: (body)  (optional)
     - returns: Observable<Void>
     */
    class func deleteUser() -> Observable<Void>  {
        return Observable.create { observer -> Disposable in
            deleteUser() { data, error in
                if let error = error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     SagxaDormoユーザー退会
     - DELETE /client/user
     - #### 処理概要 * SagxaDormoDBにユーザーが存在するかチェック(存在しなければ404を返す) * 対象ユーザーのチケットに未使用のチケットがないかチェック(あれば412を返す) * ベリトランス側のアカウントを削除する(AccountDeleteRequestDto) * Firebase側のユーザーを削除する * SagxaDormoDBからユーザを削除(論理削除)する
     - BASIC:
     - type: http
     - name: bearerAuth
     
     - returns: RequestBuilder<Void>
     */
    class func deleteUserWithRequestBuilder() -> RequestBuilder<Void> {
        let path = "/users"
        let URLString = SDApiClient.webApiPath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        
        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()
        
        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
}
