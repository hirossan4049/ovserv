//
//  HomeBaseTBViewController.swift
//  observ
//
//  Created by craptone on 2021/01/09.
//

import UIKit
import SafariServices
import AVKit
import OpenGraph



//class HomeBaseTVViewController: UIViewController, UIViewControllerPreviewingDelegate {
class HomeBaseTVViewController: UIViewController {
//    private var conductor: HomeConductor!
    public var articles:[Article] = []
    private var articleOGPs: [String: UIImage] = [:]
    public var feedsTableView: UITableView!
    public var articleType: Article.SiteType!
    
    fileprivate let refreshCtl = UIRefreshControl()
    private var presenter: HomePresenterInput!

    func inject (presenter: HomePresenterInput) {
        print("inject", presenter)
        self.presenter = presenter
    }


    override func viewDidLoad() {
//        print("HOMEBASE VC called", articleType, articles)
        super.viewDidLoad()


        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
//        self.navigationController?.title = "Home"
        


        feedsTableView = UITableView(frame: view.frame)
//        feedsTableView.rowHeight = 200
        feedsTableView.rowHeight = UITableView.automaticDimension
        feedsTableView.dataSource = self
        feedsTableView.delegate = self
        feedsTableView.backgroundColor = UIColor(hex: "EFEFEF")
        self.view.backgroundColor = .blue

        feedsTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        feedsTableView.separatorStyle = .none
        feedsTableView.refreshControl = refreshCtl
        self.view.addSubview(feedsTableView)
        
        // 3D Touchが使える端末か確認
//        if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
//            registerForPreviewing(with: self, sourceView: feedsTableView)
//        }

        refreshCtl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        
        reload()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        reload()

//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.navigationController?.navigationBar.prefersLargeTitles = false
//        }
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
        print("tableVIewNumberOFFFFF", self.articles.count)
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleTableViewCell
        let article = articles[indexPath.row]
        cell.titleLabel.text = article.title
        cell.titleLabel.sizeToFit()
        cell.descriptionLabel.text = article.preview
        cell.descriptionLabel.sizeToFit()
        
        cell.ogpImageView.clipsToBounds = true
        cell.ogpImageView.layer.cornerRadius = 7
        cell.ogpImageView.contentMode = .scaleAspectFill
        
        cell.starClickFn = self.starClicked
//        print("image is ", article.imageURL ?? "")
        if let imageURL = article.imageURL {
            cell.ogpImageView.image = UIImage(url: imageURL)
        }
//        if let articleImage = articleOGPs[article.url] {
//            cell.ogpImgViewHeight.constant = 190
//            cell.ogpImageView.image = articleImage
//        }else {
//            cell.ogpImgViewHeight.constant = 0
//            OpenGraph.fetch(url: URL(string: article.url)!) { result in
//                switch result {
//                case .success(let og):
//    //                print(og[.image])
//                    DispatchQueue.main.async {
//                        if let imgURL = og[.image] {
//                            let image = UIImage(url:  imgURL)
//                            cell.ogpImgViewHeight.constant = 190
//                            cell.layoutIfNeeded()
//                            cell.ogpImageView.image = image
//                            self.articleOGPs[article.url] = image
//                        }else {
//                        }
//                    }
//                case .failure(let error):
//                    print(error)
//                    DispatchQueue.main.async {
//
//                    }
//                }
//            }
//        }
        
        cell.ogpImageView.sizeToFit()
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
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        // ①プレビューの定義
        let previewProvider: () -> SFSafariViewController? = { [unowned self] in
            return SFSafariViewController(url: NSURL(string: self.articles[indexPath.row].url)! as URL)
        }

        // ②メニューの定義
        let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in
            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                // some action
            }
            let editMenu: UIMenu = {
                let copy = UIAction(title: "Copy", image: nil) { _ in
                    // some action
                }
                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil) { _ in
                    // some action
                }
                return UIMenu(title: "Edit..", image: nil, identifier: nil, children: [copy, delete])
            }()

            return UIMenu(title: "Edit..", image: nil, identifier: nil, children: [share, editMenu])
        }

        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: previewProvider,
                                          actionProvider: actionProvider)
    }
    
    func starClicked(_ tag: Int, _ isStar: Bool){
        print(tag, isStar)

        AudioServicesPlaySystemSound(1520)
        if isStar{
            presenter.addStar(forRow: tag, articleType: articleType)
        }else{
            presenter.deleteStar(forRow: tag, articleType: articleType)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.navigationController?.navigationBar.prefersLargeTitles = scrollView.contentOffset.y < 100
    }

    
}



extension HomeBaseTVViewController{
    // MARK: 3DTouch
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        present(viewControllerToCommit, animated: true, completion: nil)
//    }
//
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//        print("3D Touched!")
//        let indexPath = feedsTableView.indexPathForRow(at: location)!
//
//        if (indexPath != nil){
//            let safariVC = SFSafariViewController(url: NSURL(string: self.articles[indexPath.row].url)! as URL)
////            secondViewController.PREVIEW_MODE = true
//            return safariVC
//
//        }else if(false){
//            // floating button
//
//        }else{
//            return nil
//        }
//    }
    

}
