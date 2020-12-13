//
//  article.swift
//  observ
//
//  Created by unkonow on 2020/11/24.
//

import Foundation
import UIKit


public struct Article: Codable{
    var title: String = ""
    var preview: String = ""
    var url: String = ""
    var date: Date = Date()
    var image: Data? = nil
    var site: SiteType = .other
    
    enum SiteType: String, Codable{
        case zenn
        case qiita
        case note
        case hatena
        case other
        
    }

}

extension Article.SiteType{
    func lineColor() -> UIColor{
        switch self {
        case .zenn:
            return UIColor(hex: "5086FF")
        case .note:
            return UIColor(hex: "00CDB4")
        case .hatena:
            return UIColor(hex: "009AD2")
        default:
            return UIColor.gray
        }
    }

    func getUrl() -> String{
        switch self {
        case .zenn:
            return "https://zenn.dev/feed"
        case .hatena:
            return "https://b.hatena.ne.jp/hotentry/it.rss"
        default:
            return ""
        }
    }

    func getImage(size: CGSize) -> UIImage{
        switch self {
        case .zenn:
            let img = UIImage(named: "zenn-light")!
//            return img.resize(size: size)!
            return img
        case .hatena:
            return UIImage(named: "hatebu-light")!
        default:
            return UIImage(named: "zenn-light")!
        }
    }
}

//public enum SiteType{
//    case zenn
//    case qiita
//    case note
//    case hatena
//    case other
//
//    func lineColor() -> UIColor{
//        switch self {
//        case .zenn:
//            return UIColor(hex: "5086FF")
//        case .note:
//            return UIColor(hex: "00CDB4")
//        case .hatena:
//            return UIColor(hex: "009AD2")
//        default:
//            return UIColor.gray
//        }
//    }
//
//    func getUrl() -> String{
//        switch self {
//        case .zenn:
//            return "https://zenn.dev/feed"
//        case .hatena:
//            return "https://b.hatena.ne.jp/hotentry/it.rss"
//        default:
//            return ""
//        }
//    }
//
//    func getImage(size: CGSize) -> UIImage{
//        switch self {
//        case .zenn:
//            let img = UIImage(named: "zenn-light")!
////            return img.resize(size: size)!
//            return img
//        case .hatena:
//            return UIImage(named: "hatebu-light")!
//        default:
//            return UIImage(named: "zenn-light")!
//        }
//    }
//}
