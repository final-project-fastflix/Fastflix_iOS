//
//  MyContentVC.swift
//  Fastflix
//
//  Created by Jeon-heaji on 25/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
// 내가 찜한 콘텐츠 컨트롤러

class MyContentVC: UIViewController {
  
  lazy var myContentView = MyContentView()
  
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
    
  
  }
  
  override func loadView() {
    
    self.view = myContentView
    view.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    myContentView.delegate = self
    myContentView.contentDelegate = self
  }
  
  private func setupNavi() {
    title = "내가 찜한 콘텐츠"
    navigationController?.setNavigationBarHidden(false, animated: true)
    self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    self.setNeedsStatusBarAppearanceUpdate()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "❮", style: .done, target: nil, action: nil)
    navigationController?.navigationBar.tintColor = .white
  }
  
  
}

extension MyContentVC: MyContentViewDelegate {
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    
    
    print("스크롤이 됩니당")
    
    //    if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
    //
    //      UIView.animate(withDuration: 1.5) {
    //        self.navigationController?.hidesBarsOnSwipe = true
    //        UIView.animate(withDuration: 1.7, animations: {
    //          self.navigationController?.navigationBar.alpha = 0
    //        })
    //
    //                print("내려감")
    //      }
    //
    //    } else {
    //      UIView.animate(withDuration: 1.5) {
    //        print("animate")
    //        self.navigationController?.hidesBarsOnSwipe = false
    //        self.navigationController?.setNavigationBarHidden(false, animated: false)
    //        UIView.animate(withDuration: 1.7, animations: {
    //          self.navigationController?.navigationBar.alpha = 1
    //
    //        })
    //                print("올라감??")
    //      }
    //
    //    }
  }
}

extension MyContentVC: SubTableCellDelegate {
  
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
