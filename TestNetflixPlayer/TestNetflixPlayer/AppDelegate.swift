//
//  AppDelegate.swift
//  TestNetflixPlayer
//
//  Created by hyeoktae kwon on 2019/07/07.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  var shouldSupportAllOrientation = false

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = .white
    window?.rootViewController = PlayerVC()
    window?.makeKeyAndVisible()
    return true
  }
  
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    if shouldSupportAllOrientation {
      return UIInterfaceOrientationMask.all
    }
    return UIInterfaceOrientationMask.landscape
  }

  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
  }

  func applicationWillTerminate(_ application: UIApplication) {
  }


}

