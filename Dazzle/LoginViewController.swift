//
//  LoginViewController.swift
//  Dazzle
//
//  Created by Dan Yu 11/17/15.
//  Copyright (c) 2015 Dan Yu. All rights reserved.
//


import Foundation
import UIKit
import MBProgressHUD
import Parse
import ParseFacebookUtilsV4
import FBSDKCoreKit


// ***************************
// MARK: - LoginViewController
// ***************************

class LoginViewController: UIViewController , UITextFieldDelegate{
  
  
  @IBOutlet var titleLabel : UILabel!
  
  @IBOutlet var userContainer : UIView!
  @IBOutlet var userLabel : UILabel!
  @IBOutlet var userTextField : UITextField!
  @IBOutlet var userUnderline : UIView!
  
  @IBOutlet var passwordContainer : UIView!
  @IBOutlet var passwordLabel : UILabel!
  @IBOutlet var passwordTextField : UITextField!
  @IBOutlet var passwordUnderline : UIView!
  
  @IBOutlet var forgotPassword : UIButton!
  @IBOutlet var noAccountButton : UIButton!
  @IBOutlet var signInButton : UIButton!
  @IBOutlet var facebookButton : UIButton!
  
  
  // *************************************
  // MARK: - View Controller Configuration
  // *************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.passwordTextField.delegate = self
    self.userTextField.delegate = self
    
    userContainer.backgroundColor = UIColor.clearColor()
    userLabel.text = "Email"
    userLabel.textColor = UIColor.blackColor()
    userLabel.font = UIFont(name: defaultFont, size: 18)
    userTextField.text = ""
    userTextField.textColor = UIColor.blackColor()
    userTextField.font = UIFont(name: defaultFont, size: 18)
    
    passwordContainer.backgroundColor = UIColor.clearColor()
    passwordLabel.text = "Password"
    passwordLabel.textColor = UIColor.blackColor()
    passwordLabel.font = UIFont(name: defaultFont, size: 18)
    passwordTextField.text = ""
    passwordTextField.textColor = UIColor.blackColor()
    passwordTextField.font = UIFont(name: defaultFont, size: 18)
    passwordTextField.secureTextEntry = true
    
    signInButton.setTitle("Sign In", forState: .Normal)
    signInButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    signInButton.titleLabel?.font = UIFont(name: defaultFont, size: 22)
    signInButton.layer.borderWidth = 3
    signInButton.layer.borderColor = UIColor.redColor().CGColor
    signInButton.layer.cornerRadius = 30
    signInButton.addTarget(self, action: "loginNormal", forControlEvents: .TouchUpInside)
  }
  
  override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    titleLabel.hidden = newCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    return true
  }
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    //    textField.resignFirstResponder()
    self.view.endEditing(true)
    return false
  }
  
  // ***************************
  // MARK: - Parse Login Methods
  // ***************************
  
  func loginNormal() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    var newUsername = userTextField.text
    var newPassword = passwordTextField.text
    
    PFUser.logInWithUsernameInBackground(newUsername!, password: newPassword!, block: { (newUser: PFUser?, newError: NSError?) -> Void in
      if newUser != nil {
        currentUser = newUser!
        if UIDevice.currentDevice().model != "iPhone Simulator" {
          let currentInstallation = PFInstallation.currentInstallation()
          currentInstallation["user"] = currentUser
          currentInstallation.saveInBackground()
        }
        self.performSegueWithIdentifier("loginSuccess", sender: self)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
      } else {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        if let errorString = newError!.userInfo["error"] as? NSString {
          var alert = UIAlertView(title: "Error", message: errorString as String, delegate: self, cancelButtonTitle: "okay")
          alert.show()
        }
      }
      
    })
  }
}
