//
//  SearchVC.swift
//  Fastflix
//
//  Created by hyeoktae kwon on 2019/07/22.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit


class SearchVC: UIViewController {
  
  lazy var searchView = SearchView()


    override func viewDidLoad() {
        super.viewDidLoad()

    }
  override func loadView() {
    
    self.view = searchView
    view.backgroundColor = #colorLiteral(red: 0.05203045685, green: 0.05203045685, blue: 0.05203045685, alpha: 1)
  }
  

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }


}
