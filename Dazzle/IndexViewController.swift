//
//  LoginViewController.swift
//  Dazzle
//
//  Created by Dan Yu 11/17/15.
//  Copyright (c) 2015 Dan Yu. All rights reserved.
//



import Foundation
import UIKit
import Parse
import MBProgressHUD


// ****************************
// MARK: - ForgotViewController
// ****************************

class IndexViewController: UIViewController {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  

  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var signInButton: UIButton!
  
  
  // *************************************
  // MARK: - View Controller Configuration
  // *************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    signInButton.layer.borderWidth = 3
    signInButton.layer.borderColor = UIColor.redColor().CGColor
    signInButton.layer.cornerRadius = 30
    
    signUpButton.layer.borderWidth = 3
    signUpButton.layer.borderColor = UIColor.redColor().CGColor
    signUpButton.layer.cornerRadius = 30
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
}