//
//  AnswerCell.swift
//  Dazzle
//
//  Created by Dan Xiaoyu Yu on 12/3/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit
import Parse


// ******************
// MARK: - AnswerCell
// ******************

class AnswerCell: UITableViewCell {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  
  @IBOutlet weak var answer: UILabel!
  
  
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
