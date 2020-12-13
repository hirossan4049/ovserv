//
//  Model.swift
//  observ
//
//  Created by unkonow on 2020/12/13.
//

import Foundation


class StarModel {
    private let userDefaluts = UserDefaults.standard
    private let ITEM_KEY = "Stars"
    
    public func fetchStars() -> [Article]?{
        let jsonArray:[String] = userDefaluts.array(forKey: ITEM_KEY) as! [String]
        var retArray:[Article] = []
        
        for item in jsonArray{
            let jsonData = item.data(using: .utf8)!
            retArray.append(try! JSONDecoder().decode(Article.self, from: jsonData))
        }
        return retArray
    }
    
    
    public func setStar(article: Article){
        var jsonArray:[String] = userDefaluts.array(forKey: ITEM_KEY) as! [String]
        let jsonData = try! JSONEncoder().encode(article)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        jsonArray.append(jsonString)
        userDefaluts.set(jsonArray, forKey: ITEM_KEY)
    }
    
    public func deleteStar(forRow row: Int) {
        var jsonArray:[String] = userDefaluts.array(forKey: ITEM_KEY) as! [String]
        jsonArray.remove(at: row)
        userDefaluts.set(jsonArray, forKey: ITEM_KEY)
    }
    
    
}
