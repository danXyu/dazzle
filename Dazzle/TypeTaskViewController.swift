//
//  TypeTaskViewController.swift
//  Dazzle
//
//  Created by Dan Xiaoyu Yu on 12/3/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit

class TypeTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var answerTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    questionLabel.text = selectedTask?.objectForKey("title") as? String
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if answers != nil {
      return (answers?.count)!
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("answerCell") as! AnswerCell
    cell.answer.text = answers![indexPath.row]
    return cell
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    print(answerTextField.text)
    answerTextField.resignFirstResponder()
    return true
  }
  
  @IBAction func addNewAnswer(sender: UIButton) {
    if answerTextField.text! != "" {
        answers?.append(answerTextField.text!)
    }
    answerTextField.text = nil
    self.tableView.reloadData()
  }
}