//
//  HomeViewController.swift
//  observ
//
//  Created by unkonow on 2020/12/10.
//

import UIKit
import SafariServices
import AudioToolbox
import PTCardTabBar


class HomeViewController: UIViewController, UIViewControllerPreviewingDelegate {
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
        print("viewdidload")
        self.presenter = HomePresenter(view: self, model: StarModel())
        presenter.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.title = "Home"
        
        // 3D Touchが使える端末か確認
        if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            registerForPreviewing(with: self, sourceView: feedsTableView)
        }

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
        print("VIEWCONTRLLER RELOAD!!!!!!!!!!!!!")
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
        let cell: ArticleTableViewCell = feedsTableView.cellForRow(at: indexPath) as! ArticleTableViewCell
        let f = cell.backView.frame
//        UIView.animate(withDuration: 0.3, animations: {
//            cell.backView.frame = CGRect(x: f.origin.x - 5, y: f.origin.y - 5, width: f.width + 10, height: f.height + 10)
//        })
//        let safariVC = SFSafariViewController(url: NSURL(string: conductor.feeds[indexPath.row].url)! as URL)
        let safariVC = SFSafariViewController(url: NSURL(string: presenter.feed(forRow: indexPath.row)!.url)! as URL)
        present(safariVC, animated: true, completion: nil)
    }
    
    func starClicked(_ tag: Int, _ isStar: Bool){
        print(tag, isStar)

        AudioServicesPlaySystemSound(1520)
        if isStar{
            presenter.addStar(forRow: tag)
        }else{
            presenter.deleteStar(forRow: tag)
        }
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if velocity.y > 0 {
//            //上下のバーを隠す
//            hidesBarsWithScrollView(scrollView: scrollView, hidden: true, hiddenTop: false, hiddenBottom: true)
//        } else {
//            //上下のバーを表示する
//            hidesBarsWithScrollView(scrollView: scrollView, hidden: false, hiddenTop: false, hiddenBottom: true)
//        }
//    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print(#function)
//        hidesBarsWithScrollView(scrollView: scrollView, hidden: false, hiddenTop: false, hiddenBottom: true)
//    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(#function)
        hidesBarsWithScrollView(scrollView: scrollView, hidden: true, hiddenTop: false, hiddenBottom: true)
    }

    func hidesBarsWithScrollView(scrollView :UIScrollView,hidden:Bool,hiddenTop:Bool,hiddenBottom:Bool){
        let tabBarController = (self.tabBarController as? PTCardTabBarController)?.customTabBar
    
        var inset = scrollView.contentInset

        //上下バーのframe
        var tabBarRect = tabBarController?.frame
        var topBarRect = self.navigationController?.navigationBar.frame

        //各パーツの高さ
        let tabBarHeight = tabBarController?.frame.size.height
        let naviBarHeight = self.navigationController?.navigationBar.frame.size.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let controllerHeight = tabBarController?.frame.size.height

        if hidden {
            if hiddenTop {
                topBarRect?.origin.y = -(naviBarHeight! + statusBarHeight)
                inset.top = 0
            }
            if hiddenBottom {
                tabBarRect?.origin.y = controllerHeight!
                inset.bottom = 0
            }
        } else {
            topBarRect?.origin.y = statusBarHeight
            inset.top = naviBarHeight! + statusBarHeight
            tabBarRect?.origin.y = controllerHeight! - tabBarHeight!
            inset.bottom = tabBarHeight!
        }

        UIView.animate(withDuration: 0.5, animations: {() -> Void in
        scrollView.contentInset = inset
        scrollView.scrollIndicatorInsets = inset
        tabBarController?.frame = tabBarRect!
        self.navigationController?.navigationBar.frame = topBarRect!
        })
    }
    
    
}



extension HomeViewController{
    // MARK: 3DTouch
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        print("PRESSED")
//        self.performSegue(withIdentifier: "toZiten", sender: nil)
//        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "toZiten") as! ZitenViewController
//        secondViewController.group_createTime = self.clicked_group.createTime
//        self.navigationController?.pushViewController(secondViewController, animated: true)
        present(viewControllerToCommit, animated: true, completion: nil)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        print("3D Touched!")
//        AudioServicesPlaySystemSound( 1102 )
        let indexPath = feedsTableView.indexPathForRow(at: location)!
        
        if (indexPath != nil){
            let safariVC = SFSafariViewController(url: NSURL(string: presenter.feed(forRow: indexPath.row)!.url)! as URL)
//            secondViewController.PREVIEW_MODE = true
            return safariVC
            
        }else if(false){
            // floating button
            
        }else{
            return nil
        }
    }
}
