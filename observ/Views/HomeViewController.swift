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
import Parchment


//UIViewControllerPreviewingDelegate
//class HomeViewController: TabPageViewController {
class HomeViewController: UIViewController {

//    @IBOutlet weak var feedsTableView: UITableView!
    @IBOutlet weak var siteSegmentCtrl: UISegmentedControl!
    @IBOutlet weak var feedsBaseView: UIView!
    fileprivate let refreshCtl = UIRefreshControl()
    private var presenter: HomePresenterInput!

    private lazy var zenn: HomeBaseTVViewController = {
        let vc = HomeBaseTVViewController()
        vc.title = "zenn"
        vc.articleType = .zenn
        vc.inject(presenter: presenter)
        vc.articles = presenter.articles(site: .zenn)
        add(asChildViewController: vc)
        return vc
    }()
    private lazy var hatena: HomeBaseTVViewController = {
        let vc = HomeBaseTVViewController()
        vc.title = "hatena"
        vc.articleType = .hatena
        vc.inject(presenter: presenter)
        vc.articles = presenter.articles(site: .hatena)
        add(asChildViewController: vc)
        return vc
    }()
    private lazy var qiita: HomeBaseTVViewController = {
        let vc = HomeBaseTVViewController()
        vc.title = "qiita"
        vc.articleType = .qiita
        vc.inject(presenter: presenter)
        vc.articles = presenter.articles(site: .qiita)
        add(asChildViewController: vc)
        return vc
    }()



    func inject(presenter: HomePresenterInput) {
        print("inject", presenter)
        self.presenter = presenter
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")

        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.presenter = HomePresenter(view: self, model: StarModel())
        presenter.viewDidLoad()


        let viewControllers = [
            hatena,
            zenn,
            qiita,
            ContentViewController(index: 3)
        ]

        let pagingViewController = PagingViewController(viewControllers: viewControllers)
        pagingViewController.menuItemSize = .selfSizing(estimatedWidth: 100, height: 40)

        // Make sure you add the PagingViewController as a child view
        // controller and constrain it to the edges of the view.
        addChild(pagingViewController)
        feedsBaseView.addSubview(pagingViewController.view)
        feedsBaseView.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)


        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationController?.title = "Home"

        // 3D Touchが使える端末か確認
//        if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
//            registerForPreviewing(with: self, sourceView: feedsTableView)
//        }


//        feedsTableView.dataSource = self
//        feedsTableView.delegate = self
//        feedsTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
//        feedsTableView.separatorStyle = .none
//        feedsTableView.refreshControl = refreshCtl

//        refreshCtl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)

//        conductor.feedsGet()

    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        presenter.reloadFeeds()
    }

    @objc func refresh(sender: UIRefreshControl) {
//        conductor.reloadFeeds()
        self.presenter.reloadFeeds()
    }

    private func add(asChildViewController viewController: UIViewController) {
        // 子ViewControllerを追加
        addChild(viewController)
        // Subviewとして子ViewControllerのViewを追加
        feedsBaseView.addSubview(viewController.view)
        // 子Viewの設定
        viewController.view.frame = feedsBaseView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // 子View Controllerへの通知
        viewController.didMove(toParent: self)
    }

    private func remove(asChildViewController viewController: UIViewController) {
        // 子View Controllerへの通知
        viewController.willMove(toParent: nil)
        // 子ViewをSuperviewから削除
        viewController.view.removeFromSuperview()
        // 子View Controllerへの通知
        viewController.removeFromParent()
    }

    @IBAction func tapSegmentedControl(_ sender: UISegmentedControl) {
        updateView()
    }

    private func updateView() {
        if siteSegmentCtrl.selectedSegmentIndex == 0 {
            remove(asChildViewController: hatena)
            zenn.reload()
            add(asChildViewController: zenn)
        } else {
            remove(asChildViewController: zenn)
            hatena.reload()
            add(asChildViewController: hatena)
        }
    }

}

extension HomeViewController: HomePresenterOutput {
    func reload() {
        print("VIEWCONTRLLER RELOAD!!!!!!!!!!!!!")
        refreshCtl.endRefreshing()
        zenn.reload()
        hatena.reload()
//        feedsTableView.reloadData()
    }

}

//extension HomeViewController: PagingViewControllerDataSource {
//  func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
//    return PagingIndexItem(index: index, title: "test")
//  }
//
//  func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
//
//    print("nuha")
//    return ContentViewController(title: "hello")
//  }
//
//  func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
//    return 1
//  }
//}


