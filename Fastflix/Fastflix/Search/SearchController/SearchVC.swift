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
    searchView.searchDelegate = self
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}


extension SearchVC: SearchViewDelegate {
  func searchMovies(key: String, completion: @escaping (Result<SearchMovie, ErrorType>) -> ()) {
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

extension SearchVC: SubTableCellDelegate {
  func didSelectItemAt(movieId: Int, movieInfo: MovieDetail) {
    
    DispatchQueue.main.async {
      let detailVC = DetailVC()
      detailVC.movieId = movieId
      detailVC.movieDetailData = movieInfo
      self.present(detailVC, animated: true)
    }
  }
  
  func errOccurSendingAlert(message: String, okMessage: String) {
    
    let message = """
        죄송합니다. 해당 영화에 대한 정보를 가져오지
        못했습니다. 다시 시도해 주세요.
        """
    DispatchQueue.main.async {
      self.oneAlert(title: "영화데이터 오류", message: message, okButton: "재시도")
    }
  }
}
