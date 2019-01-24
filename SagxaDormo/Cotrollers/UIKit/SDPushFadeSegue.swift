//
//  CmyPushFadeSegue.swift
//  MaldikaBileto
//
//  Created by x.yang on 2018/07/05.
//  Copyright © 2018年 x.yang. All rights reserved.
//

import UIKit

class SDPushFadeSegue: UIStoryboardSegue {
    var extraHandler: (()->())?
    override func perform() {
        UIView.transition(
            with: (source.navigationController?.view)!,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                () -> Void in
                if let extraHandler = self.extraHandler {
                    extraHandler()
                }
        },
            completion: nil)
    }
    
}
