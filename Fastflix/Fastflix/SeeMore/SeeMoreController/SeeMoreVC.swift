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

  // MARK: - loadView() 뷰체인지
  override func loadView() {
    let seeMoreView = SeeMoreView()
    self.view = seeMoreView
    seeMoreView.delegate = self
  }
  
  // MARK: - viewDidLoad()
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    view.backgroundColor = #colorLiteral(red: 0.05203045685, green: 0.05203045685, blue: 0.05203045685, alpha: 1)
    setupNavi()
    
    let seeMoreView = SeeMoreView()
    self.view = seeMoreView
    seeMoreView.delegate = self
    setupNavi()

  }
  
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - 네비게이션바 투명처리
  private func setupNavi() {
    navigationController?.setNavigationBarHidden(true, animated: true)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    
    // MARK: - navigationItem
    navigationController?.navigationBar.barStyle = .blackTranslucent
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationController?.navigationBar.tintColor = .white
    
  }
}

extension SeeMoreVC: SeeMoreViewDelegate {
  
  // MARK: - 델리게이트 실행 - "프로필 관리 버튼 눌렀을 때"
  func profileAdminButtonDidTap() {
    // 프로필선택화면 띄움 - 로그인쪽의 뷰컨트롤러 재활용
    let profileSelectVC = ProfileSelectVC()
    let navi = UINavigationController(rootViewController: profileSelectVC)
    
    // (로그인화면이 아닌) Seemore화면에서 넘어갔다는 속성을 "true"로 넘겨줌 - true일경우, 유저선택화면이 아닌 바로 유저편집으로 넘어감
    profileSelectVC.isFromSeeMoreView = true
    self.present(navi, animated: true) {
      profileSelectVC.changeButtonTapped()
    }
  }
  
  // MARK: - "프로필 추가 버튼을 눌렀을 때"
  func addProfileButtonDidTap() {
    // 프로필선택화면 띄움
    let profileSelectVC = ProfileSelectVC()
    let navi = UINavigationController(rootViewController: profileSelectVC)
    
    // 유저편집으로 넘어가기
    profileSelectVC.isFromSeeMoreView = true
    
    // 뷰 띄우고나서 바로 프로필추가 누른 효과
    self.present(navi, animated: true) {
      profileSelectVC.addProfileButtonTapped()
    }
  
  }
  
  // MARK: - "로그아웃 셀의 버튼 눌렀을 때"
  func logoutCellDidTap(indexPath: IndexPath) {
    switch indexPath {
    case IndexPath(row: 0, section: 0): break
      
    case IndexPath(row: 0, section: 1):
  
      let mycontentVC = MyContentVC()
      
      var imgPaths: [String] = []
      var movieIDArr: [Int] = []
      
      APICenter.shared.getListOfFork {
        switch $0 {
        case .success(let list):
          
          for i in 0...list.count - 1 {
            imgPaths.append(list[i].verticalImage)
            movieIDArr.append(list[i].id)
          }
          DispatchQueue.main.async {
            mycontentVC.myContentView.configure(url: imgPaths, movieIDs: movieIDArr)
            self.navigationController?.show(mycontentVC, sender: nil)

          }
          
        case .failure(let err):
          print("fail to parsing, reason: ", err)
          let message = """
          죄송합니다. 찜 정보를 가져오는데
          실패했습니다.
          다시 시도하세요.
          """
          self.oneAlert(title: "실패", message: message, okButton: "찜 목록 다시 확인하기")
        }
      }
    case IndexPath(row: 0, section: 2):
      let downLoadVC = DownloadVC()
      navigationController?.show(downLoadVC, sender: nil)
      
    case IndexPath(row: 1, section: 3):
      
      let iconVC = IconVC()
      navigationController?.show(iconVC, sender: nil)
      
    case IndexPath(row: 2, section: 3):
      
      
      let iconVC = IconVC()
      navigationController?.show(iconVC, sender: nil)
//
//      let loadingVC = LoadingVC()
//      navigationController?.show(loadingVC, sender: nil)


    case IndexPath(row: 3, section: 3):
      
      let customerCVC = CustomerCenterVC()
      navigationController?.show(customerCVC, sender: nil)
//      navigationItem.setHidesBackButton(true, animated: true)
      
    case IndexPath(row: 4, section: 3):
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
