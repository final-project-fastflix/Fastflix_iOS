//
//  SearchView.swift
//  Fastflix
//
//  Created by Jeon-heaji on 27/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit


class SearchView: UIView {
  
  private let layout = UICollectionViewFlowLayout()
  
  let collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    return collectionView
  }()
  
  let searchController = UISearchController(searchResultsController: nil)

  override func didMoveToSuperview() {
    addSubViews()
    setupCollectionView()
    setupSNP()
    setupSearch()
    registerCollectionViewCell()
  }
  
  private func addSubViews() {
    [collectionView]
      .forEach { self.addSubview($0) }

  }
  
  private func setupSNP() {
    
    collectionView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }

  }
  
  private func setupSearch() {
    searchController.searchBar.delegate = self
    searchController.searchResultsUpdater = self
    searchController.searchBar.placeholder = "Search!"
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.tintColor = UIColor.white
    searchController.searchBar.barTintColor = UIColor.white
    searchController.searchBar.barStyle = .blackTranslucent
    searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
    
  }
  
  private func registerCollectionViewCell() {
    collectionView.register(SearchCollectionCell.self, forCellWithReuseIdentifier: SearchCollectionCell.identifier)
  }
  private func setupCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    layout.scrollDirection = .vertical
    collectionView.backgroundColor = .clear
    self.collectionView.collectionViewLayout = layout
    layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 20
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 4.3, height: UIScreen.main.bounds.height / 4)
    
    layout.sectionHeadersPinToVisibleBounds = true
    collectionView.showsHorizontalScrollIndicator = false
  }

}

extension SearchView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ImagesData.shared.myContentImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionCell.identifier, for: indexPath) as! SearchCollectionCell
        cell.configure(imageUrlString: ImagesData.shared.myContentImages[indexPath.row])
    return cell
  }
  
  
}
extension SearchView: UICollectionViewDelegate {
  
}


extension SearchView: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    print("검색중")
  }
  
}
extension SearchView: UISearchBarDelegate {
  
}
