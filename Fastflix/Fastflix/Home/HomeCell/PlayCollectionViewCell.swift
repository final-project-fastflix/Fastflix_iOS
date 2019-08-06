//
//  PlayCollectionViewCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 06/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class PlayCollectionViewCell: UICollectionViewCell {

    
    static let identifier = "PlayCollectionViewCell"
    
    var playView: UIImageView = {
      let view = UIImageView()
      //    view.backgroundColor = .red
      return view
    }()
    
    override func didMoveToSuperview() {
      super.didMoveToSuperview()
      addSubViews()
      setupSNP()
    }
    
    private func addSubViews() {
      [playView].forEach { self.addSubview($0) }
    }
    
    private func setupSNP() {
      playView.snp.makeConstraints {
        $0.top.leading.trailing.bottom.equalToSuperview()
      }
    }
  

}
