//
//  StarViewController.swift
//  observ
//
//  Created by unkonow on 2020/12/20.
//

import UIKit

class StarViewController: UIViewController {
    
    var presenter: StarPresenterInput!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = StarPresenter(view: self, model: StarModel())
        presenter.viewDidLoad()

    }
    

}


extension StarViewController: StarPresenterOutput{
    func reload() {
        
    }
}
