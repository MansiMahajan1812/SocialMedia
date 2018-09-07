//
//  TwitterFollowers.swift
//  SocialMedia
//
//  Created by Mansi Mahajan on 7/24/18.
//  Copyright © 2018 Mansi Mahajan. All rights reserved.
//

import Foundation

struct TwitterFollower {
    var name: String?
    var description: String?
    var profileURL: NSData?
    
    init (name: String, url: String) {
        
        self.name = name
        let pictureURL = NSURL(string: url)
        profileURL = NSData(contentsOf: pictureURL as! URL)
       print(pictureURL)
     
        
        //profileURL = NSData(contentsOfURL: pictureURL!)
        
    }
}
