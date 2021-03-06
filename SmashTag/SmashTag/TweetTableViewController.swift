//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by Home on 10/04/17.
//  Copyright (c) 2017 nl.han.ica.mad. All rights reserved.
//

import UIKit
import Twitter
class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    var recents : Recents = Recents()
    var tweets = [[Tweet]]()
    var searchText: String? = "#stanford"{
        didSet{
            lastSuccesfulRequest = nil
            searchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
        
    }

    func refresh(){
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }

    // MARK: - Table view data source
    var lastSuccesfulRequest: TwitterRequest?
    var nextRequestToAttept: TwitterRequest? {
        if lastSuccesfulRequest == nil {
            if searchText != nil {
                return TwitterRequest(search: searchText!, count: 100)
            }
            else {
                return nil
            }
        } else {
            return lastSuccesfulRequest!.requestForNewer
        }
    }

    @IBAction func refresh(sender: UIRefreshControl?) {
        if searchText != nil {
            Recents().add(searchText!)
            if let request = nextRequestToAttept {
                request.fetchTweets{ (newTweets) -> Void in
                    let qos = Int(QOS_CLASS_USER_INITIATED.value)
                    dispatch_async(dispatch_get_global_queue(qos,0)) {() -> Void in
                        if newTweets.count > 0 {
                            //self.lastSuccesfulRequest = request
                            self.tweets.insert(newTweets, atIndex: 0)
                            self.tableView.reloadData()
                            sender?.endRefreshing()
                        }
                    }
                }
            }
        } else {
            sender?.endRefreshing()
        }
        
    }
    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField{
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tweets[section].count
    }

    private struct Storyboard {
        static let CellReuseIdentifier = "Tweet"
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as TweetTableViewCell

       
        cell.tweet = tweets[indexPath.section][indexPath.row]
        
        return cell
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
        if let identifier = segue.identifier {
            switch identifier {
            case "Tweet Details" :
                if let cell = sender as? TweetTableViewCell {
                    let mnvc = segue.destinationViewController as MentionTableViewController
                    mnvc.tweet = cell.tweet
                }
            default: break
            }
        }
    }
    

}
