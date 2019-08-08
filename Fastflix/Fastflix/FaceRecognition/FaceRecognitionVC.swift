//
//  FaceRecognitionVC.swift
//  Fastflix
//
//  Created by Jeon-heaji on 08/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit



class FaceRecognitionVC: UIViewController {
  
  let topView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    return view
  }()
  
  let lineBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "sample1"), for: .normal)
    return button
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Face Recognition"
    label.textColor = .lightGray
    label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    return label
  }()
  
  let fastLogo: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(named: "logofast")
    return image
  }()
  
  let infoLabel: UILabel = {
    let label = UILabel()
    label.text = " 얼굴을 인식해서 영화를 추천해드립니다. \n 사진을 선택해서 영화 추천을 받아보세요  "
    label.textColor = .lightGray
    label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    return label
  }()
  
  let imageSelectLabel: UILabel = {
    let label = UILabel()
    label.text = " 얼굴인식하기 클릭  "
    label.textColor = .lightGray
    label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    return label
  }()
  
  //camera
  lazy var cameraImg: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "camera")
    imageView.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageAddGesture(_:))))
    imageView.isUserInteractionEnabled = true
      return imageView
  }()
  
  let line1: UIView = {
    let line = UIView()
    line.layer.borderColor = UIColor.gray.cgColor
    line.layer.borderWidth = 1
    return line
  }()
  
  let line2: UIView = {
    let line = UIView()
    line.layer.borderColor = UIColor.gray.cgColor
    line.layer.borderWidth = 2
    return line
  }()
  
  let resultBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("분석하기", for: .normal)
    button.setTitleColor(.red, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    button.addTarget(self, action: #selector(resultBtnDidTap(_:)), for: .touchUpInside)
    return button
  }()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }


    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = .black
      addSubViews()
      setupSNP()

      
    }
  
  private func addSubViews() {
    [topView, cameraImg, resultBtn]
      .forEach { view.addSubview($0) }
    [lineBtn, titleLabel, line1, fastLogo, line2, infoLabel, imageSelectLabel, ]
      .forEach { topView.addSubview($0) }
  }
  
  private func setupSNP() {
    topView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(8)
      $0.height.equalTo(UIScreen.main.bounds.height * 0.47)
    }
    fastLogo.snp.makeConstraints {
      $0.top.equalToSuperview().offset(80)
      $0.centerX.equalToSuperview()
    }
    lineBtn.snp.makeConstraints {
      $0.top.equalTo(fastLogo.snp.bottom).offset(40)
      $0.centerX.equalToSuperview()
    }
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(lineBtn.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
    }
    
    line1.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(1)
    }
    
    infoLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(15)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(topView.snp.width).multipliedBy(0.5)
    }
    
    imageSelectLabel.snp.makeConstraints {
      $0.top.equalTo(infoLabel.snp.bottom)
      $0.centerX.equalToSuperview()
    }
    
    cameraImg.snp.makeConstraints {
      $0.top.equalTo(imageSelectLabel.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.height * 0.25)
      $0.width.equalTo(330)
    }
    resultBtn.snp.makeConstraints {
      $0.top.equalTo(cameraImg.snp.bottom).offset(15)
      $0.centerX.equalToSuperview()
    }
    
  }
  
  @objc func imageAddGesture(_ sender: UITapGestureRecognizer) {
    let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Image",
                                                   message: nil, preferredStyle: .actionSheet)
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let cameraButton = UIAlertAction(title: "Take Photo",
                                       style: .default) { [unowned self] (alert) -> Void in
                                        let imagePicker = UIImagePickerController()
                                        imagePicker.delegate = self
                                        imagePicker.sourceType = .camera
                                        self.present(imagePicker, animated: true)
      }
      imagePickerActionSheet.addAction(cameraButton)
    }
    
    let libraryButton = UIAlertAction(title: "Choose Existing",
                                      style: .default) { [unowned self] (alert) -> Void in
                                        let imagePicker = UIImagePickerController()
                                        imagePicker.delegate = self
                                        imagePicker.sourceType = .photoLibrary
                                        self.present(imagePicker, animated: true)
    }
    imagePickerActionSheet.addAction(libraryButton)
    let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
    imagePickerActionSheet.addAction(cancelButton)
    present(imagePickerActionSheet, animated: true)
    
  }
  @objc func resultBtnDidTap(_ sender: UIButton) {
    let faceResultVC = FaceResultVC()
    present(faceResultVC, animated: true)
  }

}

extension FaceRecognitionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let image = info[.originalImage] as? UIImage
    self.cameraImg.image = image
    picker.dismiss(animated: true)
  }
}
