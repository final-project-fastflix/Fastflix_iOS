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
  
  override func loadView() {
    self.view = searchView
    searchView.delegate = self
    view.backgroundColor = #colorLiteral(red: 0.05203045685, green: 0.05203045685, blue: 0.05203045685, alpha: 1)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}


extension SearchVC: SearchViewDelegate {
  func searchMovies(key: String, completion: @escaping (Result<SearchMovie, ErrorType>) -> ()) {
    print("서치함")
    APICenter.shared.searchMovie(searchKey: key) { (result) in
      switch result {
      case .success(let value):
        print("Test ", value)
        completion(.success(value))
      case .failure(let err):
        print("Test ", err)
        completion(.failure(.networkError))
      }
    }
  }
  
  
}
