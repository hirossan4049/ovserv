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
//        raise(1)

//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            //非同期で通信を行う
//            guard let data = data else {
//                return
//            }
//            do {
//                let object = try JSONSerialization.jsonObject(with: data, options: [])  // DataをJsonに変換
//                let parser = SwiftXMLParser()
//                let dic = parser.makeDic(data: data)
//                print("XML parserd!!!!!!!!!!!")
//                dump((dic as! NSDictionary).value(forKey: "rss.channel.item"))
//                dump(dic)
//                raise(1)
//
//            } catch let error {
//                print(error)
//            }
//        }
//        task.resume()
//
////         インターネット上のXMLを取得し、NSXMLParserに読み込む
//        guard let parser = XMLParser(contentsOf: url as URL) else {
//            return
//        }
//        parser.delegate = self;
//        parser.parse()
    }

    // XML解析開始時に実行されるメソッド
    func parserDidStartDocument(_ parser: XMLParser) {
    }

    // 解析中に要素の開始タグがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
//        print("開始タグ:" + elementName)
        if elementName == "item" {
            nowArticle = Article()
            nowArticle.site = self.type
        }
        nowTag = elementName
    }

    // 開始タグと終了タグでくくられたデータがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        /// FIXME
        if nowArticle == nil || string == "\n            " {
            return
        }
        if string == "\n" {
            return
        }

        switch nowTag {
        case "title":
            nowArticle.title += string
        case "link":
            nowArticle.url = string
        case "pubDate":
            nowArticle.date = DateUtils.dateFromString(string: string, format: "EEE, dd MMM yyyy HH:mm:ss Z")
        case "dc:date":
            nowArticle.date = ISO8601DateFormatter().date(from: string) ?? Date()

        case "description":
            nowArticle.preview += string

        default: break

        }
    }

    /// MARK : end Tag
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        print("終了タグ:" + elementName)
        if elementName == "item" {
            articleList.append(nowArticle)
        }
    }

    // paased End
    func parserDidEndDocument(_ parser: XMLParser) {
        finished(articleList)
    }

    // parse ERROR
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
    }
}
