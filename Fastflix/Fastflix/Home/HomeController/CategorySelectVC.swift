//
//  CategorySelectVC.swift
//  Fastflix
//
//  Created by HongWeonpyo on 06/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

protocol CategorySelectVCDelegate {
  func sendData(data: [RequestMovieElement], keys: [String])
}

class CategorySelectVC: UIViewController {
  
  var delegate: CategorySelectVCDelegate?
  
  var categoryArray = [
    "전체 영화", "한국 영화", "미국 영화", "어린이", "액션", "스릴러", "SF", "판타지", "범죄", "호러",
    "다큐", "로맨스", "코미디", "애니 영화", "외국 영화"
  ]
  
  // 영화홈으로 가기위한 데이터
  var mainMovie: MainMovie?
  var genre: [String]?
  var listByGenre: [String: [MoviesByGenre]]?
  
  private let backgroundView: UIImageView = {
    let view = UIImageView()
    view.addBlurEffect()
    return view
  }()
  
  private let genreSelectTableView: UITableView = {
    let tableview = UITableView()
    tableview.backgroundColor = .clear
    return tableview
  }()
  
  private lazy var closeButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "closeAtCategory"), for: .normal)
    button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configure()
    addSubviews()
    setupSNP()
    setupTableView()
  }
  
  private func configure() {
    
    backgroundView.backgroundColor = .black
    backgroundView.alpha = 0.5
    
    // 프리젠트 띄우고나서 뒤에 백그라운드 블러로 보이는 효과주기 위함 ==> 일단 전에 뷰컨트롤러에서 띄울때 modal옵션 줘야함
    view.backgroundColor = UIColor(white: 0, alpha: 0.85)
    view.isOpaque = false
  }
  
  
  private func addSubviews() {
    
    [backgroundView, genreSelectTableView, closeButton].forEach { view.addSubview($0) }
    
  }
  
  private func setupSNP() {
    
    backgroundView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalTo(view)
    }
    
    genreSelectTableView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalTo(view)
    }
    
    closeButton.snp.makeConstraints {
      $0.width.height.equalTo(55)
      $0.centerX.equalTo(view.snp.centerX)
      $0.bottom.equalTo(view.snp.bottom).inset(40)
    }
    
  }
  
  private func setupTableView() {
    genreSelectTableView.dataSource = self
    genreSelectTableView.delegate = self
    genreSelectTableView.register(CategorySelectCell.self, forCellReuseIdentifier: "CategorySelectCell")
    
    genreSelectTableView.allowsSelection = true
    genreSelectTableView.allowsMultipleSelection = false
    genreSelectTableView.separatorColor = .clear
    genreSelectTableView.contentInset = UIEdgeInsets(top: 100,left: 0,bottom: 250, right: 0)
  
    let indexPath = IndexPath(row: 0, section: 0)
    genreSelectTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    genreSelectTableView.contentInsetAdjustmentBehavior = .automatic
    
  }
  
  @objc private func closeButtonDidTap() {
    
    UIView.animate(withDuration: 0.5) {
      self.dismiss(animated: false)
    }
  }
}


extension CategorySelectVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = genreSelectTableView.dequeueReusableCell(withIdentifier: "CategorySelectCell", for: indexPath) as! CategorySelectCell
    cell.genreLabel.text = categoryArray[indexPath.row]
    
    return cell
  }
}

extension CategorySelectVC: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    // 전체영화(indexPath:0)의 경우 눌리면 안됨 ===> 전체영화 눌리면 나감
    if indexPath.row == 0 {
      return
      // 전체영화가 아닌 경우엔 계속 진행
    }else {
      print("버튼 눌렸다....")
      APICenter.shared.getMovieData {
        switch $0 {
        case .success(let value):
          print("메인무비 받기 성공")
          self.mainMovie = value[0].mainMovie
          self.secondStepForGenreSelected(indexPathRow: indexPath.row)
        case .failure(let err):
          dump(err)
        }
      }
    }
  }
  
  private func secondStepForGenreSelected(indexPathRow: Int) {
    // 인덱스패스로 장르확인
    let genreName = categoryArray[indexPathRow]
    // 실제 데이터요청에 필요한 장르로 바꾸기
    let name = checkGenre(genre: genreName)
    
    APICenter.shared.getListByGenreData(genre: name) {
      switch $0 {
      case .success(let value):
        print("장르별 영화받기도 성공")
        self.genre = Array(value.keys)
        self.listByGenre = value
//        print(self.listByGenre ?? "장르가 안나와요")
        self.thirdStepForGenreSelected()
      case .failure(let err):
        dump(err)
      }
    }
  }
  
  private func thirdStepForGenreSelected() {
    //받은 데이터로 영화테이블에 뿌려줄 구조체 하나 만들기
    let movieforMovieHome = RequestMovieElement(mainMovie: mainMovie!, listOfGenre: genre!, moviesByGenre: listByGenre!)
    
    print("구조체 만들기 성공")
    
    let data = [movieforMovieHome]
    let keys = movieforMovieHome.listOfGenre
    print("안의 내용은 다 바꿨는데.. 뷰를 바꾸고 싶어여.....")
    DispatchQueue.main.async {
      print("checkData: ", data)
      self.delegate?.sendData(data: data, keys: keys)
    }
    
    //      self.tabBarController?.viewControllers?[0] = mainMovieVC
//    DispatchQueue.main.async {
//      self.dismiss(animated: true)
//    }
    
    
  }
  
  private func checkGenre(genre: String) -> String {
    switch genre {
    case "한국 영화":
      return "한국"
    case "미국 영화":
      return "미국"
    case "어린이":
      return "어린이"
    case "액션":
      return "액션"
    case "스릴러":
      return "스릴러"
    case "SF":
      return "sf"
    case "판타지":
      return "판타지"
    case "범죄":
      return "범죄"
    case "호러":
      return "호러"
    case "다큐":
      return "다큐"
    case "로맨스":
      return "로맨스"
    case "코미디":
      return "코미디"
    case "애니 영화":
      return "애니"
    case "외국 영화":
      return "외국"
    default:
      return "한국"
    }
  }
}
