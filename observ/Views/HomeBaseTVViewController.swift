//
//  HomeBaseTBViewController.swift
//  observ
//
//  Created by craptone on 2021/01/09.
//

import UIKit
import SafariServices
import AVKit





class HomeBaseTVViewController: UIViewController, UIViewControllerPreviewingDelegate {
//    private var conductor: HomeConductor!
    public var articles:[Article] = []
    public var feedsTableView: UITableView!
    
    fileprivate let refreshCtl = UIRefreshControl()
    

    override func viewDidLoad() {
        print("HOMEBASE VC called")
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationController?.title = "Home"
        
        // 3D Touchが使える端末か確認
        if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            registerForPreviewing(with: self, sourceView: feedsTableView)
        }

        feedsTableView = UITableView(frame: view.frame)
        feedsTableView.frame = view.bounds
        feedsTableView.backgroundColor = .green
        feedsTableView.rowHeight = 200
        feedsTableView.dataSource = self
        feedsTableView.delegate = self
        feedsTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        feedsTableView.separatorStyle = .none
        feedsTableView.refreshControl = refreshCtl
                
        refreshCtl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        
        reload()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func refresh(sender: UIRefreshControl){
    }
    

    
}

extension HomeBaseTVViewController: HomePresenterOutput{
    func reload(){
        print("VIEWCONTRLLER RELOAD!!!!!!!!!!!!!", articles)
        refreshCtl.endRefreshing()
        feedsTableView.reloadData()
    }
    
}


extension HomeBaseTVViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleTableViewCell
        let article = articles[indexPath.row]
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
        let cell: ArticleTableViewCell = feedsTableView.cellForRow(at: indexPath) as! ArticleTableViewCell
        let f = cell.backView.frame
//        UIView.animate(withDuration: 0.3, animations: {
//            cell.backView.frame = CGRect(x: f.origin.x - 5, y: f.origin.y - 5, width: f.width + 10, height: f.height + 10)
//        })
//        let safariVC = SFSafariViewController(url: NSURL(string: conductor.feeds[indexPath.row].url)! as URL)
        let safariVC = SFSafariViewController(url: NSURL(string: self.articles[indexPath.row].url)! as URL)
        present(safariVC, animated: true, completion: nil)
    }
    
    func starClicked(_ tag: Int, _ isStar: Bool){
        print(tag, isStar)

        AudioServicesPlaySystemSound(1520)
        if isStar{
//            presenter.addStar(forRow: tag)
        }else{
//            presenter.deleteStar(forRow: tag)
        }
    }

    
}



extension HomeBaseTVViewController{
    // MARK: 3DTouch
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(viewControllerToCommit, animated: true, completion: nil)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        print("3D Touched!")
        let indexPath = feedsTableView.indexPathForRow(at: location)!
        
        if (indexPath != nil){
            let safariVC = SFSafariViewController(url: NSURL(string: self.articles[indexPath.row].url)! as URL)
//            secondViewController.PREVIEW_MODE = true
            return safariVC
            
        }else if(false){
            // floating button
            
        }else{
            return nil
        }
    }
}
