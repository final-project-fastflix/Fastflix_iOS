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
  
  lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    return collectionView
  }()
  
  lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: topPadding + 5, width: UIScreen.main.bounds.size.width, height: 30))
    return searchBar
  }()
  lazy var offset = UIOffset(horizontal: (searchBar.frame.width - 100) / 2, vertical: 0)
  let noOffset = UIOffset(horizontal: 0, vertical: 0)
  

  
  override func didMoveToSuperview() {
    addSubViews()
    setupCollectionView()
    setupSNP()
    setupSearch()
    registerCollectionViewCell()
    searchBar.becomeFirstResponder()
    
  }
  
  private func addSubViews() {
    [collectionView, searchBar]
      .forEach { self.addSubview($0) }
    
  }
  
  private func setupSNP() {
    
    collectionView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalToSuperview().offset((topPadding + searchBar.frame.height + 5))
    }
    
  }
  
  private func setupSearch() {
    searchBar.delegate = self
    searchBar.placeholder = "검색"
    
    searchBar.searchBarStyle = .minimal
    searchBar.keyboardAppearance = UIKeyboardAppearance.dark
    searchBar.barStyle = .black
    searchBar.setPositionAdjustment(offset, for: .search)
    
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
    //        cell.configure(imageUrlString: ImagesData.shared.myContentImages[indexPath.row])
    cell.delegate = self
    return cell
  }
  
  
}
extension SearchView: UICollectionViewDelegate {
  
}

extension SearchView: UISearchBarDelegate {
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    searchBar.setPositionAdjustment(noOffset, for: .search)
    print("should begin")
    return true
  }
  
  func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
    
//    searchBar.setPositionAdjustment(offset, for: .search)
    print("end")
//    if searchBar.text?.isEmpty == false {
//      searchBar.setPositionAdjustment(offset, for: .search)
//      print("되나여")
//    }
    return true
  }
  
}


extension SearchView: SearchCollectionCellDelegate {
  func resignKeyboard() {
    self.searchBar.resignFirstResponder()
  }
}
