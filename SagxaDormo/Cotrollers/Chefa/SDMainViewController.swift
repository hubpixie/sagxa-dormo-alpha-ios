//
//  ViewController.swift
//  SaĝaDormo
//
//  Created by venus.janne on 2018/10/08.
//  Copyright © 2018 com.venuso-janne. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SDMainViewController: SDViewController {
    private let disposeBag = DisposeBag()
    
    var viewModel: HogeViewModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.startLoginVC()
        

        viewModel = HogeViewModel()
        
        viewModel.helloWorldSubject
            .subscribe(onNext: { [weak self] value in
                print("value = \(value)")
            })
            .disposed(by: disposeBag)
        
        viewModel.updateItem()
    }
}


