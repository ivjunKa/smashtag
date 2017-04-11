//
//  ImageTableViewCell.swift
//  SmashTag
//
//  Created by Home on 11/04/17.
//  Copyright (c) 2017 nl.han.ica.mad. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

   
    @IBOutlet weak var tweetImage: UIImageView!
    var imageUrl: NSURL? {
        didSet {
            updateUI()
        }
    }
    private func updateUI (){
        if let url = imageUrl {
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageUrl {
                        if imageData != nil {
                            self.tweetImage?.image = UIImage(data: imageData!)
                        } else {
                            self.tweetImage?.image = nil
                        }
                    }
                }
            }
        }
    }

}
