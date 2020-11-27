//
//  ViewController.swift
//  observ
//
//  Created by unkonow on 2020/11/22.
//

import UIKit

class ViewController: UIViewController {
    private var conductor: HomeConductor!
    
    @IBOutlet weak var feedsTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        conductor = HomeConductor()
        conductor.reload = self.reload
        
        feedsTableView.dataSource = self
        feedsTableView.delegate = self
        feedsTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        conductor.feedGets()
        
    }
    
    func reload(){
        feedsTableView.reloadData()
    }
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conductor.feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleTableViewCell
        cell.titleLabel.text = conductor.feeds[indexPath.row].title
        cell.descriptionLabel.text = conductor.feeds[indexPath.row].preview
        cell.lineView.backgroundColor = conductor.feeds[indexPath.row].site.lineColor()
        return cell
    }
    
    
}
