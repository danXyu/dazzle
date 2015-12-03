//
//  Configuration.swift
//  Dazzle
//
//  Created by Dan Xiaoyu Yu on 11/17/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit
import Parse
import FBSDKCoreKit


// Parse Settings
var parseAppId = "70cCU050OAaKQNbCmbUc5WTRqPWpmw26q9VhnNSm"
var parseAppSecret = "pMioLcIugIa9HbJUzlh1TZCZec6CsHotva1I974D"

// Device Settings
let Device = UIDevice.currentDevice()
let phoneWidth = UIScreen.mainScreen().bounds.width
let phoneHeight = UIScreen.mainScreen().bounds.height
let mainBoard = UIStoryboard(name: "Main", bundle: nil)
var navbarHeight:CGFloat = 64
var tabbarHeight:CGFloat = 49

// Font Settings
var defaultFont: String = "Avenir-Light"

// Color Settings
//var backgroundColor: UIColor = UIColor.whiteColor()
//var tabbarColor: UIColor = UIColor(red: (203/256), green: (229/256), blue: (235/256), alpha: 1.0)
//var navbarColor: UIColor = UIColor(red: (203/256), green: (229/256), blue: (235/256), alpha: 1.0)
//var navbarTextColor: UIColor = UIColor.whiteColor()
//var textColor: UIColor = UIColor.blackColor()

var backgroundColor = UIColor(red: (237.0/255.5), green: (95.0/255.0), blue: (57.0/255.0), alpha: 1.0).CGColor
var tabbarColor: UIColor = UIColor(red: 0.0, green: (122.0/255.0), blue: 1.0, alpha: 1.0)
var tabbarTextColor: UIColor = UIColor.blackColor()
var navbarColor: UIColor = UIColor(red: 0.0, green: (122.0/255.0), blue: 1.0, alpha: 1.0)
var navbarTextColor: UIColor = UIColor.whiteColor()
var textColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.8)

// Version Settings
let iosVersion = NSString(string: Device.systemVersion).doubleValue
let iOS8 = iosVersion >= 8
let iOS7 = iosVersion >= 7 && iosVersion < 8

// Current User Settings
let userPF = PFUser()
var currentUser = PFUser.currentUser()!
var hasSignedUp = false
var selectedTask: PFObject? = nil
var answers: [String]? = nil

/* Helper Function: scaleImage(image, newSize) */
func scaleImage(image:UIImage, newSize:CGFloat) -> UIImage {
  UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize, height: newSize), false, 0.0)
  image.drawInRect(CGRectMake(0, 0, newSize, newSize))
  let newImage = UIGraphicsGetImageFromCurrentImageContext()
  return newImage
}

/* Helper Function: getImage(forKey, imgView) */
func getImage(forKey:String, imgView:UIImageView) {
  if let pic = currentUser.objectForKey(forKey) as? PFFile {
    pic.getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) -> Void in
      if error == nil {
        imgView.image = UIImage(data: data!)
      }
    })
  }
}