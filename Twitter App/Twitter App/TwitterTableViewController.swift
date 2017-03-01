//
//  TwitterTableViewController.swift
//  Twitter App
//
//  Created by Gomes, Yuri (formerly Farias Gomes) on 08/02/17.
//  Copyright © 2017 Gomes, Yuri (formerly Farias Gomes). All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class TwitterTableViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchField: UISearchBar!
    
    var tweets : [Tweet] = [Tweet]()
    
    var tweetsJson : [JSON]? = []
    
    var timer : Timer?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchField.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 120.0;
        
        getTweets()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        startSearchTimer()
        
        if !(searchText.isEmpty) {
            self.title = "Twitter #\(searchField.text!)"
        } else {
            self.title = "Twitter #adidas"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func startSearchTimer() {
        if (timer == nil) {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                    self.getTweets()
                    timer.invalidate()
                    self.timer = nil;
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterAppCell", for: indexPath) as! TwitterTableViewCell

        let tweet = self.tweets[indexPath.row]
        
        // Configure the cell...
        if let text = tweet.text {
            cell.twitterLabel?.text = text
        }
        
        if let imgUrl = tweet.imgUrl {
            cell.twitterImgView?.kf.setImage(with: URL(string: imgUrl)!);
        }
        
        cell.userNameLabel.text = "\(tweet.userName!)"
        cell.userTwitterLabel.text = "@\(tweet.userTwitter!)"
        
        cell.layoutIfNeeded()

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showTweetDetail") {
            let detailController = segue.destination as! TweetDetailsViewController
            let index = self.tableView.indexPathForSelectedRow?.row
            detailController.tweet = self.tweetsJson?[index!]
        }
    }
    
    func getTweets() {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer AAAAAAAAAAAAAAAAAAAAAELhywAAAAAA6a9Sva%2FzXABvX2MkPzP6Tyns%2FU4%3Dxl0tN0KccBZYsrwclt7JOCPYKRU2EdAMPw4SHcg4wBS1k9zvmP"
        ]
        
        var parameters: Parameters = ["q": "#adidas"];
        
        if !(searchField.text?.isEmpty)! {
            parameters["q"] = "#\(searchField.text!)"
        }
        
        Alamofire.request("https://api.twitter.com/1.1/search/tweets.json", parameters: parameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.tweets.removeAll()
                self.tweetsJson = json["statuses"].array!
                for jsonTweet in self.tweetsJson! {
                    
                    let tweet = Tweet()
                    tweet.text = jsonTweet["text"].string
                    tweet.imgUrl = jsonTweet["user"]["profile_image_url_https"].string
                    tweet.userName = jsonTweet["user"]["name"].string
                    tweet.userTwitter = jsonTweet["user"]["screen_name"].string
                    
                    self.tweets.append(tweet)
                }
                
                self.tableView.reloadData()
                self.tableView.setNeedsLayout()
                self.tableView.layoutIfNeeded()
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
