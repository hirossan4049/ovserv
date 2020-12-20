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
    private var starModel: StarModel!
    
    init() {
        starModel = StarModel()
        
    }
    
    func feedsGet(){
        let getArticles:[Article.SiteType] = [.zenn, .hatena]
        
        for article in getArticles{
            let rss = RSS(article)
            rss.start(finished: feedgetted)
        }
        self.reload?()
    }
    
    func reloadFeeds(){
        self.feeds = []
        self.feedsGet()
    }
    
    func add_star(forRow row: Int) {
        let article:Article = feeds[row]
        if starModel.getStarIndex(url: article.url) == nil{
            return
        }
//        starModel.setStar(article: article)
    }
    func remove_star(forRow row: Int){
        let index = starModel.getStarIndex(url: feeds[row].url)
        starModel.removeStar(forRow: index!)
    }
    
    private func feedgetted(article:[Article]){
        feeds.append(contentsOf: article)
        feeds.sort {
            (lhs: Article, rhs: Article) in
            return lhs.date < rhs.date
        }
    }
}
