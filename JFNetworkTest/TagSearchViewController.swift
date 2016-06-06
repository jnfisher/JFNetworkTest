//
//  TagSearchViewController.swift
//  JFNetworkTest
//
//  Created by John Fisher on 6/5/16.
//  Copyright © 2016 John Fisher. All rights reserved.
//

import UIKit

class TagSearchViewController: UITableViewController, UISearchResultsUpdating {
  var tagArray          = [String]()
  var filteredTagArray  = [String]()
  
  var selectedTag:String? = nil
  var gifCount:Int = 0
  
  let searchController = UISearchController(searchResultsController: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    tableView.tableHeaderView = searchController.searchBar
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("tagCell", forIndexPath: indexPath)
    
    if isSearching() {
      cell.textLabel?.text = filteredTagArray[indexPath.row]
    } else {
      cell.textLabel?.text = tagArray[indexPath.row]
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isSearching() {
      return filteredTagArray.count
    }
    
    return tagArray.count
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if isSearching() {
      selectedTag = filteredTagArray[indexPath.row]
    }
    else {
      selectedTag = tagArray[indexPath.row]
    }
    
    getImagesFromTag(selectedTag!, page:1, handler: { response in
      if let dict = response.result.value as? [String: AnyObject] {
        self.gifCount = Int(dict["gif_count"] as! String)!
        self.performSegueWithIdentifier("showsearchedtag", sender: self)
      }
    })
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showsearchedtag" {
      let tagTableViewController: TagTableViewController = segue.destinationViewController as! TagTableViewController
      
      tagTableViewController.title = selectedTag
      tagTableViewController.gifCount = gifCount
    }
  }
  
  func isSearching() -> Bool {
    return searchController.active && searchController.searchBar.text != ""
  }
  
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    filteredTagArray = tagArray.filter { tag in
      return tag.lowercaseString.containsString(searchController.searchBar.text!.lowercaseString)
    }
    
    tableView.reloadData()
  }
}