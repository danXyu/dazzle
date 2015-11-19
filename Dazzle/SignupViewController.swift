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
import ParseFacebookUtilsV4
import FBSDKCoreKit


// ***************************
// MARK: - LoginViewController
// ***************************


class SignupViewController: UIViewController, UITextFieldDelegate {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
    
  @IBOutlet var fullNameContainer : UIView!
  @IBOutlet var fullNameLabel : UILabel!
  @IBOutlet var fullNameTextField : UITextField!
  @IBOutlet var fullNameUnderline : UIView!
  
  @IBOutlet var userContainer : UIView!
  @IBOutlet var userLabel : UILabel!
  @IBOutlet var userTextField : UITextField!
  @IBOutlet var userUnderline : UIView!
  
  @IBOutlet var passwordContainer : UIView!
  @IBOutlet var passwordLabel : UILabel!
  @IBOutlet var passwordTextField : UITextField!
  @IBOutlet var passwordUnderline : UIView!
  
  @IBOutlet var passwordConfirmContainer : UIView!
  @IBOutlet var passwordConfirmLabel : UILabel!
  @IBOutlet var passwordConfirmTextField : UITextField!
  @IBOutlet var passwordConfirmUnderline : UIView!
  
  @IBOutlet var signUpButton : UIButton!
  
  var alertError: NSString!
  
  
  // *************************************
  // MARK: - View Controller Configuration
  // *************************************
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.fullNameTextField.delegate = self
    self.userTextField.delegate = self
    self.passwordConfirmTextField.delegate = self
    self.passwordTextField.delegate = self
    
    fullNameContainer.backgroundColor = UIColor.clearColor()
    fullNameLabel.text = "Full Name"
    fullNameLabel.textColor = UIColor.whiteColor()
    fullNameLabel.font = UIFont(name: defaultFont, size: 18)
    fullNameTextField.text = ""
    fullNameTextField.textColor = UIColor.whiteColor()
    fullNameTextField.font = UIFont(name: defaultFont, size: 18)
    
    userContainer.backgroundColor = UIColor.clearColor()
    userLabel.text = "Email"
    userLabel.textColor = UIColor.whiteColor()
    userLabel.font = UIFont(name: defaultFont, size: 18)
    userTextField.text = ""
    userTextField.textColor = UIColor.whiteColor()
    userTextField.font = UIFont(name: defaultFont, size: 18)
    
    passwordContainer.backgroundColor = UIColor.clearColor()
    passwordLabel.text = "Password"
    passwordLabel.textColor = UIColor.whiteColor()
    passwordLabel.font = UIFont(name: defaultFont, size: 18)
    passwordTextField.text = ""
    passwordTextField.textColor = UIColor.whiteColor()
    passwordTextField.font = UIFont(name: defaultFont, size: 18)
    passwordTextField.secureTextEntry = true
    
    passwordConfirmContainer.backgroundColor = UIColor.clearColor()
    passwordConfirmLabel.text = "Confirm Password"
    passwordConfirmLabel.textColor = UIColor.whiteColor()
    passwordConfirmLabel.font = UIFont(name: defaultFont, size: 18)
    passwordConfirmTextField.text = ""
    passwordConfirmTextField.textColor = UIColor.whiteColor()
    passwordConfirmTextField.font = UIFont(name: defaultFont, size: 18)
    passwordConfirmTextField.secureTextEntry = true
    
    signUpButton.setTitle("Sign Up", forState: .Normal)
    signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    signUpButton.titleLabel?.font = UIFont(name: defaultFont, size: 22)
    signUpButton.layer.borderWidth = 3
    signUpButton.layer.borderColor = UIColor.whiteColor().CGColor
    signUpButton.layer.cornerRadius = 5
    signUpButton.addTarget(self, action: "registerNormal", forControlEvents: .TouchUpInside)
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  
  // ****************************
  // MARK: - Parse Signup Methods
  // ****************************
  
  
  
  func registerNormal() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    if self.checkNormalSignup() == true {
      self.createNormalUser()
      
    } else {
      
      let alertController = UIAlertController(title: "Form Field Error", message: alertError as String, preferredStyle: .Alert)
      alertController.addAction(UIAlertAction(title: "Try Again", style: .Default, handler: nil))
      presentViewController(alertController, animated: true, completion: nil)
      MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
  }
  
  func checkNormalSignup()-> Bool {
    let name = fullNameTextField.text!.componentsSeparatedByString(" ")
    if fullNameTextField.text!.isEmpty || userTextField.text!.isEmpty || passwordTextField.text!.isEmpty || passwordConfirmTextField.text!.isEmpty {
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      alertError = "All form fields must be filled"
      return false
    } else if name.count < 2 {
      alertError = "Please provide your first AND last name"
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      return false
    } else if passwordTextField.text != passwordConfirmTextField.text {
      alertError = "Passwords did not match"
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      return false
    } else if userTextField.text!.characters.count < 5 {
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      alertError = "Username must be at least 5 characters long"
      return false
    } else if passwordTextField.text!.characters.count <= 6 {
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      alertError = "Password must be more than 6 characters long"
      return false
    }
    return true
  }
  
  func createNormalUser() {
    var name = fullNameTextField.text!.componentsSeparatedByString(" ")
    userPF.username = userTextField.text
    userPF.email = userTextField.text
    userPF.password = passwordTextField.text
    
    userPF["fullName"] = fullNameTextField.text
    userPF["firstName"] = name[0] as String
    userPF["lastName"] = name[1] as String
    userPF["school"] = "Generic High School"
    userPF["year"] = "Year Placeholder"
    
    userPF.signUpInBackgroundWithBlock {(succeeded, error) -> Void in
      if error == nil {
        hasSignedUp = true
        currentUser = userPF
        
        if UIDevice.currentDevice().model != "iPhone Simulator" {
          let currentInstallation = PFInstallation.currentInstallation()
          currentInstallation["user"] = currentUser
          currentInstallation.saveInBackground()
        }
        
        self.performSegueWithIdentifier("signupSuccess", sender: self)
        let alertController = UIAlertController(title: "Sign Up Success", message: "Sign up successful. Please confirm your email.", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .Default, handler: nil))
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.presentViewController(alertController, animated: true, completion: nil)
        
      } else {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if let errorString = error!.userInfo["error"] as? NSString {
          
          let alertController = UIAlertController(title: "Sign Up Error", message: errorString as String, preferredStyle: .Alert)
          alertController.addAction(UIAlertAction(title: "Try Again", style: .Default, handler: nil))
          self.presentViewController(alertController, animated: true, completion: nil)
        }
        
      }
    }
  }
}
