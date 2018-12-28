//
//  SDSplashScreenViewController.swift
//  SagxaDormo
//
//  Created by venus.janne on 2018/11/12.
//  Copyright © 2018 com.venuso-janne. All rights reserved.
//

import UIKit

class SDSplashScreenViewController: SDViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.performSegue(withIdentifier: R.segue.sdSplashScreenViewController.homeSegue.identifier, sender: self)
        self.startLoginVC()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func startLoginVC() {
        if let vc: UINavigationController = R.storyboard.login().instantiateInitialViewController() as? UINavigationController {
            vc.navigationBar.isHidden = true
            self.present(vc, animated: true, completion: nil)
        }
        
    }


}
