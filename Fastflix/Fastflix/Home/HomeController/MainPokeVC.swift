//
//  MainPokeVC.swift
//  Fastflix
//
//  Created by hyeoktae kwon on 2019/07/23.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class MainPokeVC: UIViewController {
  
  // floatingView를 움직이기위한 properties
  var originValue: CGFloat = 0
  var compareArr: [CGFloat] = []
  var originY: CGFloat {
    get {
      return floatingView.frame.origin.y
    }
    set {
      guard newValue >= -floatingView.frame.height || newValue <= 0 else { return }
      floatingView.frame.origin.y = newValue
    }
  }
  
  private lazy var floatingView: FloatingView = {
    let view = FloatingView()
    view.delegate = self
    return view
  }()
  
  lazy var mainPokeView = MainPokeView()
  
  let path = DataCenter.shared
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavi()
    
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainPokeView.floatingView.delegate = self
    
  }
  
  override func loadView() {
    
    self.view = mainPokeView
    view.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    mainPokeView.contentDelegate = self
  }
  
  private func setupNavi() {
    title = "내가 찜한 콘텐츠"
    navigationController?.setNavigationBarHidden(true, animated: true)
    self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    self.setNeedsStatusBarAppearanceUpdate()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "❮", style: .done, target: nil, action: nil)
    navigationController?.navigationBar.tintColor = .white
  }
  
  
}

extension MainPokeVC: SubTableCellDelegate {
  
  func didSelectItemAt(movieId: Int, movieInfo: MovieDetail) {
    // 영화 화면에서 디테일뷰 띄우기
    DispatchQueue.main.async {
//      print("영화정보 디테일: ", movieId, movieInfo.name)
      let detailVC = DetailVC()
      detailVC.movieId = movieId
      detailVC.movieDetailData = movieInfo
      
      self.present(detailVC, animated: true)
    }
  }
  
  func errOccurSendingAlert(message: String, okMessage: String) {
    self.oneAlert(title: "영화데이터 오류", message: message, okButton: okMessage)
  }
  
}

extension MainPokeVC: FloatingViewDelegate {
  func didTapHome() {
    AppDelegate.instance.checkLoginState()
  }
  
  func didTapMovie() {
    
    APICenter.shared.getMovieData {
      switch $0 {
      case .success(let value):
        
        DispatchQueue.main.async {
          let mainMovieVC = MainMovieVC()
          mainMovieVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "tabBarhome2"), tag: 0)
          mainMovieVC.receiveData = value
          self.tabBarController?.viewControllers?[0] = mainMovieVC
        }
      case .failure(let err):
        dump(err)
      }
    }
  }
  
  func didTapPoke() {
//    print("일단 눌러는 지는 겁니까????")
    
    
  }
}

