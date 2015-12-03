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
  @IBOutlet weak var termsText: UILabel!
  
  // *************************************
  // MARK: - View Controller Configuration
  // *************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    signInButton.layer.borderWidth = 2
    signInButton.layer.borderColor = backgroundColor
    signInButton.layer.cornerRadius = 30
    
    signUpButton.layer.borderWidth = 2
    signUpButton.layer.borderColor = backgroundColor
    signUpButton.layer.cornerRadius = 30
    
    termsText.lineBreakMode = .ByWordWrapping
    termsText.numberOfLines = 0
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
}