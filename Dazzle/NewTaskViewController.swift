//
//  File: NewGroupViewController.swift
//  
//  Application: Tend
//
//  Created by Donna Yu on 8/6/15.
//  Copyright (c) 2015 Donna Yu. All rights reserved.
//


import Foundation
import UIKit
import Parse
import MBProgressHUD


// *****************************
// MARK: - NewTaskViewController
// *****************************

class NewTaskViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  @IBOutlet var keywordsLabel: UILabel!
  @IBOutlet var keywordsTextField: UITextField!

  @IBOutlet var activityLabel: UILabel!
  @IBOutlet weak var activityPicker: UIPickerView!

  @IBOutlet var groupLabel: UILabel!
  @IBOutlet weak var groupSelector: UISwitch!
  
  @IBOutlet var describeLabel: UILabel!
  @IBOutlet var describeFieldLabel: UITextView!
  
  var activityPickerData: [String] = [String]()
  var currentSelection: String = ""
  
  // ************************************
  // MARK: - Necessary View Configuration
  // ************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorColor = UIColor(white: 0.75, alpha: 1.0)
    activityPickerData = ["Draw", "Speak", "Type"]
  }
  
  
  // ****************************************
  // MARK: - Parse Group Saving Configuration
  // ****************************************
  
  @IBAction func cancelTapped(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func saveTapped(sender: AnyObject) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    if (describeFieldLabel.text == nil) {
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      var alert = UIAlertView(title: "Form Field Error", message: "Group name, school name, password, or description cannot be Empty", delegate: self, cancelButtonTitle: "Try Again")
      alert.show()
    } else {
      
      let task = PFObject(className: "Tasks")
      task["title"] = describeFieldLabel.text
      task["keywords"] = keywordsTextField.text
      task["activityType"] = currentSelection
//      task["creator"] = currentUser
      
      task.saveInBackgroundWithBlock() { (success, error) -> Void in
        if error == nil {
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          var alert = UIAlertView(title: "Success", message: "Group successfully created! Click to manage your group.", delegate: self, cancelButtonTitle: "Continue")
          alert.show()
          self.dismissViewControllerAnimated(true, completion: nil)
        } else {
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          if let errorString = error!.userInfo["error"] as? NSString {
            var alert = UIAlertView(title: "Error", message: errorString as String, delegate: self, cancelButtonTitle: "okay")
            alert.show()
          }
        }
      }
    }
  }
  
  
  // ********************************
  // MARK: - Table View Configuration
  // ********************************
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.row == 3 {
      return 190
    } else if indexPath.row == 1 {
      return 200
    }else {
      return 50
    }
  }
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row == 3 {
      cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(self.tableView.bounds));
    } else {
      cell.separatorInset = UIEdgeInsetsZero
    }
    cell.layoutMargins = UIEdgeInsetsZero
    cell.selectionStyle = .None
  }
  
  override func viewDidLayoutSubviews() {
    tableView.separatorInset = UIEdgeInsetsZero
    tableView.layoutMargins = UIEdgeInsetsZero
  }

  
  // ***************************
  // MARK: - Picker View Methods
  // ***************************
  
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return activityPickerData.count
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return activityPickerData[row]
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    currentSelection = activityPickerData[row]
  }
  
  
  // ***************************************************
  // MARK: - General View and Notification Configuration
  // ***************************************************
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.registerForKeyboardNotifications()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.deregisterFromKeyboardNotifications()
  }
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    var textlength = (textView.text as NSString).length + (text as NSString).length - range.length
    if text == "\n" {
      textView.resignFirstResponder()
    }
    return (textlength > 150) ? false : true
  }
  
  func registerForKeyboardNotifications () -> Void   {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func deregisterFromKeyboardNotifications () -> Void {
    let center:  NSNotificationCenter = NSNotificationCenter.defaultCenter()
    center.removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func keyboardWasShown(notification: NSNotification) {
    let info : NSDictionary = notification.userInfo!
    let keyboardSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue.size
    let insets: UIEdgeInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, keyboardSize!.height, 0)
    self.tableView.contentInset = insets
    self.tableView.scrollIndicatorInsets = insets
    self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + keyboardSize!.height)
  }
  
  func keyboardWillBeHidden (notification: NSNotification) {
    let info : NSDictionary = notification.userInfo!
    let keyboardSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue.size
    let insets: UIEdgeInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, keyboardSize!.height, 0)
    self.tableView.contentInset = insets
    self.tableView.scrollIndicatorInsets = insets
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true;
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
}
