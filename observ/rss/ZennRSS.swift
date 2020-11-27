//
//  ZennRSS.swift
//  observ
//
//  Created by unkonow on 2020/11/22.
//

import Foundation


class ZennRSS: NSObject, XMLParserDelegate{
    private var finished: (([Article]) -> ())!
    private var articleList:[Article] = []
    private var nowTag:String = ""
    private var nowArticle: Article!

    func start(finished: @escaping (([Article]) -> ())){
        self.finished = finished
        let urlString = "https://zenn.dev/feed"
        
        guard let url = NSURL(string: urlString) else{
            return
        }
        
        // インターネット上のXMLを取得し、NSXMLParserに読み込む
        guard let parser = XMLParser(contentsOf: url as URL) else{
            return
        }
        parser.delegate = self;
        parser.parse()
    }
    
    // XML解析開始時に実行されるメソッド
    func parserDidStartDocument(_ parser: XMLParser) {
    }
    
    // 解析中に要素の開始タグがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
//        print("開始タグ:" + elementName)
        if elementName == "item"{
            nowArticle = Article()
            nowArticle.site = .zenn
        }
        nowTag = elementName
    }
    
    // 開始タグと終了タグでくくられたデータがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        /// FIXME
        if nowArticle == nil || string == "\n            "{
            return
        }
        switch nowTag {
        case "title":
            nowArticle.title = string
        case "link":
            nowArticle.url = string
        case "pubDate":
            /// FIXME
//            nowArticle.date =
            print()
        case "description":
            nowArticle.preview = string
        
        default: break
            
        }
    }
    
    /// MARK : end Tag
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        print("終了タグ:" + elementName)
        if elementName == "item"{
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

