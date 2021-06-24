//
//  RSS.swift
//  observ
//
//  Created by unkonow on 2020/12/06.
//

import Foundation
import FeedKit
import OpenGraph


class RSS: NSObject, XMLParserDelegate {
    private var finished: (([Article]) -> ())!
    private var articleList: [Article] = []
    private var nowTag: String = ""
    private var nowArticle: Article!
    public var type: Article.SiteType = .other

    init(_ type: Article.SiteType) {
        self.type = type
    }

    func start(finished: @escaping (([Article]) -> ())) {
        self.finished = finished

//        guard let url = NSURL(string: self.type.getUrl()) else{
//            return
//        }

        let url = URL(string: self.type.getUrl())!  //URLを生成
//        var request = URLRequest(url: url)               //Requestを生成

        let parser = FeedParser(URL: url) // or FeedParser(data: data) or FeedParser(xmlStream: stream)
        let result = parser.parse()

        switch result {
        case .success(let feed):

            // Grab the parsed feed directly as an optional rss, atom or json feed object
//            feed.rssFeed

            // Or alternatively...
            switch feed {
            case let .atom(feed):       // Atom Syndication Format Feed Model
//                print(feed.entries)
                for item in feed.entries!{
//                    print("feed entries for loop", item)
                    var article = Article()
                    article.title = item.title ?? ""
                    article.url = item.links!.first?.attributes?.href ?? "https://google.com"
                    article.preview = item.summary?.value ?? ""
                    article.date = item.published ?? Date()
                    article.site = self.type
            
                    articleList.append(article)
                }
            case let .rss(feed):        // Really Simple Syndication Feed Model
//                print(feed.items)
                for item in feed.items!{
//                    print("feed entries for loop", item)
                    var article = Article()
                    article.title = item.title ?? ""
                    article.url = item.link ?? "https://google.com"
                    article.preview = item.description ?? ""
                    article.date = item.pubDate ?? Date()
                    article.site = self.type
                    
//                    OpenGraph.fetch(url: URL(string: item.link!)!) { result in
//                        switch result {
//                        case .success(let og):
//                            print(og[.image])
//                            article.imageURL = og[.image] ?? "https://cdn-ssl-devio-img.classmethod.jp/wp-content/uploads/2014/05/how-to-make-adjustable-cell_20.png"
//                            
//                        case .failure(let error):
//                            print(error)
//                        }
//                    }
                    articleList.append(article)
                }
            case let .json(feed):       // JSON Feed Model
                print("ERROR!!!!!!!!!!!!!", feed.items)
            }

        case .failure(let error):
            print(error)
        }

        print(result)
        finished(articleList)
    }

}
