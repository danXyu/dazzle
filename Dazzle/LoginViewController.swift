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
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  @IBOutlet var titleLabel : UILabel!
  @IBOutlet var bgImageView : UIImageView!
  
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

    bgImageView.image = UIImage(named: "LoginBackgroundBeta")
    bgImageView.contentMode = .ScaleAspectFill
    
    titleLabel.text = "Dazzle"
    titleLabel.font = UIFont(name: defaultFont, size: 50)
    titleLabel.textColor = UIColor.whiteColor()
    
    let attributedText = NSMutableAttributedString(string: "Don't have an account? Sign up")
    attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(23, 7))
    attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attributedText.length))
    noAccountButton.setAttributedTitle(attributedText, forState: .Normal)
    noAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    noAccountButton.titleLabel?.font = UIFont(name: defaultFont, size: 12)
    
    forgotPassword.setTitle("Forgot Password?", forState: .Normal)
    forgotPassword.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    forgotPassword.titleLabel?.font = UIFont(name: defaultFont, size: 12)
    
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
    
    signInButton.setTitle("Sign In", forState: .Normal)
    signInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    signInButton.titleLabel?.font = UIFont(name: defaultFont, size: 22)
    signInButton.layer.borderWidth = 3
    signInButton.layer.borderColor = UIColor.whiteColor().CGColor
    signInButton.layer.cornerRadius = 5
    signInButton.addTarget(self, action: "loginNormal", forControlEvents: .TouchUpInside)
    
    facebookButton.setTitle("Sign in with Facebook", forState: .Normal)
    facebookButton.titleLabel?.font = UIFont(name: defaultFont, size: 16)
    facebookButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    facebookButton.backgroundColor = UIColor(red: 0.21, green: 0.30, blue: 0.55, alpha: 1.0)
    facebookButton.addTarget(self, action: "loginFacebook", forControlEvents: .TouchUpInside)
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
    let newUsername = userTextField.text
    let newPassword = passwordTextField.text
    
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
          let alertController = UIAlertController(title: "Error", message: errorString as String, preferredStyle: .Alert)
          alertController.addAction(UIAlertAction(title: "Try Again", style: .Default, handler: nil))
          self.presentViewController(alertController, animated: true, completion: nil)
        }
      }
      
    })
    
  }
  
  func loginFacebook() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    let permissions = ["public_profile", "email", "user_friends"]
    PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user: PFUser?, error: NSError?) -> Void in
      if let user = user {
        if user.isNew {
          NSLog("User signed up and logged in through Facebook!")
          hasSignedUp = true
          currentUser = user
          self.createFacebookUser()
        } else {
          NSLog("User logged in through Facebook!")
          currentUser = user
          if UIDevice.currentDevice().model != "iPhone Simulator" {
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation["user"] = currentUser
            currentInstallation.saveInBackground()
          }
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          self.performSegueWithIdentifier("loginSuccess", sender: self)
        }
      } else {
        NSLog("Something went wrong. User cancelled facebook Login")
        MBProgressHUD.hideHUDForView(self.view, animated: true)
      }
    }
  }
  
  func createFacebookUser() {
    FBSDKGraphRequest.init(graphPath: "me", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
      
      if let userEmail = result.objectForKey("email") as? String {
        currentUser.email = userEmail
      }
      
      let id = result.objectForKey("objectID") as! String
      let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?width=640&height=640")!
      let data = NSData(contentsOfURL: url)
      let image = UIImage(data: data!)
      let imageS = scaleImage(image!, newSize: 60)
      let dataS = UIImageJPEGRepresentation(imageS, 0.9)
      
      currentUser["fbId"] = result.objectForKey("objectID") as! String!
      currentUser["proPic"] = PFFile(name: "proPic.jpg", data: dataS!)
      currentUser["fullName"] = result.objectForKey("name") as! String!
      currentUser["firstName"] = result.objectForKey("first_name") as! String!
      currentUser["lastName"] = result.objectForKey("last_name") as! String!
      currentUser["school"] = "Generic High School"
      currentUser["year"] = "Year Placeholder"
      
      currentUser.saveInBackgroundWithBlock({ (done, error) -> Void in
        if !(error != nil) {
          if UIDevice.currentDevice(
            ).model != "iPhone Simulator" {
              let currentInstallation = PFInstallation.currentInstallation()
              currentInstallation["user"] = currentUser
              currentInstallation.saveInBackground()
          }
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          self.performSegueWithIdentifier("loginSuccess", sender: self)
        } else {
          
          print(error)
          MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
      })
    })
  }
}