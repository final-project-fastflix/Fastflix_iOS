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
    view.backgroundColor = .clear
    myContentView.delegate = self
  }
  
  private func setupNavi() {
//    navigationController?.navigationBar.addSubview(myContentView.topView)
    self.navigationController?.navigationBar.barTintColor = .clear
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    self.setNeedsStatusBarAppearanceUpdate()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "❮", style: .done, target: nil, action: nil)
    navigationController?.navigationBar.tintColor = .white
  }

}

extension MyContentVC: MyContentViewDelegate {
 
  
  func backBtnDidTap(backBtn: UIButton) {
    print("뒤로 가주세여..")
     navigationController?.popViewController(animated: true)

  }
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
