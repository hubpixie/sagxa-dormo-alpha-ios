//
//  UIColor+ext.swift
//  SaĝaDormo
//
//  Created by venus.janne on 2018/08/28.
//  Copyright © 2018年 venus.janne. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func sdMainColor() -> UIColor {
        return UIColor(displayP3Red: 0xF3/0xFF, green: 0x98/0xFF, blue: 0x00, alpha: 1.0)
    }
    class func sdTextColor() -> UIColor {
        return UIColor(displayP3Red: 0x31/0xFF, green: 0x38/0xFF, blue: 0x3C/0xFF, alpha: 1.0)
    }
    class func sdBottomBorderColor() -> UIColor {
        return UIColor(displayP3Red: 0xA2/0xFF, green: 0xA6/0xFF, blue: 0xB3/0xFF, alpha: 1.0)
    }
    class func sdTitleColor() -> UIColor {
        return UIColor(displayP3Red: 0xA2/0xFF, green: 0xA6/0xFF, blue: 0xB3/0xFF, alpha: 1.0)
    }
    class func sdDisabledColor() -> UIColor {
        return UIColor(displayP3Red: 0xD8/0xFF, green: 0xD8/0xFF, blue: 0xD8/0xFF, alpha: 1.0)
    }
}
