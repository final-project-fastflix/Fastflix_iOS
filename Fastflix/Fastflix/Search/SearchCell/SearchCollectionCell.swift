//
//  SearchCollectionCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 28/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

protocol SearchCollectionCellDelegate: class {
  func resignKeyboard()
  func passMovieId(movieId: Int)
}

class SearchCollectionCell: UICollectionViewCell {
  
  var movieId: Int?
  
  weak var delegate: SearchCollectionCellDelegate?
  
  static let identifier = "SearchCollectionCell"
  
  let searchImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleToFill
    return imageView
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSubViews()
    setupSNP()
    setupTapGestureForView()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    delegate?.resignKeyboard()
    self.contentView.endEditing(true)
    print("touchesBegan")
  }
  
  private func addSubViews() {
    [searchImageView]
      .forEach { self.addSubview($0) }
  }
  
  private func setupSNP() {
    searchImageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
      //       $0.top.leading.trailing.bottom.equalTo(contentView)
    }
  }
  
  func configure(imageUrlString: String, movieId: Int) {
//    searchImageView.kf.setImage(with: URL(string: imageUrlString), options: [.processor(CroppingImageProcessor(size: CGSize(width: 150, height: 200))), .scaleFactor(UIScreen.main.scale)])
    
    self.movieId = movieId
    searchImageView.kf.setImage(with: URL(string: imageUrlString), options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 200))), .cacheOriginalImage])
  }
  
  private func setupTapGestureForView() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap))
    tap.numberOfTapsRequired = 1
    searchImageView.addGestureRecognizer(tap)
    searchImageView.isUserInteractionEnabled = true
  }
  
  @objc func imageViewDidTap() {
    let id = movieId!
    delegate?.passMovieId(movieId: id)
    
  }
}
