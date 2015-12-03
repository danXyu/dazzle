//
//  DrawViewController.swift
//  Dazzle
//
//  Created by Dan Xiaoyu Yu on 12/3/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit

class DrawViewController: UIViewController {
  
  
  @IBOutlet weak var QuestionLabel: UILabel!
  @IBOutlet var drawingPAd: ACEDrawingView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    QuestionLabel.text = selectedTask?.objectForKey("title") as? String
  }
  
  @IBAction func clickedFinished(sender: UIButton) {
    savedImage = self.drawingPAd.image
    self.performSegueWithIdentifier("finishedDrawing", sender: self)
  }
}