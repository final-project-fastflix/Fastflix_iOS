//
//  EmptyDownloadView.swift
//  Fastflix
//
//  Created by Jeon-heaji on 30/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//


import UIKit
import SnapKit


class EmptyDownloadView: UIView {
  
  private lazy var saveWifiBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "wifisave2"), for: .normal)
    button.addTarget(self, action: #selector(saveWiftBtnDidTap(_:)), for: .touchUpInside)
    return button
  }()
  
  private lazy var saveSwitch: UISwitch = {
    let saveSwitch = UISwitch()
    saveSwitch.onTintColor = .blue
    saveSwitch.tintColor = UIColor.blue
    saveSwitch.isOn = true
    saveSwitch.addTarget(self, action: #selector(onClickSwitch(_:)), for: .valueChanged)
    saveSwitch.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    return saveSwitch
  }()
  
  private lazy var editBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "profileEdit"), for: .normal)
    button.tintColor = .lightGray
    button.addTarget(self, action: #selector(editBtnDidTap(_:)), for: .touchUpInside)
    return button
  }()
  
  private let downloadImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "bigDownload")
    return imageView
  }()
  
  private let downloadText: UILabel = {
    let label = UILabel()
    label.text = " 저장된 영화와 TV프로그램은 모두 여기에 \n 표시됩니다."
    label.textColor = #colorLiteral(red: 0.9531051713, green: 0.9531051713, blue: 0.9531051713, alpha: 1)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    return label
  }()
  
  private let storedContentBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("저장 가능한 콘텐츠 찾아보기", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.9531051713, green: 0.9531051713, blue: 0.9531051713, alpha: 1), for: .normal)
    button.layer.borderWidth = 0.3
    button.layer.borderColor = UIColor.lightGray.cgColor
    return button
  }()
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.backgroundColor  = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    addSubViews()
    setupSNP()
  }
  
  
  private func addSubViews() {
    [saveWifiBtn, saveSwitch, editBtn, downloadImageView, downloadText, storedContentBtn]
      .forEach { self.addSubview($0) }
  }
  
  private func setupSNP() {
    
    saveWifiBtn.snp.makeConstraints {
      $0.top.equalTo(UIScreen.main.bounds.height * 0.051)
      $0.leading.equalToSuperview().inset(30)
    }
    saveSwitch.snp.makeConstraints {
      $0.top.equalTo(UIScreen.main.bounds.height * 0.045)
      $0.leading.equalTo(saveWifiBtn.snp.trailing)
    }
    editBtn.snp.makeConstraints {
      $0.top.equalTo(UIScreen.main.bounds.height * 0.05)
      $0.trailing.equalToSuperview().inset(30)
    }
    
    downloadImageView.snp.makeConstraints {
      $0.top.equalTo(saveWifiBtn.snp.bottom).offset(130)
      $0.width.height.equalTo(150)
      $0.centerX.equalToSuperview()
    }
    
    downloadText.snp.makeConstraints {
      $0.top.equalTo(downloadImageView.snp.bottom).offset(40)
      $0.centerX.equalToSuperview()
    }
    storedContentBtn.snp.makeConstraints {
      $0.top.equalTo(downloadText.snp.bottom).offset(35)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(200)
      $0.height.equalTo(50)
    }
    
  }
  
  
  @objc func saveWiftBtnDidTap(_ sender: UIButton) {
    print("saveWiftBtnDidTap")
  }
  
  @objc func onClickSwitch(_ sender: UISwitch) {
    
  }
  
  @objc func editBtnDidTap(_ sender: UIButton) {
    print("editBtnDidTap")
  }
  
}
