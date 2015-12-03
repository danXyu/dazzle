//
//  DrawResultsViewController.swift
//  Dazzle
//
//  Created by Dan Xiaoyu Yu on 12/3/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit

class DrawResultsViewController: UIViewController {
  
  @IBOutlet weak var drawnImage: UIImageView!
  @IBOutlet weak var randomScore: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    randomScore.text = "25"
    drawnImage.image = savedImage
  }
}
