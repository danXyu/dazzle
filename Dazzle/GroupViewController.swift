//
//  GroupViewController.swift
//  Dazzle
//
//  Created by Dan Xiaoyu Yu on 11/17/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit
import MBProgressHUD
import Parse
import ParseFacebookUtilsV4


// ****************************
// MARK: - GroupsViewController
// ****************************

class GroupViewController: UITableViewController {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  var data: [PFObject]!
  var filtered: [PFObject]!
  
  
  // *************************************
  // MARK: - View Controller Configuration
  // *************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadGroups()
  }
    
  override func viewDidAppear(animated: Bool) {
    loadGroups()
  }
  
  
  // **************************
  // MARK: - Parse Data Methods
  // **************************
  
  func loadGroups(){
    let query = PFQuery(className: "Tasks")
    query.whereKey("isGroupActivity", equalTo: true)
    
    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      self.data = results! as [PFObject]
      self.tableView.reloadData()
    }
  }
  
  
  // ******************************
  // MARK: - Table View Data Source
  // ******************************
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 80
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if (self.data != nil) {
      return self.data.count
    } else {
      return 1
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if self.data != nil {
      if self.data.count == 0 {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoTasksCell", forIndexPath: indexPath)
        return cell
      } else {
        let task = self.data[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath) as! TaskViewCell
        let activityType = task.objectForKey("activityType") as? String
        
        cell.taskTypeLabel.text = task.objectForKey("title") as? String
        cell.taskTypeImage.image = UIImage(named: activityType!)
        cell.keywordsLabel.text = task.objectForKey("keywords") as? String
        
        return cell
      }
    }
    let cell = tableView.dequeueReusableCellWithIdentifier("NoTasksCell", forIndexPath: indexPath)
    return cell
  }
  
  override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    selectedTask = self.data[indexPath.row]
    
    if let activityType = selectedTask?.objectForKey("activityType") as? String {
      if activityType == "Speak" {
        self.performSegueWithIdentifier("speechTask", sender: self)
      }
      if activityType == "Draw" {
        self.performSegueWithIdentifier("drawTask", sender: self)
      }
      if activityType == "Type" {
        self.performSegueWithIdentifier("typeTask", sender: self)
      }
    }
  }
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.separatorInset = UIEdgeInsetsZero
    cell.layoutMargins = UIEdgeInsetsZero
    cell.selectionStyle = .None
  }
  
  override func viewDidLayoutSubviews() {
    tableView.separatorInset = UIEdgeInsetsZero
    tableView.layoutMargins = UIEdgeInsetsZero
  }
}
