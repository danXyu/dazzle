//
//  TaskViewCell.swift
//  Dazzle
//
//  Created by Dan Xiaoyu Yu on 11/19/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit
import Parse


// ********************
// MARK: - TaskViewCell
// ********************

class TaskViewCell: UITableViewCell {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  

  @IBOutlet weak var taskTypeLabel: UILabel!
  @IBOutlet weak var taskTypeImage: UIImageView!
  @IBOutlet weak var keywordsLabel: UILabel!
  @IBOutlet weak var playButton: UIButton!
  
  
  // *****************************************
  // MARK: - Standard Table Cell Configuration
  // *****************************************
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
//  override func setSelected(selected: Bool, animated: Bool) {
//    super.setSelected(selected, animated: animated)
//    print("It was selected")
//  }
}
