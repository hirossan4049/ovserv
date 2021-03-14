//
//  Model.swift
//  observ
//
//  Created by unkonow on 2020/12/13.
//

import Foundation

protocol StarModelInput {
    func fetchStars() -> [Article]
    func addStar(article: Article)
    func removeStar(forRow: Int)
    func getStarIndex(url: String) -> Int?
}

final class StarModel:StarModelInput {
    private let userDefaluts = UserDefaults.standard
    private let ITEM_KEY = "Stars"
    
    func fetchStars() -> [Article]{
        let jsonArray:[String] = userDefaluts.array(forKey: ITEM_KEY) as? [String] ?? []
        var retArray:[Article] = []
        
        for item in jsonArray{
            let jsonData = item.data(using: .utf8)!
            retArray.append(try! JSONDecoder().decode(Article.self, from: jsonData))
        }
        return retArray
    }
    
    
    func addStar(article: Article){
        var jsonArray:[String] = userDefaluts.array(forKey: ITEM_KEY) as? [String] ?? []
        let jsonData = try! JSONEncoder().encode(article)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        jsonArray.append(jsonString)
        userDefaluts.set(jsonArray, forKey: ITEM_KEY)
    }
    
    func removeStar(forRow row: Int) {
        var jsonArray:[String] = userDefaluts.array(forKey: ITEM_KEY) as! [String]
        jsonArray.remove(at: row)
        userDefaluts.set(jsonArray, forKey: ITEM_KEY)
    }
    
    
    func getStarIndex(url: String) -> Int?{
        let stars = fetchStars()
        for (index, item) in stars.enumerated(){
            if item.url == url{
                return index
            }
        }
        return nil
    }
    
//    public func getStarIndex(title: String){
//
//    }
    
    
}
