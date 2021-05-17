//
//  HomePresenter.swift
//  observ
//
//  Created by unkonow on 2020/12/20.
//

import Foundation

protocol HomePresenterInput {
    var numberOfFeeds: Int { get }
    func feed(forRow row: Int) -> Article?
    func articles(site: Article.SiteType) -> [Article]
    func viewDidLoad()
    func addStar(forRow row: Int, articleType: Article.SiteType)
    func deleteStar(forRow row: Int, articleType: Article.SiteType)
    func reloadFeeds()
}

protocol HomePresenterOutput: AnyObject {
    func reload()
}

final class HomePresenter: HomePresenterInput {

    private(set) var feeds: [Article] = []
    private(set) var articles: Dictionary<Article.SiteType, [Article]> = [:]

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

    func addStar(forRow row: Int, articleType: Article.SiteType) {
        print("Add STAR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        self.model.addStar(article: articles(site: articleType)[row])
    }

    func deleteStar(forRow row: Int, articleType: Article.SiteType) {
        self.model.removeStar(forRow: self.model.getStarIndex(url: articles(site: articleType)[row].url)!)
    }

    func feedsGet() {
        let getArticles: [Article.SiteType] = [.zenn, .hatena]

        for article in getArticles {
            let rss = RSS(article)
            rss.start(finished: feedgetted)
        }
        print("====== VIEW RELOAD =======")
        view.reload()
        print("==========================")
    }

    func articles(site: Article.SiteType) -> [Article] {
        return articles[site] ?? []
    }


    private func feedgetted(article: [Article]) {
        feeds.append(contentsOf: article)
        articles.updateValue(article, forKey: article[0].site)
        feeds.sort {
            (lhs: Article, rhs: Article) in
            return lhs.date < rhs.date
        }
    }

    func reloadFeeds() {
        self.feeds = []
        self.feedsGet()
        view.reload()
    }


    func viewDidLoad() {
        print("viewDidload Presenter")
        self.reloadFeeds()
//        self.view.updatefeeds()
    }

}
