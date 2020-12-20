//
//  HomeViewController.swift
//  observ
//
//  Created by unkonow on 2020/12/10.
//

import UIKit
import SafariServices


class HomeViewController: UIViewController {
//    private var conductor: HomeConductor!
    
    @IBOutlet weak var feedsTableView: UITableView!
    fileprivate let refreshCtl = UIRefreshControl()
    
    private var presenter: HomePresenterInput!
    
    func inject (presenter: HomePresenterInput) {
        print("inject", presenter)
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
//        conductor = HomeConductor()
//        conductor.reload = self.reload
        
        feedsTableView.dataSource = self
        feedsTableView.delegate = self
        feedsTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        feedsTableView.separatorStyle = .none
        feedsTableView.refreshControl = refreshCtl
        
        refreshCtl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        
//        conductor.feedsGet()
                
    }
    
    @objc func refresh(sender: UIRefreshControl){
//        conductor.reloadFeeds()
        self.presenter.reloadFeeds()
    }
    

    
}

extension HomeViewController: HomePresenterOutput{
    func reload(){
        refreshCtl.endRefreshing()
        feedsTableView.reloadData()
    }
    
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfFeeds
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleTableViewCell
        let article = presenter.feed(forRow: indexPath.row)!
        cell.titleLabel.text = article.title
        cell.descriptionLabel.text = article.preview
//        cell.lineView.backgroundColor = article.lineColor()
        cell.starClickFn = self.starClicked
        cell.tag = indexPath.row
        
        cell.logoView?.image = article.site.getImage(size: cell.logoSize)
        
        
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
//        let safariVC = SFSafariViewController(url: NSURL(string: conductor.feeds[indexPath.row].url)! as URL)
        let safariVC = SFSafariViewController(url: NSURL(string: presenter.feed(forRow: indexPath.row)!.url)! as URL)
        present(safariVC, animated: true, completion: nil)
    }
    
    func starClicked(_ tag: Int, _ isStar: Bool){
        print(tag, isStar)
        if isStar{
            presenter.addStar(forRow: tag)
        }else{
            presenter.deleteStar(forRow: tag)
        }
    }
    
    
}
