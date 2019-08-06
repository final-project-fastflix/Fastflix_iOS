//
//  AppDelegate.swift
//  Fastflix
//
//  Created by hyeoktae kwon on 2019/07/10.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow? 
  
  // false -> landscape || true -> portrait
  var shouldSupportAllOrientation = true
  
  
  static var instance: AppDelegate {
    return (UIApplication.shared.delegate as! AppDelegate)
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let launchScreenVC = LaunchScreenVC()
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = .clear
    window?.rootViewController = launchScreenVC
    window?.makeKeyAndVisible()
    topPadding = launchScreenVC.view.safeAreaInsets.top
    
    return true
  }
  
  // check landscapeState
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    if shouldSupportAllOrientation {
      return UIInterfaceOrientationMask.portrait
    }
    return UIInterfaceOrientationMask.landscape
  }
  
  func checkLoginState() {
    let beforeLoginVC = BeforeLoginVC()
    let beforeLoginNavi = UINavigationController(rootViewController: beforeLoginVC)
    let tabBar = MainTabBarController()
    
    // 유저디폴트에 저장되어있는 "token"값 확인
    let token = UserDefaults.standard.string(forKey: "token")
    
    
    // 1) "token"없을때 안내화면 -> 로그인화면
    
//    beforeLoginNavi.viewControllers = []
    
    // 2) "token"값 있을때 (로그인없이)홈화면
    
    
    // 🔶토큰값이 있을때 바로 로그인할때 서브유저리스트 확인 프로세스 추가🔶
    // 토큰이 있다면 =====> 서브유저리스트를 받아서 싱글톤에 저장 (유저디폴트로 변경 예정)
    if token != nil {
      beforeLoginVC.downloadUserList()
    }
    
    // "token"값 nil일때는 1)안내화면으로 / nil이 아닐때는 2) 홈화면으로
    let rootVC = token == nil ? beforeLoginNavi : tabBar
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = .clear
    window?.rootViewController = rootVC
    window?.makeKeyAndVisible()
    
  }
  
  func reloadRootView() {
    let madeByHeaji = LoadingVC()
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = .clear
    window?.rootViewController = madeByHeaji
    window?.makeKeyAndVisible()
  }
  

  func applicationWillResignActive(_ application: UIApplication) {}
  func applicationDidEnterBackground(_ application: UIApplication) {}
  func applicationWillEnterForeground(_ application: UIApplication) {}
  func applicationDidBecomeActive(_ application: UIApplication) {}
  func applicationWillTerminate(_ application: UIApplication) {}

}


