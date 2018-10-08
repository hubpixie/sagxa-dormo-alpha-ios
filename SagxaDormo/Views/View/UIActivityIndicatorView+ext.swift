//
//  UIActivityIndicatorView+ext.swift
//  SaĝaDormo
//
//  Created by x.yang on 2018/08/08.
//  Copyright © 2018年 x.yang. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {

    class func setupIndicator(parentView: UIView) -> UIActivityIndicatorView {
        let loadingView: UIView = UIView()

        loadingView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loadingView.center = parentView.center
        loadingView.backgroundColor = UIColor(displayP3Red: 0x00, green: 0x00, blue: 0x00, alpha: 0.4)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loadingView.isHidden = true
        
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicator.center = CGPoint(x: loadingView.frame.size.width / 2,
                                   y: loadingView.frame.size.height / 2)
        indicator.style = .whiteLarge
        indicator.hidesWhenStopped = true

        loadingView.addSubview(indicator)
        parentView.addSubview(loadingView)
        parentView.bringSubviewToFront(loadingView)
        
        return indicator
    }

    func startAnimatingEx(sender: Any?) {
        if let sender = sender as? UIButton {
            sender.isEnabled = false
        } else if let sender = sender as? UISwitch {
            sender.isEnabled = false
        }
        if let subViews = self.superview?.subviews {
            for v in subViews {
                if v is UITextField && v.isUserInteractionEnabled {
                    v.isUserInteractionEnabled = false
                }
            }
        }

        self.superview?.isHidden = false
        self.startAnimating()
        if !UIApplication.shared.isIgnoringInteractionEvents  {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }

    func stopAnimatingEx(sender: Any?) {
        if let sender = sender as? UIButton {
            sender.isEnabled = true
        } else if let sender = sender as? UISwitch {
            sender.isEnabled = true
        }
        if let subViews = self.superview?.subviews {
            for v in subViews {
                if v is UITextField && !v.isUserInteractionEnabled {
                    v.isUserInteractionEnabled = true
                }
            }
        }

        self.superview?.isHidden = true
        self.stopAnimating()
        if UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}
