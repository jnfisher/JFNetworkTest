//
//  ViewController.swift
//  JFNetworkTest
//
//  Created by John Fisher on 6/4/16.
//  Copyright © 2016 John Fisher. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
  var gifCount:Int = 0
  
  @IBOutlet var showGifsButton: UIButton!
  @IBOutlet var refreshsButton: UIButton!
  
  @IBOutlet var randomlyChosenTag: UILabel!
  @IBOutlet var numberOfImages: UILabel!
  
  var tagArray = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    showGifsButton.enabled = false
    
    getTags { response in
      if let JSON = response.result.value {
        self.tagArray += JSON as! [String]
        self.refreshRandomTag()
        
        self.showGifsButton.enabled = true
        self.refreshsButton.enabled = true
      }
    }
  }
  
  @IBAction func refreshTapped(sender: AnyObject) {
    refreshRandomTag()
  }
  
  func refreshRandomTag() {
    let index = arc4random_uniform(UInt32(self.tagArray.count))
    randomlyChosenTag.text = tagArray[Int(index)]
    
    getImagesFromTag(randomlyChosenTag.text!, page:1, handler: { response in
      if let dict = response.result.value as? [String: AnyObject] {
        self.gifCount = Int(dict["gif_count"] as! String)!
        self.numberOfImages.text = "(\(self.gifCount))"
      }
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showgifs" {
      let tagTableViewController: TagTableViewController = segue.destinationViewController as! TagTableViewController
      
      tagTableViewController.title    = randomlyChosenTag.text
      tagTableViewController.gifCount = gifCount
    }
    else if segue.identifier == "showsearch" {
      let tagSearchViewController: TagSearchViewController = segue.destinationViewController as! TagSearchViewController
      
      tagSearchViewController.tagArray = tagArray
    }
  }
}

