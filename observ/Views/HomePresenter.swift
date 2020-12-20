//
//  HomePresenter.swift
//  observ
//
//  Created by unkonow on 2020/12/20.
//

import Foundation

protocol HomePresenterInput {
    var numberOfFeeds: Int{get}
    func feed(forRow row: Int) -> Article?
    func viewDidLoad()
    func addStar(forRow row: Int)
    func deleteStar(forRow row: Int)
    func reloadFeeds()
}

protocol HomePresenterOutput: AnyObject {
    func reload()
}

final class HomePresenter: HomePresenterInput {
    
    private(set) var feeds: [Article] = []
    
    private weak var view: HomePresenterOutput!
    private var model: StarModelInput
    
    init(view: HomePresenterOutput, model: StarModelInput) {
        self.view = view
        self.model = model
    }
    
    var numberOfFeeds: Int {
        return feeds.count
    }
    
    func feed(forRow row: Int) -> Article? {
        guard row < feeds.count else {
            return nil
        }
        return feeds[row]
    }
    
    func addStar(forRow row: Int) {
        self.model.addStar(article: (feeds[row]))
    }
    
    func deleteStar(forRow row: Int) {
        self.model.removeStar(forRow: self.model.getStarIndex(url: feeds[row].url)!)
    }
    
    func feedsGet(){
        let getArticles:[Article.SiteType] = [.zenn, .hatena]
        
        for article in getArticles{
            let rss = RSS(article)
            rss.start(finished: feedgetted)
        }
        print("====== VIEW RELOAD =======")
        view.reload()
        print("==========================")
    }
    
    
    private func feedgetted(article:[Article]){
        feeds.append(contentsOf: article)
        feeds.sort {
            (lhs: Article, rhs: Article) in
            return lhs.date < rhs.date
        }
    }
    
    func reloadFeeds(){
        self.feeds = []
        self.feedsGet()
        print(feeds)
        view.reload()
    }
    
    
    
    func viewDidLoad() {
        print("viewDidload Presenter")
        self.reloadFeeds()
//        self.view.updatefeeds()
    }
    
}
