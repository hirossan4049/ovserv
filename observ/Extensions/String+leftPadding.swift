//
//  String+leftPadding.swift
//  observ
//
//  Created by unkonow on 2020/12/04.
//

import Foundation

extension String {

      func leftPadding(toLength: Int, withPad: String) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeating:withPad, count: toLength - stringLength) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}  
