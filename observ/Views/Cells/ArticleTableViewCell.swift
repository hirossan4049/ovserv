//
//  ArticleTableViewCell.swift
//  observ
//
//  Created by unkonow on 2020/11/27.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var logoView: UIImageView!
    
    public let logoSize = CGSize(width: 50, height: 18.5)

    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 7
        backView.layer.shadowColor = UIColor.darkGray.cgColor
        self.backgroundColor = .none
        
        self.backView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.backView.layer.shadowColor = UIColor.black.cgColor
        self.backView.layer.shadowOpacity = 0.3
        self.backView.layer.shadowRadius = 4
        
        self.imageView?.backgroundColor = .red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
