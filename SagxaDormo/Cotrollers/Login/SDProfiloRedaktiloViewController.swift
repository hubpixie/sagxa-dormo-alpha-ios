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

    private let _fooViewModel = FooViewModel()
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
        self._fooViewModel.doGetUser { [unowned self] (status, user) in
            self.nicknameTextField.text = ""
            self.emailTextField.text = ""
            self.passwdTextField.text = ""
            if status == 0 {
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
            self._fooViewModel.doUpdateUser(param: param) { [unowned self] (successFlg) in
                if successFlg {
                    self.messageLabel.text = R.string.localeMisc.profiloRedaktiloRegisterButtonUpdateSuccessMessage()
                } else {
                    self.messageLabel.text = R.string.localeMisc.profiloRedaktiloRegisterButtonUpdateFailMessage(-111)
                }
            }
        } else {
            let param: User = User(nickname: self.nicknameTextField.text!, email: self.emailTextField.text, password: self.passwdTextField.text)
            self._fooViewModel.doRegisterUser(param: param) { [unowned self] (successFlg) in
                if successFlg {
                    self.messageLabel.text = R.string.localeMisc.profiloRedaktiloRegisterButtonAddSuccessMessage()
                } else {
                    self.messageLabel.text = R.string.localeMisc.profiloRedaktiloRegisterButtonAddFailMessage(-222)
                }
            }

        }
    }
}


extension SDProfiloRedaktiloViewController {

}
