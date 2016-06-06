//
//  TagTableViewController.swift
//  JFNetworkTest
//
//  Created by John Fisher on 6/4/16.
//  Copyright © 2016 John Fisher. All rights reserved.
//

import UIKit
import Alamofire
import FLAnimatedImage

class TagTableViewController: UITableViewController {
  var loadingGif:NSData
  var gifCount:Int
  
  var gifData = [[String: AnyObject]]()

  required init?(coder aDecoder: NSCoder) {
    let asset = NSDataAsset(name: "gears")
    let data  = asset!.data
    
    self.loadingGif = data
    self.gifCount   = 0
    
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadPage(1)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("gifCell", forIndexPath: indexPath) as! GifCell
    let imageNumber = indexPath.row
    
    cell.tags.text = gifData[imageNumber]["tags"] as! String?
    
    cell.animatedImageView.contentMode = .Center
    cell.animatedImageView.animatedImage = FLAnimatedImage(animatedGIFData: self.loadingGif)
    
    if let url = gifData[imageNumber]["url"] as! String? {
      
      cell.pendingRequest = Alamofire.request(.GET, url)
        .response { response in
          // check to ensure cell is still shown
          if self.tableView.cellForRowAtIndexPath(indexPath) != nil {
            cell.animatedImageView.contentMode = .ScaleAspectFit
            cell.animatedImageView.animatedImage = FLAnimatedImage(animatedGIFData: response.2)
          }
      }
    }
    
    // load the next page if this is the final gif on the page and there are more gifs to show    
    if imageNumber == gifData.count - 1 && imageNumber < gifCount - 1 {
      loadPage(Int((imageNumber + 1) / 10) + 1)
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return gifData.count
  }
  
  func loadPage(page: Int) {
    getImagesFromTag(self.title!, page: page, handler: { response in
      if let dict = response.result.value as? [String: AnyObject] {
        let pageGifs = dict["gifs"] as! [[String: AnyObject]]
        
        self.gifData.appendContentsOf(pageGifs)
        self.tableView.reloadData()
      }
    })
  }
}

