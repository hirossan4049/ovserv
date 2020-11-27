//
//  HomeConductor.swift
//  observ
//
//  Created by unkonow on 2020/11/27.
//

import Foundation

class HomeConductor{
    public var feeds:[Article] = []
    public var reload:(() -> ())?
    
    
    func feedGets(){
        let zennrss = ZennRSS()
        zennrss.start(finished: feedgetted)
        self.reload?()
    }
    
    private func feedgetted(article:[Article]){
        feeds.append(contentsOf: article)
    }
}
