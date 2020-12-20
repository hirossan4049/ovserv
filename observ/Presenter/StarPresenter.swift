//
//  StarPresenter.swift
//  observ
//
//  Created by unkonow on 2020/12/20.
//

import Foundation

protocol StarPresenterInput {
    var numberOfFeeds: Int{get}
    func feed(forRow row: Int) -> Article?
    func viewDidLoad()
    func deleteStar(forRow row: Int)
    func reloadFeeds()
}

protocol StarPresenterOutput: AnyObject {
    func reload()
}

final class StarPresenter: StarPresenterInput {
    
    private(set) var feeds: [Article] = []
    
    private weak var view: StarPresenterOutput!
    private var model: StarModelInput
    
    init(view: StarPresenterOutput, model: StarModelInput) {
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

    
    func deleteStar(forRow row: Int) {
        self.model.removeStar(forRow: row)
        reloadFeeds()
    }
    
    func feedsGet(){
        self.feeds = model.fetchStars()
        print("====== VIEW RELOAD =======")
        view.reload()
        print("==========================")
    }
    
    
//    private func feedgetted(article:[Article]){
//        feeds.append(contentsOf: article)
//        feeds.sort {
//            (lhs: Article, rhs: Article) in
//            return lhs.date < rhs.date
//        }
//    }
    
    func reloadFeeds(){
        self.feeds = []
        self.feedsGet()
        print(feeds)
        view.reload()
    }
    
    
    
    func viewDidLoad() {
        self.reloadFeeds()
    }
    
}
