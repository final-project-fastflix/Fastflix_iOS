//
//  DetailViewUpperCell.swift
//  Fastflix
//
//  Created by HongWeonpyo on 17/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Kingfisher

protocol PlayButtonDelegate: class {
  func playButtonDidTap(movieId: Int)
  func didTapDismissBtn()
  func saveButtonDidTap()
  func shareButtonDidTap()
}

final class DetailViewUpperCell: UITableViewCell {
  
  var movieId: Int?
  
  // 보고있는 영화여부(보고 있는 경우, 현재 보고있는 위치 표시하기 위함)
  var isWatching: Bool = false
  
  // 찜되어있는 영화인지 여부
  var isPoked: Bool = false {
    didSet {
      pokeButtonSetting()
    }
  }
  
  var isPossibleSave: Bool = false {
    didSet {
      savingButtonSetting()
    }
  }
  
  //이미지뷰 가로 크기(고정)
  private let imageWidth: CGFloat = 133
  
  private lazy var dissmissButton: UIButton = {
    let button = UIButton(type: .custom)
//    button.backgroundColor = .black
//    button.tintColor = .white
    button.setImage(UIImage(named: "close1"), for: .normal)
//    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
//    button.layer.cornerRadius = 8
    button.addTarget(self, action: #selector(didTapDismissBtn(_:)), for: .touchUpInside)
    button.clipsToBounds = true
    return button
  }()
  
  // 백그라운드에 깔리는 이미지뷰
  private let backgroundBlurView: UIImageView = {
    let view = UIImageView()
    return view
  }()
  
  // 단순히 블러뷰 효과를 위해서 블러효과들어간 뷰 입힘
  private let backgroundLayerView: UIImageView = {
    let view = UIImageView()
    view.alpha = 1
    view.image = UIImage(named: "blurview")
    return view
  }()
  
  // 디테일뷰 영화 메인이미지
  private let mainImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.shadowColor = UIColor.black.cgColor
    imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
    imageView.layer.shadowOpacity = 0.5
    imageView.layer.shadowRadius = 5
    imageView.clipsToBounds = false
    return imageView
  }()
  
