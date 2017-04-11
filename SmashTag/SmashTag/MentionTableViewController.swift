//
//  MentionTableViewController.swift
//  SmashTag
//
//  Created by Home on 11/04/17.
//  Copyright (c) 2017 nl.han.ica.mad. All rights reserved.
//

import UIKit
import Twitter
class MentionTableViewController: UITableViewController {
    
    var tweet: Tweet? {
        
        didSet {
            title = tweet?.user.screenName
            if let media = tweet?.media  {
                mentionTypes.append(MentionType(type: "Images",
                    mentions: media.map { Mention.Image($0.url, $0.aspectRatio) }))
            }
            if let urls = tweet?.urls {
                if urls.count > 0 {
                    mentionTypes.append(MentionType(type: "URLs",
                        mentions: urls.map { Mention.Keyword($0.keyword) }))
                }
            }
            if let hashtags = tweet?.hashtags{
                mentionTypes.append(MentionType(type: "Hashtags",
                    mentions: hashtags.map { Mention.Keyword($0.keyword) }))
            }
            if let users = tweet?.userMentions {
                var userItems = [Mention.Keyword("@" + tweet!.user.screenName)]
                if users.count > 0 {
                    userItems += users.map { Mention.Keyword($0.keyword) }
                }
                mentionTypes.append(MentionType(type: "Users", mentions: userItems))
            }
        }
    }
    private var mentionTypes: [MentionType] = []
    private struct MentionType: Printable
    {
        var type: String
        var mentions: [Mention]
        var description: String {return "\(type): \(mentions)"}
    }
    private struct PrintableTest: Printable {
        var description : String {return "blah"}
    }
    private enum Mention: Printable{
        case Keyword(String)
        case Image(NSURL, Double)
        var description: String {
            switch self {
            case .Keyword(let keyword): return keyword
            case .Image(let url,_): return url.path!
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return mentionTypes.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return mentionTypes[section].mentions.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        let mention = mentionTypes[indexPath.section].mentions[indexPath.row]
        switch mention {
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCellWithIdentifier("Keyword Cell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = keyword
            return cell
        case .Image(let url, let ratio):
            let cell = tableView.dequeueReusableCellWithIdentifier("Image View Cell", forIndexPath: indexPath) as ImageTableViewCell
            cell.imageUrl = url
            return cell
        }

        // Configure the cell...

        //return cell
    }
    
    override func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            
            let mention = mentionTypes[indexPath.section].mentions[indexPath.row]
            switch mention {
            case .Image(_, let ratio):
                return tableView.bounds.size.width / CGFloat(ratio)
            default:
                return UITableViewAutomaticDimension
            }
    }
    
    override func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
            return mentionTypes[section].type
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        print("go back to twitter")
        if let identifier = segue.identifier {
            switch identifier {
            case "Show Mentions Keywords" :
                
                if let ttvc = segue.destinationViewController as? TweetTableViewController {
                    if let cell = sender as? UITableViewCell {
                        ttvc.searchText = cell.textLabel?.text
                    }
                }
            default: break
            }
        }
//        if let identifier = segue.identifier {
//            switch identifier {
//            case "From Mentions Keyword" :
//                if let cell = sender as? TweetTableViewCell {
//                    let mnvc = segue.destinationViewController as MentionTableViewController
//                    mnvc.tweet = cell.tweet
//                }
//            default: break
//            }
//        }
    }

}
