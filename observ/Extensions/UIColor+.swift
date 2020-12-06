//
//  Cl.lr.swift
//  observ
//
//  Created by unkonow on 2020/12/04.
//

import Foundation
import UIKit

extension UIColor{
    
    static let backgroundColor = ld(ch("FFFFFF"), ch("000000"))




    private static func ch(_ hexString: String) -> UIColor {
        return UIColor(hex: hexString)
    }
    
    private static func ld(_ light: UIColor,_ dark: UIColor) -> UIColor{
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                    dark:
                    light
                }
        }else{
            return light
        }
    }
}
