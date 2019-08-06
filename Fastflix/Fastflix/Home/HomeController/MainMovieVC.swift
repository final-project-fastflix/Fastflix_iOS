//
//  MainMovieVC.swift
//  Fastflix
//
//  Created by hyeoktae kwon on 2019/07/23.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit
import Alamofire

class MainMovieVC: UIViewController {
  
  let categoryVC = CategorySelectVC()
  
  let mainMovieView = MainMovieView()
  
  var receiveData: RequestMovie? = nil {
    willSet(new) {
      receiveKeys = new?[0].listOfGenre
    }
  }
  
  lazy var receiveKeys: [String]? = nil
  
//  override func loadView() {
//    mainMovieView.receiveKeys = receiveKeys
//    mainMovieView.receiveData = receiveData
//    mainMovieView.floatingView.delegate = self
//    categoryVC.delegate = self
//    self.view = mainMovieView
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainMovieView.receiveKeys = receiveKeys
    mainMovieView.receiveData = receiveData
    mainMovieView.floatingView.delegate = self
    categoryVC.delegate = self
//    self.view = mainMovieView
    view.addSubview(mainMovieView)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupSNP()
  }
  
  func setupSNP() {
    mainMovieView.snp.makeConstraints {
      $0.top.leading.bottom.trailing.equalToSuperview()
    }
  }
  
  // 카테고리 선택했을때 메인 영화정보를 바꾸기 위해서 데이터리로드
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    mainMovieView.tableView.reloadData()
//  }

}

extension MainMovieVC: FloatingViewDelegate {
  func didTapHome() {
    AppDelegate.instance.checkLoginState()
  }
  
  func didTapMovie() {
//    let mainMovieVC = self
//    mainMovieVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "tabBarhome2"), tag: 0)
//    tabBarController?.viewControllers?[0] = mainMovieVC
    
    categoryVC.modalPresentationStyle = .overCurrentContext
    UIView.animate(withDuration: 0.7) {
      self.present(self.categoryVC, animated: false)
    }
  }
  
  func didTapPoke() {
    let mainPokeVC = MainPokeVC()
    mainPokeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "tabBarhome2"), tag: 0)
    tabBarController?.viewControllers?[0] = mainPokeVC
  }
  
  
  
  func didTapGenreCategory() {
    
    
    UIView.animate(withDuration: 0.7) {
      self.present(self.categoryVC, animated: false)
    }
  }
  
}

extension MainMovieVC: CategorySelectVCDelegate {
  func sendData(data: [RequestMovieElement], keys: [String]) {
//    let view = self.view as! MainMovieView
    print("runrun")
    mainMovieView.receiveData = data
    mainMovieView.receiveKeys = keys
    mainMovieView.tableView.reloadData()
    categoryVC.dismiss(animated: true)
  }
  
  
}
