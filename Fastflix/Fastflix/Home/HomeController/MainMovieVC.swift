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
    mainMovieView.delegate = self
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

extension MainMovieVC: SubTableCellDelegate {
  func didSelectItemAt(movieId: Int, movieInfo: MovieDetail) {
    // 영화 화면에서 디테일뷰 띄우기
    DispatchQueue.main.async {
      print("영화정보 디테일: ", movieId, movieInfo.name)
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
