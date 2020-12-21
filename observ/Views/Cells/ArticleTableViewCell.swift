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
    @IBOutlet weak var starButton: UIButton!
    
    public let logoSize = CGSize(width: 18.5, height: 18.5)
    public var starClickFn: ((Int, Bool) -> ())!
    
    private var defaultsBackViewFrame: CGRect!
    
    public var isStar = false {
        didSet{
            if isStar{
                starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }else{
                starButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 7
        backView.layer.shadowColor = UIColor.darkGray.cgColor
        self.backgroundColor = .none
        lineView.isHidden = true
        
        self.backView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.backView.layer.shadowColor = UIColor.black.cgColor
        self.backView.layer.shadowOpacity = 0.2
        self.backView.layer.shadowRadius = 10
        
        defaultsBackViewFrame = self.backView.frame
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
//        if highlighted{
//            let f = self.backView.frame
////            self.backView.frame = CGRect(x: f.origin.x + 5, y: f.origin.y + 5, width: f.width - 10, height: f.height - 10)
////            UIView.animate(withDuration: 0.3, animations: {
//            UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseOut, animations: {
//                self.backView.frame = CGRect(x: f.origin.x - 5, y: f.origin.y - 5, width: f.width + 10, height: f.height + 10)
//            })
//            self.backView.frame = CGRect(x: f.origin.x - 5, y: f.origin.y - 5, width: f.width + 10, height: f.height + 10)
//        }else{
//            UIView.animate(withDuration: 0.3, animations: {
//                self.backView.frame = self.defaultsBackViewFrame
//            })
//            self.backView.frame = defaultsBackViewFrame
//        }
    }
    
    @IBAction func starClicked(){
        isStar = !isStar
        starClickFn(self.tag, isStar)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
