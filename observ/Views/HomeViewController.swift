//
//  HomeViewController.swift
//  observ
//
//  Created by unkonow on 2020/12/10.
//

import UIKit
import SafariServices


class HomeViewController: UIViewController {
    private var conductor: HomeConductor!
    
    @IBOutlet weak var feedsTableView: UITableView!
    fileprivate let refreshCtl = UIRefreshControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        conductor = HomeConductor()
        conductor.reload = self.reload
        
        feedsTableView.dataSource = self
        feedsTableView.delegate = self
        feedsTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        feedsTableView.separatorStyle = .none
        feedsTableView.refreshControl = refreshCtl
        
        refreshCtl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        
        conductor.feedsGet()
                
    }
    
    @objc func refresh(sender: UIRefreshControl){
        conductor.reloadFeeds()
    }
    
    func reload(){
        refreshCtl.endRefreshing()
        feedsTableView.reloadData()
    }
    
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conductor.feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleTableViewCell
        cell.titleLabel.text = conductor.feeds[indexPath.row].title
        cell.descriptionLabel.text = conductor.feeds[indexPath.row].preview
        cell.lineView.backgroundColor = conductor.feeds[indexPath.row].site.lineColor()
        
        cell.imageView?.image = conductor.feeds[indexPath.row].site.getImage(size: cell.logoSize)
        
        
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        let safariVC = SFSafariViewController(url: NSURL(string: conductor.feeds[indexPath.row].url)! as URL)
        present(safariVC, animated: true, completion: nil)
    }
    
    
}