final class ContentViewController: UIViewController {
    convenience init(index: Int) {
        self.init(title: "View \(index)", content: "\(index)")
    }

    convenience init(title: String) {
        self.init(title: title, content: title)
    }

    init(title: String, content: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title

        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.thin)
        label.textColor = UIColor(red: 95 / 255, green: 102 / 255, blue: 108 / 255, alpha: 1)
        label.textAlignment = .center
        label.text = content
        label.sizeToFit()

        view.addSubview(label)
//    view.constrainToEdges(label)
        view.backgroundColor = .yellow
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return presenter.numberOfFeeds
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleTableViewCell
//        let article = presenter.feed(forRow: indexPath.row)!
//        cell.titleLabel.text = article.title
//        cell.descriptionLabel.text = article.preview
////        cell.lineView.backgroundColor = article.lineColor()
//        cell.starClickFn = self.starClicked
//        cell.tag = indexPath.row
//
//        cell.logoView?.image = article.site.getImage(size: cell.logoSize)
//
//
//        cell.selectionStyle = .none
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         tableView.deselectRow(at: indexPath, animated: true)
//        let cell: ArticleTableViewCell = feedsTableView.cellForRow(at: indexPath) as! ArticleTableViewCell
//        let f = cell.backView.frame
////        UIView.animate(withDuration: 0.3, animations: {
////            cell.backView.frame = CGRect(x: f.origin.x - 5, y: f.origin.y - 5, width: f.width + 10, height: f.height + 10)
////        })
////        let safariVC = SFSafariViewController(url: NSURL(string: conductor.feeds[indexPath.row].url)! as URL)
//        let safariVC = SFSafariViewController(url: NSURL(string: presenter.feed(forRow: indexPath.row)!.url)! as URL)
//        present(safariVC, animated: true, completion: nil)
//    }
//
//    func starClicked(_ tag: Int, _ isStar: Bool){
//        print(tag, isStar)
//
//        AudioServicesPlaySystemSound(1520)
//        if isStar{
//            presenter.addStar(forRow: tag)
//        }else{
//            presenter.deleteStar(forRow: tag)
//        }
//    }

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
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print(#function)
//        hidesBarsWithScrollView(scrollView: scrollView, hidden: true, hiddenTop: false, hiddenBottom: true)
//    }

//    func hidesBarsWithScrollView(scrollView :UIScrollView,hidden:Bool,hiddenTop:Bool,hiddenBottom:Bool){
//        let tabBarController = (self.tabBarController as? PTCardTabBarController)?.customTabBar
//
//        var inset = scrollView.contentInset
//
//        //上下バーのframe
//        var tabBarRect = tabBarController?.frame
//        var topBarRect = self.navigationController?.navigationBar.frame
//
//        //各パーツの高さ
//        let tabBarHeight = tabBarController?.frame.size.height
//        let naviBarHeight = self.navigationController?.navigationBar.frame.size.height
//        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
//        let controllerHeight = tabBarController?.frame.size.height
//
//        if hidden {
//            if hiddenTop {
//                topBarRect?.origin.y = -(naviBarHeight! + statusBarHeight)
//                inset.top = 0
//            }
//            if hiddenBottom {
//                tabBarRect?.origin.y = controllerHeight!
//                inset.bottom = 0
//            }
//        } else {
//            topBarRect?.origin.y = statusBarHeight
//            inset.top = naviBarHeight! + statusBarHeight
//            tabBarRect?.origin.y = controllerHeight! - tabBarHeight!
//            inset.bottom = tabBarHeight!
//        }
//
//        UIView.animate(withDuration: 0.5, animations: {() -> Void in
//        scrollView.contentInset = inset
//        scrollView.scrollIndicatorInsets = inset
//        tabBarController?.frame = tabBarRect!
//        self.navigationController?.navigationBar.frame = topBarRect!
//        })
//    }

//}


//extension HomeViewController{
//    // MARK: 3DTouch
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        present(viewControllerToCommit, animated: true, completion: nil)
//    }
//
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//        print("3D Touched!")
//        let indexPath = feedsTableView.indexPathForRow(at: location)!
//
//        if (indexPath != nil){
//            let safariVC = SFSafariViewController(url: NSURL(string: presenter.feed(forRow: indexPath.row)!.url)! as URL)
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
//}
