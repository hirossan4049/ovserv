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
    
    
    func feedsGet(){
        let zennrss = ZennRSS()
        zennrss.start(finished: feedgetted)
        let rss = RSS(.hatena)
        rss.start(finished: feedgetted)
        self.reload?()
    }
    
    func reloadFeeds(){
        self.feeds = []
        self.feedsGet()
    }
    
    private func feedgetted(article:[Article]){
        feeds.append(contentsOf: article)
        feeds.sort {
            (lhs: Article, rhs: Article) in
            return lhs.date < rhs.date
        }
    }
}