  // 일치율 레이블
  private let suggestionLabel: UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
    label.font = UIFont.boldSystemFont(ofSize: 14)
    return label
  }()
  
  // 출시년도 관람등급, 상영시간
  private lazy var movieExplainLabel: UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    return label
  }()
  
  // 영화이미지 바로 밑에 일치율 및 년도 등을 담는 스택뷰
  private lazy var imageBelowStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [suggestionLabel, movieExplainLabel])
    stackView.alignment = .fill
    stackView.spacing = 25
    stackView.axis = .horizontal
    return stackView
  }()
  
  // 플레이버튼: 델리게이트로 뷰컨트롤러에 전달
  private lazy var playButton: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = .red
    button.setTitle("▶︎  재생", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 2
    button.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
    return button
  }()
  
  // 플레이버튼 스택뷰
  private lazy var playButtonStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [playButton, movieTimeStackView])
    stackView.alignment = .fill
    stackView.spacing = 0
    stackView.axis = .vertical
    return stackView
  }()
  
  // 보던 영화일 경우, 남은시간 표시
  private let slider: UISlider = {
    let slider = UISlider()
    slider.thumbTintColor = .clear
    slider.tintColor = .red
    return slider
  }()
  
  // 남은 시간
  private let leftTimeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 10, weight: .light)
    label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    return label
  }()
  
  // 스택뷰 (영화시간 슬라이더, 남은시간 레이블)
  private lazy var movieTimeStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [slider, leftTimeLabel])
    stackView.alignment = .fill
    stackView.spacing = 10
    stackView.axis = .horizontal
    return stackView
  }()
  
  // 영화 정보 설명
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    return label
  }()
  
  // 출연 및 감독 레이블
  private let directorAndCastLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.font = UIFont.systemFont(ofSize: 12, weight: .light)
    label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    return label
  }()
  
  // movieTimeStackView, 영화설명 및 출연/감독 레이블 스택뷰
  private lazy var movieDescriptionStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [descriptionLabel, directorAndCastLabel])
    stackView.alignment = .fill
    stackView.spacing = 10
    stackView.axis = .vertical
    return stackView
  }()
  
  // 내가 찜한 콘텐츠 버튼
  private lazy var myPokedContentsButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "add"), for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(pokeBtnDidTap(_:)), for: .touchUpInside)
    return button
  }()
  
  // 내가 찜한 콘텐츠 버튼의 레이블
  private lazy var myPokedContentsButtonLabel: UIButton = {
    let button = UIButton()
    button.setTitle("내가 찜한 콘텐츠", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .light)
    button.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
    button.addTarget(self, action: #selector(pokeBtnDidTap(_:)), for: .touchUpInside)
    return button
  }()
  
  // 내가 찜한 콘텐츠 버튼/레이블 스택뷰
  private lazy var myPokedStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [myPokedContentsButton, myPokedContentsButtonLabel])
    stackView.alignment = .center
    stackView.spacing = 7
    stackView.axis = .vertical
    return stackView
  }()
  
  // 평가 버튼
  private lazy var evaluationButton: UIButton = {
    let button = UIButton(type: .system)
    let image = UIImage(named: "like")
    button.setImage(image, for: .normal)
    button.tintColor = .white
    //button.addTarget(self, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
    return button
  }()
  
  // 평가 버튼의 레이블
  private lazy var evaluationButtonLabel: UIButton = {
    let button = UIButton()
    button.setTitle("평가", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .light)
    button.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
    // button.addTarget(self, action: #selector(play), for: .touchUpInside)
    return button
  }()
  
  // 평가 버튼/레이블 스택뷰
  private lazy var evaluationStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [evaluationButton, evaluationButtonLabel])
    stackView.alignment = .center
    stackView.spacing = 7
    stackView.axis = .vertical
    return stackView
  }()
  
  // 공유버튼
  private lazy var shareButton: UIButton = {
    let button = UIButton(type: .system)
    let image = UIImage(named: "share")
    button.setImage(image, for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(shareBtnDidTap(_:)), for: .touchUpInside)
    return button
  }()
  
  // 공유버튼 레이블
  private lazy var shareButtonLabel: UIButton = {
    let button = UIButton()
    button.setTitle("공유", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .light)
    button.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
    button.addTarget(self, action: #selector(shareBtnDidTap(_:)), for: .touchUpInside)
    return button
  }()
  
  // 공유 버튼/레이블 스택뷰
  private lazy var shareStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [shareButton, shareButtonLabel])
    stackView.alignment = .center
    stackView.spacing = 7
    stackView.axis = .vertical
    return stackView
  }()
  
  // 저장가능 버튼
  private lazy var savingPossibleButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "tabBarDownLoad1"), for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(saveButtonDidTap(_:)), for: .touchUpInside)
    return button
  }()
  
  // 저장가능 버튼의 레이블
  private lazy var savingPossibleButtonLabel: UIButton = {
    let button = UIButton()
    button.setTitle("저장", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .light)
    button.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
    button.addTarget(self, action: #selector(saveButtonDidTap(_:)), for: .touchUpInside)
    return button
  }()
  
  // 저장가능 버튼/레이블 스택뷰
  private lazy var savingPossibleStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [savingPossibleButton, savingPossibleButtonLabel])
    stackView.alignment = .center
    stackView.spacing = 7
    stackView.axis = .vertical
    return stackView
  }()
  
  // 위의 4가지 스택뷰를 담는 스택뷰
  private lazy var allButtonStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [myPokedStackView, evaluationStackView, shareStackView, savingPossibleStackView])
    stackView.alignment = .center
    stackView.spacing = 0
    stackView.axis = .horizontal
    return stackView
  }()
  
  
  // 델리게이트(뷰컨트롤러에 전달)
  weak var delegate: PlayButtonDelegate?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configure()
    setupSNP()
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    dissmissButton.layer.cornerRadius = dissmissButton.frame.width / 2
    timeStackViewSetting()
    pokeButtonSetting()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // 디스미스(닫기) 버튼 - 델리게이트로 전달됨
  @objc private func didTapDismissBtn(_ sender: UIButton) {
//    print("dismiss")
    delegate?.didTapDismissBtn()
  }
  
  // 뷰 설정
  private func configure() {
    self.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
    self.selectionStyle = .none
    
    backgroundBlurView.addBlurEffect()
  }
  
  // 스냅킷 오토레이아웃
  private func setupSNP() {
    [backgroundBlurView, backgroundLayerView, mainImageView, imageBelowStackView, playButtonStackView, movieDescriptionStackView, allButtonStackView].forEach { contentView.addSubview($0) }
    
    contentView.superview?.addSubview(dissmissButton)
    
    let buttonWidth = (UIScreen.main.bounds.width - 20)/4
    
    dissmissButton.snp.makeConstraints {
      $0.width.height.equalTo(28)
      $0.top.equalToSuperview().offset(44)
      $0.trailing.equalToSuperview().offset(-15)
    }
    
    backgroundBlurView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(contentView.snp.top)
      $0.bottom.equalTo(contentView.snp.bottom)
      $0.leading.equalTo(contentView.snp.leading).offset(-100)
      $0.trailing.equalTo(contentView.snp.trailing).offset(100)
    }
    
    backgroundLayerView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalTo(backgroundBlurView)
    }
    
    mainImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(contentView.snp.top).offset(80)
      $0.width.equalTo(imageWidth)
      $0.height.equalTo(mainImageView.snp.width).multipliedBy(1.4436)
    }
    
    imageBelowStackView.snp.makeConstraints {
      $0.top.equalTo(mainImageView.snp.bottom).offset(15)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(15)
    }
    
    playButton.snp.makeConstraints {
      $0.height.equalTo(35)
    }
    
    playButtonStackView.snp.makeConstraints {
      $0.top.equalTo(imageBelowStackView.snp.bottom).offset(30)
      $0.leading.equalTo(contentView.snp.leading).offset(8)
      $0.trailing.equalTo(contentView.snp.trailing).offset(-8)
    }
    
    movieDescriptionStackView.snp.makeConstraints {
      $0.top.equalTo(playButtonStackView.snp.bottom).offset(4)
      $0.leading.equalTo(contentView.snp.leading).offset(8)
      $0.trailing.equalTo(contentView.snp.trailing).offset(-8)
    }
    
    myPokedContentsButton.snp.makeConstraints {
      $0.width.height.equalTo(20)
    }
    
    evaluationButton.snp.makeConstraints {
      $0.width.height.equalTo(20)
    }
    
    shareButton.snp.makeConstraints {
      $0.width.equalTo(16)
      $0.height.equalTo(20)
    }
    
    savingPossibleButton.snp.makeConstraints {
      $0.width.equalTo(16)
      $0.height.equalTo(20)
    }
    
    // 스택뷰 모음
    myPokedStackView.snp.makeConstraints {
      $0.width.equalTo(buttonWidth)
      $0.height.equalTo(40)
    }
    
    evaluationStackView.snp.makeConstraints {
      $0.width.equalTo(buttonWidth)
      $0.height.equalTo(40)
    }
    
    shareStackView.snp.makeConstraints {
      $0.width.equalTo(buttonWidth)
      $0.height.equalTo(40)
    }
    
    savingPossibleStackView.snp.makeConstraints {
      $0.width.equalTo(buttonWidth)
      $0.height.equalTo(40)
    }
    
    allButtonStackView.snp.makeConstraints {
      $0.top.equalTo(movieDescriptionStackView.snp.bottom).offset(12)
      $0.leading.equalTo(contentView.snp.leading).offset(10)
//      $0.trailing.equalTo(contentView.snp.trailing).offset(-10)
      $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
    }
  
  }
  
  // 보고있는 영화여부에 따라 타임레이블 표시할지 결정하는 메서드
  private func timeStackViewSetting() {
    if isWatching {
      movieTimeStackView.isHidden = false
    }else {
      movieTimeStackView.isHidden = true
    }
  }
  
  // 찜되어있는 영화여부에 따라 체크 표시할지 결정하는 메서드
  private func pokeButtonSetting() {
    if isPoked {
      myPokedContentsButton.setImage(UIImage(named: "poke"), for: .normal)
    }else {
      myPokedContentsButton.setImage(UIImage(named: "add"), for: .normal)
    }
  }
  
  private func savingButtonSetting() {
    if isPossibleSave {
      savingPossibleStackView.isHidden = false
    }else {
      savingPossibleStackView.isHidden = true
    }
  }
  
  // 플레이버튼 눌렀을 때의 동작 - 델리게이트로 전달
  @objc private func play(_ sender: UIButton) {
    delegate?.playButtonDidTap(movieId: movieId!)
  }
  
  @objc private func pokeBtnDidTap(_ sender: UIButton) {
//    print("포크버튼 눌렀습니다용")
    
    APICenter.shared.toggleForkMovie(movieID: movieId!) {
      switch $0 {
      case .success(let success):
//        print("디테일뷰에서 영화찜하기 성공: ", success)
        DispatchQueue.main.async {
          if success == 1 {
            self.isPoked = true
          }else {
            self.isPoked = false
          }
        }
      case .failure(let err):
        print("reason: ", err)
      }
    }
  }
  
  @objc private func shareBtnDidTap(_ sender: UIButton) {
    delegate?.shareButtonDidTap()
  }
  
  
  @objc private func saveButtonDidTap(_ sender: UIButton) {
    delegate?.saveButtonDidTap()
  }
  
  // 디테일뷰 이미지 설정(메인이미지, 백그라운드)관련 메서드
  func configureImage(imageURLString: String?) {
    let imageURL = URL(string: imageURLString ?? "ImagesData.shared.imagesUrl[5]")
    self.mainImageView.kf.setImage(with: imageURL, options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))), .scaleFactor(UIScreen.main.scale)])
    self.backgroundBlurView.kf.setImage(with: imageURL, options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))), .scaleFactor(UIScreen.main.scale)])
  }
  
  // 영화아이디 저장하는 메서드
  func movieId(_ number: Int?) {
    self.movieId = number
  }
  
  // 디테일뷰 이미지외의 내용 설정관련 메서드
  func detailDataSetting(matchRate: Int?, productionDate: String?, degree: String?, runningTime: String?, sliderTime: Float?, remainingTime: String?, synopsis: String?, actors: String?, directors: String?, toBeContinue: Int?, isPoked: Bool, isPossibleSave: Bool) {
    
    // 옵셔널 처리
    let matchRate1 = matchRate ?? 90
    let productionDate1 = productionDate ?? ""
    let degree1 = degree ?? ""
    let runningTime1 = runningTime ?? ""
    let sliderTime1 = sliderTime ?? 0.5
    let remainingTime1 = remainingTime ?? ""
    let synopsis1 = synopsis ?? ""
    let actors1 = actors ?? ""
    let directors1 = directors ?? ""
    
    // 레이블들에 표시
    self.suggestionLabel.text = "\(matchRate1)%일치"
    self.movieExplainLabel.text = "\(productionDate1)   \(degree1)   \(runningTime1)"
    self.slider.setValue(sliderTime1, animated: false)
    self.leftTimeLabel.text = "남은시간: \(remainingTime1)"
    self.descriptionLabel.text = "\(synopsis1)"
    self.directorAndCastLabel.text = """
    출연: \(actors1)
    감독: \(directors1)
    """
    self.isPoked = isPoked
    
    // 지금까지 시청한 시간이 "0"인 경우 타임레이블 없애기
    if toBeContinue == 0 {
      self.isWatching = false
      timeStackViewSetting()
    }else {
      self.isWatching = true
      timeStackViewSetting()
    }
    
    if isPossibleSave {
      self.isPossibleSave = true
      savingButtonSetting()
    }else {
      self.isPossibleSave = false
      savingButtonSetting()
    }
  }
  
}

