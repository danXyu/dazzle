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

class ForgotViewController: UIViewController {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  @IBOutlet var titleLabel : UILabel!
  @IBOutlet var bgImageView : UIImageView!
  
  @IBOutlet var userContainer : UIView!
  @IBOutlet var userLabel : UILabel!
  @IBOutlet var userTextField : UITextField!
  @IBOutlet var userUnderline : UIView!
  
  @IBOutlet var resetPasswordButton : UIButton!
  @IBOutlet var hasAccountButton : UIButton!
  
  
  // *************************************
  // MARK: - View Controller Configuration
  // *************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bgImageView.image = UIImage(named: "LoginBackgroundBeta")
    bgImageView.contentMode = .ScaleAspectFill
    
    titleLabel.text = "Reset Password"
    titleLabel.textColor = UIColor.whiteColor()
    
    if (phoneHeight >= 667) {
      titleLabel.font = UIFont(name: defaultFont, size: 50)
    }
    
    let attributedText = NSMutableAttributedString(string: "Already have an account? Sign In")
    attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(25, 7))
    attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attributedText.length))
    hasAccountButton.setAttributedTitle(attributedText, forState: .Normal)
    hasAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    hasAccountButton.titleLabel?.font = UIFont(name: defaultFont, size: 12)
    
    userContainer.backgroundColor = UIColor.clearColor()
    userLabel.text = "Email"
    userLabel.textColor = UIColor.whiteColor()
    userLabel.font = UIFont(name: defaultFont, size: 18)
    userTextField.text = ""
    userTextField.textColor = UIColor.whiteColor()
    userTextField.font = UIFont(name: defaultFont, size: 18)
    
    resetPasswordButton.setTitle("Reset Password", forState: .Normal)
    resetPasswordButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    resetPasswordButton.titleLabel?.font = UIFont(name: defaultFont, size: 22)
    resetPasswordButton.layer.borderWidth = 3
    resetPasswordButton.layer.borderColor = UIColor.whiteColor().CGColor
    resetPasswordButton.layer.cornerRadius = 5
    resetPasswordButton.addTarget(self, action: "resetPassword", forControlEvents: .TouchUpInside)
  }

  override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    titleLabel.hidden = newCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  
  // ***********************************
  // MARK: - Parse Reset Password Method
  // ***********************************
  
  func resetPassword() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    let emailAddress = userTextField.text
    
    if (emailAddress == "") {
      let alertController = UIAlertController(title: "Form Field Error", message: "You must provide an email address", preferredStyle: .Alert)
      alertController.addAction(UIAlertAction(title: "Try Again", style: .Default, handler: nil))
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      self.presentViewController(alertController, animated: true, completion: nil)
      
    } else {
      PFUser.requestPasswordResetForEmailInBackground(emailAddress!) { (succeeded, error) -> Void in
        if let error = error {
          let alertController = UIAlertController(title: "Account Error", message: error.localizedDescription, preferredStyle: .Alert)
          alertController.addAction(UIAlertAction(title: "Try Again", style: .Default, handler: nil))
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          self.presentViewController(alertController, animated: true, completion: nil)
          
        } else {
          let alertController = UIAlertController(title: "Password Reset Successful", message: "Please check your email", preferredStyle: .Alert)
          alertController.addAction(UIAlertAction(title: "Continue", style: .Default, handler: nil))
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          self.presentViewController(alertController, animated: true, completion: nil)
          self.performSegueWithIdentifier("forgotSuccess", sender: self)
        }
      }
    }
  }
}
