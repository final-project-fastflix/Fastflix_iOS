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
import AVKit

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
    mainMovieView.mainDelegate = self
    
    categoryVC.delegate = self
    
    view.addSubview(mainMovieView)
    mainMovieView.delegate = self
    mainMovieView.myDelegate = self
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
  func sendText(text: String?) {
    DispatchQueue.main.async {
      self.mainMovieView.floatingView.movieBtn.setTitle(text, for: .normal)
    }
  }
  
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

extension MainMovieVC: MainMovieViewDelegate {
  func didTapPreview(indexPath: IndexPath, logoArr: [URL?]?, videoItems: [AVPlayerItem]?, idArr: [Int]?) {
    let preViewPlayerVC = PreViewPlayerVC()
    preViewPlayerVC.logoURLs = logoArr
    preViewPlayerVC.playerItems = videoItems
    preViewPlayerVC.idArr = idArr
    present(preViewPlayerVC, animated: true)
  }
}

extension MainMovieVC: MainImageTableCellDelegate {
  func mainImageCelltoDetailVC(id: Int) {
    
    let movieId = id
    
    APICenter.shared.getDetailData(id: movieId) {
      switch $0 {
      case .success(let movie):
        DispatchQueue.main.async {
          let detailVC = DetailVC()
          detailVC.movieId = movie.id
          detailVC.movieDetailData = movie
          self.present(detailVC, animated: true)
        }
      case .failure(let err):
        print("fail to login, reason: ", err)
        
        let message = """
        죄송합니다. 해당 영화에 대한 정보를 가져오지
        못했습니다. 다시 시도해 주세요.
        """
        DispatchQueue.main.async {
          self.oneAlert(title: "영화데이터 오류", message: message, okButton: "재시도")
        }
      }
    }
  }
  
  func playVideo(id: Int) {
    print("run playVideo")
    let player = PlayerVC()
    
    let movieId = id
    
    APICenter.shared.getDetailData(id: movieId) {
      switch $0 {
      case .success(let movie):
        print("디테일뷰 다시띄우기 위해 영화정보 다시 띄우기: ", movie.id, movie.name)
        
        // 영화 메인무비 정보
        let url = movie.videoFile
        let title = movie.name
        let id = movie.id
        
        DispatchQueue.main.async {
          player.configure(id: id, title: title, videoPath: url, seekTime: nil)
          AppDelegate.instance.shouldSupportAllOrientation = false
          self.present(player, animated: true)
        }
        
      case .failure(let err):
        print("fail to login, reason: ", err)
        
        let message = """
        죄송합니다. 해당 영화에 대한 정보를 가져오지
        못했습니다. 다시 시도해 주세요.
        """
        DispatchQueue.main.async {
          self.oneAlert(title: "영화 플레이 오류", message: message, okButton: "재시도")
        }
      }
    }
  }
}

