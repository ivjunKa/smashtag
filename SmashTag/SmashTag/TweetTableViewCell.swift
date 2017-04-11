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
    
    private struct colorsForMentions {
        static let hashtags = UIColor.redColor()
        static let url = UIColor.blueColor()
        static let userMentions = UIColor.purpleColor()
    }
    private struct Storyboard {
        static let CellReuseIdentifier = "Tweet"
    }
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
//                for _ in tweet.media {
//                    tweetTextLabel.text! += " "
//                }
                tweetTextLabel?.attributedText = setMentionColors(tweet)
            }
            tweetScreenName?.text = "\(tweet.user)"
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOfURL: profileImageURL) {
                    tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }
        }
    }
    func setMentionColors(tweet: Tweet) -> NSMutableAttributedString {
        var tweetText: String = tweet.text
        //for _ in tweet.media { tweetText += " "}
        var attribText = NSMutableAttributedString(string: tweetText)
        attribText.setKeywordsColor(tweet.hashtags, color: colorsForMentions.hashtags)
        attribText.setKeywordsColor(tweet.urls, color: colorsForMentions.url)
        attribText.setKeywordsColor(tweet.userMentions, color: colorsForMentions.userMentions)
        return attribText
    }
    
}
private extension NSMutableAttributedString {
    func setKeywordsColor(keywords: [Tweet.IndexedKeyword], color: UIColor){
        for keyword in keywords {
            addAttribute(NSForegroundColorAttributeName, value: color, range: keyword.nsrange)
        }
    }
}
