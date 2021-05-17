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
    @IBOutlet weak var ogpImageView: UIImageView!
    @IBOutlet weak var ogpImgViewHeight: NSLayoutConstraint!

    public let logoSize = CGSize(width: 18.5, height: 18.5)
    public var starClickFn: ((Int, Bool) -> ())!

    private var defaultsBackViewFrame: CGRect!

    public var isStar = false {
        didSet {
            if isStar {
                starButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                starButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 7
        backView.layer.shadowColor = UIColor.darkGray.cgColor
        self.backgroundColor = UIColor(hex: "EFEFEF")
        lineView.isHidden = true
        


//        self.backView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        self.backView.layer.shadowColor = UIColor.black.cgColor
//        self.backView.layer.shadowOpacity = 0.2
//        self.backView.layer.shadowRadius = 5
//
//
//        let whiteShadow = CAShapeLayer()
//        whiteShadow.frame = self.backView.bounds
////        whiteShadow.frame = CGRect(x: 0.0, y: self.backView.frame.size.height - 1, width: self.backView.frame.size.width, height: 1.0)
//        whiteShadow.shadowOpacity = 1
//        whiteShadow.shadowRadius = 3
////        whiteShadow.position = self.backView.layer.position
//        whiteShadow.backgroundColor = UIColor.white.cgColor
//        whiteShadow.shadowColor = UIColor.red.cgColor
//        whiteShadow.shadowOffset = CGSize(width: -2.0, height: -2.0)
//        self.backView.layer.addSublayer(whiteShadow)

//        self.backView.Neumorphism(UIColor(hex: "EFEFEF"), roundCorner: 15)


//        self.backView.layer.insertSublayer(whiteShadow, at: 0)

        self.bringSubviewToFront(self.backView)


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

    @IBAction func starClicked() {
        isStar = !isStar
        starClickFn(self.tag, isStar)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


// NeumorphismExtension.swift

import UIKit

public extension UIView {

    func NeumorphismShadow(_ defaultcolor: UIColor, _ shadowType: String) -> UIColor {
        var color: UIColor = defaultcolor
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        if color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            let brightRate: CGFloat = shadowType == "dark" ? 0.90 : 1.10;
            color = UIColor(hue: hue, saturation: saturation, brightness: brightness * brightRate, alpha: alpha)
        }
        return color
    }

    func AddShadow(width: CGFloat, height: CGFloat, color: UIColor, roundCorner: CGFloat) {
        let btnLayer = CALayer()
        btnLayer.masksToBounds = false
        btnLayer.shadowColor = color.cgColor
        btnLayer.shadowOpacity = 1
        btnLayer.shadowOffset = CGSize(width: width, height: height)
        btnLayer.shadowRadius = 5
        var bonbon = self.bounds
        bonbon.size.width -= 20
        bonbon.origin.x += 20
        btnLayer.shadowPath = UIBezierPath(roundedRect: bonbon, cornerRadius: roundCorner).cgPath
        self.layer.insertSublayer(btnLayer, at: 0)
    }

    func AddBackground(color: UIColor, roundCorner: CGFloat) {
        let background = CALayer()
        background.backgroundColor = color.cgColor
        background.cornerRadius = roundCorner
        background.frame.size = CGSize(width: frame.size.width - 20, height: frame.size.height)
        self.layer.insertSublayer(background, at: 0)
    }

    func Neumorphism(_ backGroundColor: UIColor, roundCorner: CGFloat) {
//        let backGroundColor = UIColor(displayP3Red: r/255, green: g/255, blue: b/255,alpha: 1.0)
        let darkcolor = NeumorphismShadow(backGroundColor, "dark")
        let lightcolor = NeumorphismShadow(backGroundColor, "light")
        AddBackground(color: backGroundColor, roundCorner: roundCorner)
        AddShadow(width: 4.0, height: 4.0, color: darkcolor, roundCorner: roundCorner)
        AddShadow(width: -4.0, height: -4.0, color: lightcolor, roundCorner: roundCorner)
    }

}
