//
//  SeeMoreVC.swift
//  Fastflix
//
//  Created by Jeon-heaji on 18/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
// 
import UIKit
import SnapKit

class SeeMoreVC: UIViewController {
  
  let subUserSingle = SubUserSingleton.shared
  
//  var profileCount = 0
//  var viewArr: [ProfileView] = []

  override func loadView() {
    let seeMoreView = SeeMoreView()
    self.view = seeMoreView
//    seeMoreView.profileStackView.addArrangedSubview(viewArr)
    seeMoreView.delegate = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 0.05203045685, green: 0.05203045685, blue: 0.05203045685, alpha: 1)
    setupNavi()
    setupUsers()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // profile 생성
//  func makeProfileView() {
//    // 0일때 5일때 예외처리
//    for idx in 0...profileCount {
//      let view: ProfileView = {
//        let view = ProfileView()
//        //        view.configure(image: <#T##UIImage?#>, name: <#T##String?#>)
//        return view
//      }()
//      viewArr.append(view)
//    }
//  }
  
  func setupUsers() {
    
    
    
    
  }
  
  
  
  
  private func setupNavi() {
    navigationController?.setNavigationBarHidden(false, animated: true)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    
    
  }
  
  

}
extension SeeMoreVC: SeeMoreViewDelegate {
  func addProfileButtonDidTap() {
    let profileSelectVC = ProfileSelectVC()
    let navi = UINavigationController(rootViewController: profileSelectVC)
    profileSelectVC.isFromSeeMoreView = true
    self.present(navi, animated: true) {
      profileSelectVC.changeButtonTapped()
    }
  
  }
  
  
  func logoutCellDidTap(indexPath: IndexPath) {
    switch indexPath {
    case IndexPath(row: 0, section: 0): break
      
    case IndexPath(row: 0, section: 1):
      print("내가 찜한 콘텐츠 ")
  
      let mycontentVC = MyContentVC()
      navigationController?.show(mycontentVC, sender: nil)
//      navigationController?.navigationBar.isHidden = true
      navigationItem.setHidesBackButton(true, animated: true)

      
    case IndexPath(row: 0, section: 2):
      print("앱설정")
    case IndexPath(row: 4, section: 2):
      print("로그아웃")
      self.alert(title: "로그아웃", message: "로그아웃하시겠어요?") {
        let path = UserDefaults.standard
        path.removeObject(forKey: "token")
        AppDelegate.instance.checkLoginState()
        
        print("로그아웃됨")
      }
      
    default:
      break
    }
  }
  
}
