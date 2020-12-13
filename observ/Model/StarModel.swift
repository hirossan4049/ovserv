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
        
        return userDefaluts.codable(forKey: ITEM_KEY) as? [Article]
//        let restoredPersons: [Article]? = UserDefaults.standard.codable(forKey: "person")

    }
    
    
    public func setStar(article: Article){
        
    }
    
    public func deleteStar(forRow row: Int) {
        
    }
    
    
}
