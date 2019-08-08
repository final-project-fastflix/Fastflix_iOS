//
//  OriginalCollectionCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 15/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

final class OriginalCollectionCell: UICollectionViewCell {
  
  static let identifier = "OriginalCollectionCell"
  
  var movieID: Int?
  
  private let originalImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.addSubview(originalImageView)
    setupSNP()
    
  }
  
  func configure(url: URL?, movieID: Int) {
    
//    Alamofire.request(url!, method: .get)
//      .responseData(queue: .main) { (result) in
//        switch result.result {
//        case .success(let value):
//          let img = UIImage(data: value)
//          self.originalImageView.image = img
//          print("ddddd", result.description, result.debugDescription)
//        case .failure(let err):
//          print("img", err.localizedDescription)
//        }
//    }
    
//    guard let data = try? Data(contentsOf: url!) else { return print("Error about img")}
//    print(data)
//    let jpg = UIImage(data: data)?.jpegData(compressionQuality: 0.8)
//    originalImageView.image = UIImage(data: jpg)
    
    originalImageView.kf.setImage(with: url, options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 170, height: 370)))]) {
      switch $0 {
      case .success(let value):
        print("img success")
      case .failure(let err):
        print("img Err", err.localizedDescription)
      }
    }
    
//    print("img", originalImageView.image)
    self.movieID = movieID
//    print("오리지널 유알엘", url, movieID, "오리지널 끝")
  }
  
  private func setupSNP() {
    originalImageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()

    }
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
