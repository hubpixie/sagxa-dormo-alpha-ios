//
//  SDLoginViewController.swift
//  SagxaDormo
//
//  Created by venus.janne on 2018/11/04.
//  Copyright © 2018 com.venuso-janne. All rights reserved.
//

import UIKit

class SDLoginViewController: SDViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        /*if segue.destination is SDImportantMattersViewController,
            let destVC: SDImportantMattersViewController = segue.destination as? SDImportantMattersViewController {
            let urlText: [String] = R.string.localeMisc.importantMattersWebviewUrl().components(separatedBy: ",")
            destVC.pageTitle = urlText[0]
            destVC.url = urlText[1]
        }
        else*/ if segue is SDPushFadeSegue, let mySegue = segue as? SDPushFadeSegue {
            mySegue.extraHandler = {[weak self] () in
                let destVC: SDProfiloRedaktiloViewController = R.storyboard.login.profiloRedaktiloVC()!
                self?.navigationController?.pushViewController(destVC, animated: true)
            }
        }
        
        super.prepare(for: segue, sender: sender)
    }
    
    
    @IBAction func unwindToParent(segue:UIStoryboardSegue) {
        
    }

}
