//
//  TwitterCell.swift
//  Twitter
//
//  Created by Le Huynh Anh Tien on 7/20/16.
//  Copyright © 2016 Tien Le. All rights reserved.
//

import UIKit

class TwitterCell: UITableViewCell {
    

    @IBOutlet weak var mediaImageUrl: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var awataImage: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var mediaImageUrlContraintW: NSLayoutConstraint!
    @IBOutlet weak var mediaImageUrlContraintH: NSLayoutConstraint!
    
    @IBOutlet weak var tappedFavImage: UIView!
    var tweet: Tweet! {
        didSet {
            tweetLabel.text = tweet.text as? String
            retweetLabel.text = ("\(tweet.retweetCount)")
            favLabel.text = ("\(tweet.favouritesCount)")
            nameLabel.text = tweet.name as? String
            screenNameLabel.text = ("@\(tweet.scrName!)")
            awataImage.setImageWithURL(tweet.imageUrl!)
            if let mediaS = tweet.media {
                mediaImageUrl.setImageWithURL(mediaS)
            } else {
                mediaImageUrlContraintH.constant = 0.0
                mediaImageUrlContraintW.constant = 0.0
            }
            timeLabel.text = tweet.timestamp?.timeAgo()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initBorderRadius()

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initBorderRadius() {
        self.awataImage.backgroundColor = UIColor.whiteColor()
        self.awataImage.layer.cornerRadius = 8.0
        self.awataImage.clipsToBounds = true
        
    }

}
