//
//  TweetDetailsViewController.swift
//  Twitter App
//
//  Created by Gomes, Yuri (formerly Farias Gomes) on 10/02/17.
//  Copyright © 2017 Gomes, Yuri (formerly Farias Gomes). All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class TweetDetailsViewController: UIViewController {
    
    var tweet : JSON?

    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var handlerLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = tweet?["user"] {
            nameLabel.text = user["name"].stringValue
            handlerLabel.text = "@\(user["screen_name"].stringValue)"
            contentLabel.text = tweet?["text"].string
            
            profileImageView.kf.setImage(with: URL(string: user["profile_image_url_https"].stringValue)!)
            
            let dateFormatter = DateFormatter()
            
            let dateFormatPattern = "EEE MMM dd HH:mm:ss Z yyyy"
            dateFormatter.dateFormat = dateFormatPattern
            
            if let createdAtStr = tweet?["created_at"].string {
                let creationDate = dateFormatter.date(from: createdAtStr)
                let outputFormat = "HH:mm EEE dd MMM yyyy"
                dateFormatter.dateFormat = outputFormat
                dateLabel.text = dateFormatter.string(from: creationDate!)
                dateLabel.isHidden = false
            } else {
                dateLabel.isHidden = true
            }
            
            if let profileImgUrl = user["profile_background_image_url_https"    ].string {
                headerImageView.kf.setImage(with: URL(string: profileImgUrl)!)
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
