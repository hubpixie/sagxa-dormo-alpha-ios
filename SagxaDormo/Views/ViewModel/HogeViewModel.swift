//
//  HogeViewModel.swift
//  SagxaDormo
//
//  Created by venus.janne on 2018/11/17.
//  Copyright © 2018 com.venuso-janne. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HogeViewModel {
    
    let helloWorldSubject = PublishSubject<String>()
    
    func updateItem() {
        helloWorldSubject.onNext("Hello World!")
        helloWorldSubject.onNext("Hello World!!")
        helloWorldSubject.onNext("Hello World!!!")
    }
}
