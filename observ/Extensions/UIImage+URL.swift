//
//  UIImage+URL.swift
//  observ
//
//  Created by craptone on 2021/05/17.
//

import UIKit

extension UIImage {
    public convenience init(url: String) {
        guard let url = URL(string: url) else{
            self.init()
            return
        }
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
