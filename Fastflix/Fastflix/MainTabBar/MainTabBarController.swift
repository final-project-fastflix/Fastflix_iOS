//
//  MainTabBarController.swift
//  Fastflix
//
//  Created by hyeoktae kwon on 2019/07/16.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

final class MainTabBarController: UITabBarController {
  
  let subUserSingle = SubUserSingleton.shared
  
  // MARK: - Properties
  private let mainHomeVC = MainHomeVC()
  private let downloadVC = DownloadVC()
  private let seeMoreVC = SeeMoreVC()
  private let searchVC = SearchVC()
  
  private let faceRecogVC = FaceRecognitionVC()
  private let faceResultVC = FaceResultVC()
  
  
  private lazy var navi: UINavigationController = {
    let navi = UINavigationController(rootViewController: seeMoreVC)
    return navi
  }()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabBar()
//    userSetting()
  }
  
//  private func userSetting() {
//    print("유저셋팅 되긴함???")
//    let user = subUserSingle.subUserList?.filter { $0.id == APICenter.shared.getSubUserID()
//    mainHomeVC.userName = user?[0].name
//  }
  
  
  private func setupTabBar() {
    installTabBarItems()
    
    tabBar.tintColor = .white
    tabBar.backgroundImage = UIImage(named: "black")
    
    self.viewControllers = [mainHomeVC, searchVC, faceRecogVC, navi]
  }
  
  private func installTabBarItems() {
    let homeVCItem = UITabBarItem(title: "홈", image: UIImage(named: "tabBarhome2"), tag: 0)
    let searchVCItem = UITabBarItem(title: "검색", image: UIImage(named: "tabBarSearch1"), tag: 1)
//    let downloadVCItem = UITabBarItem(title: "얼굴 인식", image: UIImage(named: "tabBarDownLoad1"), tag: 2)
    let faceItem = UITabBarItem(title: "얼굴 인식", image: UIImage(named: "selfie"), tag: 2)
    let seeMoreVCItem = UITabBarItem(title: "더 보기", image: UIImage(named: "tabBarSeeMore1"), tag: 3)
    
//    downloadVCItem.badgeValue = "☁︎"
//    downloadVCItem.badgeColor = .blue
    
    mainHomeVC.tabBarItem = homeVCItem
    searchVC.tabBarItem = searchVCItem
//    faceRecogVC.tabBarItem = downloadVCItem
    faceRecogVC.tabBarItem = faceItem
    navi.tabBarItem = seeMoreVCItem

  }
  
  // what is it?
  func playBounceAnimation(_ icon : UIImageView) {
    
    let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
    bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
    bounceAnimation.duration = 2
    bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
    //      bounceAnimation.calculationMode = kCAAnimationCubic
    
    icon.layer.add(bounceAnimation, forKey: "bounceAnimation")
    
  }
  
}
