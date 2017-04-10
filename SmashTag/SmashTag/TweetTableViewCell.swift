//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Home on 10/04/17.
//  Copyright (c) 2017 nl.han.ica.mad. All rights reserved.
//

import UIKit
import Twitter
class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet{
            updateUI()
        }
    }
 
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    @IBOutlet weak var tweetScreenName: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    func updateUI(){
        tweetTextLabel?.attributedText = nil
        tweetScreenName?.text = nil
        tweetProfileImageView?.image = nil
        
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " "
                }
            }
            tweetScreenName?.text = "\(tweet.user)"
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOfURL: profileImageURL) {
                    tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }
        }
    }
}
