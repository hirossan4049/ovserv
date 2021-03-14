//
//  RSS.swift
//  observ
//
//  Created by unkonow on 2020/12/06.
//

import Foundation


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
        var request = URLRequest(url: url)               //Requestを生成
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //非同期で通信を行う
            guard let data = data else {
                return
            }
            do {
//                let object = try JSONSerialization.jsonObject(with: data, options: [])  // DataをJsonに変換
                let parser = SwiftXMLParser()
                let dic = parser.makeDic(data: data)
                print("XML parserd!!!!!!!!!!!")
                dump((dic as! NSDictionary).value(forKey: "rss.channel.item"))
                dump(dic)
                raise(1)

            } catch let error {
                print(error)
            }
        }
        task.resume()

        // インターネット上のXMLを取得し、NSXMLParserに読み込む
        guard let parser = XMLParser(contentsOf: url as URL) else {
            return
        }
        parser.delegate = self;
        parser.parse()
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

//articleitems = "channel.item[0].title"
//Optional(["rss": {
//    "_XMLAttributes" = {
//        version = "2.0";
//        "xmlns:atom" = "http://www.w3.org/2005/Atom";
//        "xmlns:content" = "http://purl.org/rss/1.0/modules/content/";
//        "xmlns:dc" = "http://purl.org/dc/elements/1.1/";
//    };
//    channel = {
//        item = (
//                {
//                    "dc:creator" = catnose;
//                    description = "\U3081\U3061\U3083\U304f\U3061\U3083\U82e6\U3057\U3093\U3060\U7d50\U679c\U3001CSS\U30921\U884c\U66f8\U304d\U8db3\U3059\U3060\U3051\U3067\U89e3\U6c7a\U3057\U307e\U3057\U305f\U3002\n\n      \n        \U7d50\U8ad6\n        textarea { overflow-anchor: none; }\n\n\n      \n      \n Enter\U30ad\U30fc\U3092\U62bc\U3059\U3068textarea\U306e\U30b9\U30af\U30ed\U30fc\U30eb\U4f4d\U7f6e\U304c\U305a\U308c\U308b\U554f\U984c\n\U3075\U3068Zenn\U306e\U30b9\U30af\U30e9\U30c3\U30d7\U306e\U30a8\U30c7\U30a3\U30bf\U30fc\U3067\U3001Enter\U30ad\U30fc\U3092\U62bc\U3059\U3068\U3001\U30ab\U30fc\U30bd\U30eb\U306e\U3042\U305f\U3063\U3066\U3044\U308b\U90e8\U5206\U306e\U30b9\U30af\U30ed\U30fc\U30eb\U4f4d\U7f6e\U304c\U30ac\U30bf\U3063\U3068\U305a\U308c\U308b\U554f\U984c\U304c\U767a\U751f\U3059\U308b\U3053\U3068\U306b\U6c17\U3065\U304d\U307e\U3057\U305f\U3002\n\nEnter\U30ad\U30fc\U3092\U62bc\U3057\U305f\U30bf\U30a4\U30df\U30f3\U30b0\U3067\U30ab\U30fc\U30bd\U30eb\U306e\U4f4d\U7f6e\U304cviewport\U306e\U5148\U982d\U3082\U3057\U304f\U306f\U672b\U5c3e\U306b\U30b8\U30e3\U30f3\U30d7\U3059\U308b\U3088\U3046\U306a\U30a4\U30e1\U30fc\U30b8\U3067\U3059\U3002\n\U3082\U3046\U5c11\U3057\U8abf\U3079\U3066\U307f\U308b...";
//                    enclosure = {
//                        "_XMLAttributes" = {
//                            length = 0;
//                            type = "image/png";
//                            url = "https://res.cloudinary.com/dlhzyuewr/image/upload/s--M8gcsCIn--/co_rgb:222%2Cg_south_west%2Cl_text:notosansjp-medium.otf_37_bold:catnose%2Cx_203%2Cy_98/c_fit%2Cco_rgb:222%2Cg_north_west%2Cl_text:notosansjp-medium.otf_65_bold:%25E3%2580%2590Chrome%25E3%2580%2591textarea%25E3%2581%25AE%25E6%2594%25B9%25E8%25A1%258C%25E6%2599%2582%25E3%2581%25AB%25E3%2582%25AB%25E3%2583%25BC%25E3%2582%25BD%25E3%2583%25AB%25E4%25BD%258D%25E7%25BD%25AE%25E3%2581%258C%25E3%2582%25AC%25E3%2582%25BF%25E3%2581%25A3%25E3%2581%25A8%25E3%2581%259A%25E3%2582%258C%25E3%2582%258B%25E5%2595%258F%25E9%25A1%258C%25E3%2581%25AE%25E5%25AF%25BE%25E5%2587%25A6%25E6%25B3%2595%2Cw_1010%2Cx_90%2Cy_100/g_south_west%2Ch_90%2Cl_fetch:aHR0cHM6Ly9zdG9yYWdlLmdvb2dsZWFwaXMuY29tL3plbm4tdXNlci11cGxvYWQvYXZhdGFyL2ljb25fYTc1MDQyNjg1OS5qcGVn%2Cr_max%2Cw_90%2Cx_87%2Cy_72/v1609308637/og/new_txlqub.png";
//                        };
//                    };
//                    guid = {
//                        SwiftXMLParserTextKey = "https://zenn.dev/catnose99/articles/e0d42812c7588c";
//                        "_XMLAttributes" = {
//                            isPermaLink = true;
//                        };
//                    };
//                    link = "https://zenn.dev/catnose99/articles/e0d42812c7588c";
//                    pubDate = "Sat, 20 Feb 2021 08:02:16 GMT";
//                    title = "\U3010Chrome\U3011textarea\U306e\U6539\U884c\U6642\U306b\U30ab\U30fc\U30bd\U30eb\U4f4d\U7f6e\U304c\U30ac\U30bf\U3063\U3068\U305a\U308c\U308b\U554f\U984c\U306e\U5bfe\U51e6\U6cd5";
//                },
//                {
//                    "dc:creator" = Shogo;
//                    description = "* \U5168\U3066\U306e\U610f\U898b\U306f\U50d5\U500b\U4eba\U306e\U3082\U306e\U3067\U3001\U7279\U5b9a\U306e\U56e3\U4f53\U3068\U306f\U95a2\U4fc2\U3042\U308a\U307e\U305b\U3093\n*\U3053\U306e\U8a18\U4e8b\U306f\U305f\U3060\U50d5\U304c\U8fbf\U3063\U305f\U9053\U3092\U8a18\U3057\U3066\U3044\U308b\U3060\U3051\U3067\U3001\U6c7a\U3057\U3066\U300c\U30a2\U30e1\U30ea\U30ab\U3067\U30a8\U30f3\U30b8\U30cb\U30a2\U306b\U306a\U308b\U65b9\U6cd5\U300d\U3092\U8a18\U3057\U305f\U3082\U306e\U3067\U306f\U3042\U308a\U307e\U305b\U3093\U3002\U305d\U306e\U76ee\U7684\U3067\U53c2\U8003\U306b\U306a\U308b\U90e8\U5206\U3082\U3042\U308b\U304b\U3082\U77e5\U308c\U307e\U305b\U3093\U304c\U3001\U305d\U308c\U3092\U76ee\U7684\U3067\U8aad\U3080\U3068\U671f\U5f85\U3092\U88cf\U5207\U3089\U308c\U308b\U3068\U601d\U3044\U307e\U3059\Ud83d\Ude2c\n\U5927\U307e\U304b\U306a\U6d41\U308c\U306f\U3001\U4ee5\U4e0b\U306e\U901a\U308a\U306b\U306a\U308a\U307e\U3059\Uff1a\n\n\U4e2d\U9ad8\U82f1\U8a9e\U8d64\U70b9\Uff08\U82f1\U8a9e\U5927\U5acc\U3044\Uff09\n\U30a2\U30e1\U30ea\U30ab\U7559\U5b66\nBank of America\U3067\U30a4\U30f3\U30bf\U30fc\U30f3\U3001\U5f8c\U306b\U6b63\U793e\U54e1\U63a1\U7528\n\Uff12\U5e74\U3054\U3068\U306b\U8cb7\U53ce\U3055\U308c\U3066\U3044\U304f\n\U521d\U3081\U3066\U306e\U30ea\U30b9\U30c8\U30e9\U3001\U3057\U304b\U3082\U30b3\U30ed\U30ca\U798d\U306e\U4e2d\U3067\nGoldman Sachs\U306b\U5c31\U8077\n\n\n \U4e2d\U5b66\U3001\U521d\U3081\U3066\U306e\U82f1\U8a9e\U306e\U6388\U696d\n\U4e2d\U5b66\U306e\U3068\U304d\U306b\U3001\U59cb\U3081\U3066\U6388\U696d\U3067\U82f1\U8a9e\U3092\U52c9\U5f37\U3059\U308b\U3053\U3068...";
//                    enclosure = {
//                        "_XMLAttributes" = {
//                            length = 0;
//                            type = "image/png";
//                            url = "https://res.cloudinary.com/dlhzyuewr/image/upload/s--jZrYXKcf--/co_rgb:222%2Cg_south_west%2Cl_text:notosansjp-medium.otf_37_bold:Shogo%2Cx_203%2Cy_98/c_fit%2Cco_rgb:222%2Cg_north_west%2Cl_text:notosansjp-medium.otf_70_bold:%25E8%258B%25B1%25E8%25AA%259E%25E8%25B5%25A4%25E7%2582%25B9%25E3%2581%25AE%25E7%2594%25B0%25E8%2588%258E%25E8%2580%2585%25E3%2581%258C%25E3%2580%2581%25E7%25B1%25B3Goldman%2520Sachs%25E3%2581%25A7%25E3%2582%25A8%25E3%2583%25B3%25E3%2582%25B8%25E3%2583%258B%25E3%2582%25A2%25E3%2581%25AB%25E3%2581%25AA%25E3%2582%258B%25E3%2581%25BE%25E3%2581%25A7%2Cw_1010%2Cx_90%2Cy_100/g_south_west%2Ch_90%2Cl_fetch:aHR0cHM6Ly9zdG9yYWdlLmdvb2dsZWFwaXMuY29tL3plbm4tdXNlci11cGxvYWQvYXZhdGFyL2ljb25fZTI2OGI0Mzg4MS5qcGVn%2Cr_max%2Cw_90%2Cx_87%2Cy_72/v1609308637/og/new_txlqub.png";
//                        };
//                    };
//                    guid = {
//                        SwiftXMLParserTextKey = "https://zenn.dev/shogo_wada/articles/f7366d750e4db2";
//                        "_XMLAttributes" = {
//                            isPermaLink = true;
//                        };
//                    };
//                    link = "https://zenn.dev/shogo_wada/articles/f7366d750e4db2";
//                    pubDate = "Sat, 20 Feb 2021 13:58:00 GMT";
//                    title = "\U82f1\U8a9e\U8d64\U70b9\U306e\U7530\U820e\U8005\U304c\U3001\U7c73Goldman Sachs\U3067\U30a8\U30f3\U30b8\U30cb\U30a2\U306b\U306a\U308b\U307e\U3067";
//                },
//                {
//                    "dc:creator" = seya;
//                    description = "\U3053\U306e\U8a18\U4e8b\U306e\U30b7\U30ea\U30fc\U30ba\U3067\U306f\U79c1\U304c\U30d5\U30ed\U30f3\U30c8\U30a8\U30f3\U30c9\U306b\U95a2\U3057\U3066\U601d\U3063\U3066\U3044\U308b\U3053\U3068\U3092\U5f92\U7136\U306b\U8a9e\U3063\U3066\U3044\U3053\U3046\U3068\U601d\U3044\U307e\U3059\U3002\n\U3061\U3087\U3063\U3068\U9577\U304f\U306a\U308a\U904e\U304e\U305d\U3046\U306a\U306e\U3067\U4ee5\U4e0b\U306e4\U3064\U306b\U5206\U3051\U3066\U66f8\U3044\U3066\U3044\U3053\U3046\U3068\U601d\U3044\U307e\U3059\U3002\n\n 1.\U6982\U5ff5\U7684\U306a\U8a71 - \U30d5\U30ed\U30f3\U30c8\U30a8\U30f3\U30c9\U30a2\U30d7\U30ea\U30b1\U30fc\U30b7\U30e7\U30f3\U3068\U306f\U4f55\U3067\U3067\U304d\U3066\U3044\U308b\U304b\n\U30d5\U30ed\U30f3\U30c8\U30a8\U30f3\U30c9\U30a2\U30d7\U30ea\U30b1\U30fc\U30b7\U30e7\U30f3\U3092\U4fdd\U5b88\U6027\U3068\U30e6\U30fc\U30b6\U3078\U306e\U4fa1\U5024\U63d0\U4f9b\U3092\U4e21\U7acb\U3057\U3066\U958b\U767a\U3059\U308b\U305f\U3081\U306b\U3001\U30a2\U30d7\U30ea\U30b1\U30fc\U30b7\U30e7\U30f3\U3092\U62bd\U8c61\U5316\U3057\U3066\U3001\U3044\U3044\U611f\U3058\U306e\U8a2d\U8a08\U3092\U3059\U308b\U5fc5\U8981\U304c\U3042\U308a\U307e\U3059\U3002\n\U3053\U308c\U306e\U571f\U53f0\U4f5c\U308a\U3092\U3059\U308b\U305f\U3081\U306b\U6982\U5ff5\U3068\U3057\U3066\U30d5\U30ed\U30f3\U30c8\U30a8\U30f3\U30c9\U30a2\U30d7\U30ea\U30b1\U30fc\U30b7\U30e7\U30f3\U3068\U306f\U4f55\U306a\U306e\U304b\U3092\U8003\U3048\U3066\U3044\U304d\U307e\U3059\U3002\n\n 2.\U6280\U8853\U7684\U306a\U8a71 - \U30d5\U30ed\U30f3\U30c8\U30a8\U30f3\U30c9\U30a2\U30d7\U30ea\U30b1\U30fc\U30b7\U30e7\U30f3\U306f\U3069\U306e\U3088\U3046\U306b\U5b9f\U884c\U3055\U308c\U308b\U304b\nWeb\U30d5\U30ed\U30f3\U30c8\U30a8\U30f3...";
//                    enclosure = {
//                        "_XMLAttributes" = {
//                            length = 0;
//                            type = "image/png";
//                            url = "https://res.cloudinary.com/dlhzyuewr/image/upload/s--SdqyRUoB--/co_rgb:222%2Cg_south_west%2Cl_text:notosansjp-medium.otf_37_bold:seya%2Cx_203%2Cy_98/c_fit%2Cco_rgb:222%2Cg_north_west%2Cl_text:notosansjp-medium.otf_80_bold:%25E3%2583%2595%25E3%2583%25AD%25E3%2583%25B3%25E3%2583%2588%25E3%2582%25A8%25E3%2583%25B3%25E3%2583%2589%25E3%2582%2592%25E8%2580%2583%25E3%2581%2588%25E3%2582%258B%2520%25E3%2580%259C%25E6%25A6%2582%25E5%25BF%25B5%25E7%25B7%25A8%25E3%2580%259C%2Cw_1010%2Cx_90%2Cy_100/g_south_west%2Ch_90%2Cl_fetch:aHR0cHM6Ly9zdG9yYWdlLmdvb2dsZWFwaXMuY29tL3plbm4tdXNlci11cGxvYWQvYXZhdGFyL2ljb25fZDM4ODhiMzQzMS5qcGVn%2Cr_max%2Cw_90%2Cx_87%2Cy_72/v1609308637/og/new_txlqub.png";
//                        };
//                    };
//                    guid = {
//                        SwiftXMLParserTextKey = "https://zenn.dev/seya/articles/266f7a46b424ff";
//                        "_XMLAttributes" = {
//                            isPermaLink = true;
//                        };
//                    };
//                    link = "https://zenn.dev/seya/articles/266f7a46b424ff";
//                    pubDate = "Sat, 20 Feb 2021 11:11:28 GMT";
//                    title = "\U30d5\U30ed\U30f3\U30c8\U30a8\U30f3\U30c9\U3092\U8003\U3048\U308b \U301c\U6982\U5ff5\U7de8\U301c";
//                },
//                {
//                    "dc:creator" = karamage;
