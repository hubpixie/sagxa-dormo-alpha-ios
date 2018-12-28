//
//  SDProfiloRedaktiloViewController.swift
//  SagxaDormo
//
//  Created by venus.janne on 2018/11/04.
//  Copyright © 2018 com.venuso-janne. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SDProfiloRedaktiloViewController: SDViewController {

    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var nicknameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwdTextField: UITextField!
    
    @IBOutlet private weak var registerButton: UIButton! {
        didSet {
            self.registerButton.rx.tap.bind {
                self.registerButtonTap()
            }.disposed(by: self._disposeBag)
            
        }
    }

    private var _errCode: Int = 0
    private let _disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.myIndicator = UIActivityIndicatorView.setupIndicator(parentView: self.view)
//        self.myIndicator.adjustToPosition(frame: self.registerButton.frame)
//        self.myIndicator.startAnimatingEx(sender: nil)
        fetchAndShowDataToView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func fetchAndShowDataToView() {
        self.doGetUser { [unowned self] (successFlg, user) in
            self.nicknameTextField.text = ""
            self.emailTextField.text = ""
            self.passwdTextField.text = ""
            if successFlg {
                if let user = user {
                    self.nicknameTextField.text = user.nickname
                    self.emailTextField.text = user.email
                    self.passwdTextField.text = user.password
                    
                    self.registerButton.setTitle(R.string.localeMisc.profiloRedaktiloRegisterButtonUpdateTitle(), for: .normal)
                } else {
                    self.registerButton.setTitle(R.string.localeMisc.profiloRedaktiloRegisterButtonAddTitle(), for: .normal)
                }
            }
        }
    }
    
    private func registerButtonTap () {
        if let title = self.registerButton.title(for: .normal), title == R.string.localeMisc.profiloRedaktiloRegisterButtonUpdateTitle() {
            let param: UserParam = UserParam(nickname: self.nicknameTextField.text, email: self.emailTextField.text)
            self.doUpdateUser(param: param) { [unowned self] (successFlg) in
                if successFlg {
                    self.messageLabel.text = R.string.localeMisc.profiloRedaktiloRegisterButtonUpdateSuccessMessage()
                } else {
                    self.messageLabel.text = R.string.localeMisc.profiloRedaktiloRegisterButtonUpdateFailMessage(self._errCode)
                }
            }
        } else {
            let param: User = User(nickname: self.nicknameTextField.text!, email: self.emailTextField.text, password: self.passwdTextField.text)
            self.doRegisterUser(param: param) { [unowned self] (successFlg) in
                if successFlg {
                    self.messageLabel.text = R.string.localeMisc.profiloRedaktiloRegisterButtonAddSuccessMessage()
                } else {
                    self.messageLabel.text = R.string.localeMisc.profiloRedaktiloRegisterButtonAddFailMessage(self._errCode)
                }
            }

        }
    }
}


extension SDProfiloRedaktiloViewController {
    private func doGetUser(completionHandler : ((_ successFlg: Bool, _ user: User?) -> Void)?) {
        let param: UserParam = UserParam(nickname: "aaa", email: nil)
        
        SDApiClient.prepareSimpleHeaders()
        SDApiCore.getUser(body: param).subscribe(
            onNext: {user -> Void in
                completionHandler?(true, user)
            }, onError: { error  in
                if let error = SDApiClient.errorInfo(error: error) {
                    if error.0 == SDApiClient.HttpStatusCode.notFound.rawValue {
                        completionHandler?(true, nil)
                    } else {
                        print("error = \(String(data: error.1!, encoding: .utf8)!)")
                        completionHandler?(false, nil)
                    }
                }
            }).disposed(by: self._disposeBag)
    }
    
    private func doUpdateUser(param: UserParam, completionHandler : ((_ successFlg: Bool) -> Void)?) {
        
        SDApiClient.prepareSimpleHeaders()
        SDApiCore.updateUser(body: param).subscribe(
            onNext: {
                completionHandler?(true)
        }, onError: { [weak self] error  in
            if let error = SDApiClient.errorInfo(error: error) {
                print("error = \(String(data: error.1!, encoding: .utf8)!)")
                self?._errCode = error.0
                completionHandler?(false)
            }
        }).disposed(by: self._disposeBag)
    }

    private func doRegisterUser(param: User, completionHandler : ((_ successFlg: Bool) -> Void)?) {
        
        SDApiClient.prepareSimpleHeaders()
        SDApiCore.registerUser(body: param).subscribe(
            onNext: {
                completionHandler?(true)
        }, onError: { [weak self] error  in
            if let error = SDApiClient.errorInfo(error: error) {
                print("error = \(String(data: error.1!, encoding: .utf8)!)")
                self?._errCode = error.0
                completionHandler?(false)
            }
        }).disposed(by: self._disposeBag)
    }

}
