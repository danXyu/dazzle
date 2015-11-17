//
//  AppDelegate.swift
//  Dazzle
//
//  Created by Dan Xiaoyu Yu on 11/16/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4


//  ************
//  App Delegate
//  ************


/* Application Start: App Delegate
* --------------------------------
* Provide the necessary configuration for Parse and Facebook Integration and redirect user to login/signup
* screen if user is not currently active. Register push notifications and then configure FB-SDK to accept
* incoming and outgoing REST api calls.
*/
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    Parse.setApplicationId(parseAppId, clientKey: parseAppSecret)
    PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
    PFUser.enableRevocableSessionInBackground()
    
    PFUser.logOutInBackground()
    
    if PFUser.currentUser() == nil || !PFUser.currentUser()!.isAuthenticated() {
      let redirectLogin = mainBoard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
      window!.rootViewController = redirectLogin
    }
    
    return true
  }
  
  func application(application: UIApplication,
    openURL url: NSURL,
    sourceApplication: String?,
    annotation: AnyObject) -> Bool {
      return FBSDKApplicationDelegate.sharedInstance().application(application,
        openURL: url,
        sourceApplication: sourceApplication,
        annotation: annotation)
  }
  
  func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    UIApplication.sharedApplication().registerForRemoteNotifications()
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    print(error.localizedDescription)
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    let currentInstallation = PFInstallation.currentInstallation()
    currentInstallation.setDeviceTokenFromData(deviceToken)
    currentInstallation.saveInBackgroundWithBlock(nil)
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    NSNotificationCenter.defaultCenter().postNotificationName("displayMessage", object: userInfo)
    NSNotificationCenter.defaultCenter().postNotificationName("reloadMessages", object: nil)
  }
  
  func applicationWillResignActive(application: UIApplication) {}
  
  func applicationDidEnterBackground(application: UIApplication) {}
  
  func applicationWillEnterForeground(application: UIApplication) {}
  
  func applicationDidBecomeActive(application: UIApplication) {FBSDKAppEvents.activateApp()}
  
  func applicationWillTerminate(application: UIApplication) {}
}

