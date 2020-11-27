//
//  article.swift
//  observ
//
//  Created by unkonow on 2020/11/24.
//

import Foundation
import UIKit


public struct Article{
    var title: String = ""
    var preview: String = ""
    var url: String = ""
    var date: Date = Date()
    var image: Data? = nil
    var site: SiteType = .other
}

public enum SiteType{
    case zenn
    case qiita
    case other
    
    func lineColor() -> UIColor{
        switch self {
        case .zenn:
            return UIColor.blue
        default:
            return UIColor.gray
        }
    }
}
