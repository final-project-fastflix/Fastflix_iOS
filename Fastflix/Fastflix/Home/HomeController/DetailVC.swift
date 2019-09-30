//
//  DetailVC.swift
//  Fastflix
//
//  Created by HongWeonpyo on 17/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//



import UIKit

final class DetailVC: UIViewController {
  
  var movieId: Int?
  var movieDetailData: MovieDetail?
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    return tableView
  }()
  
  private let movieTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.boldSystemFont(ofSize: 18)
    return label
  }()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addSubviews()
    setupSNP()
    registerTableViewCell()
    setTableView()
    setupDetailInfo()
  }
  
  private func setupDetailInfo() {
    movieTitleLabel.text = movieDetailData?.name
  }
  
  override func viewDidLayoutSubviews() {
    tableView.contentInset.top = -view.safeAreaInsets.top
  }
  
  private func registerTableViewCell() {
    tableView.register(DetailViewUpperCell.self, forCellReuseIdentifier: "DetailViewUpperCell")
    tableView.register(DetailViewBelowCell.self, forCellReuseIdentifier: "DetailViewBelowCell")
  }
  
  private func setTableView() {
    tableView.separatorStyle = .none
    tableView.allowsSelection = false
    tableView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
    tableView.showsVerticalScrollIndicator = false
    tableView.dataSource = self
//    tableView.delegate = self
  }
  
  private func addSubviews() {
    view.addSubview(tableView)
  }
  private func setupSNP() {
    tableView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
}

extension DetailVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0 :
      let cell = tableView.dequeueReusableCell(withIdentifier: "DetailViewUpperCell", for: indexPath) as! DetailViewUpperCell
      cell.delegate = self
      
      // 무비아이디전달
      cell.movieId(movieId)
      cell.configureImage(imageURLString: movieDetailData?.verticalImage)
      
      // 나머지 영화정보들 전달하는 데이터 생성 및 전달
      // 슬라이더에 넣기 위한 비율 계산 (멈춘시간/전체시간) 예) 0.44344
      let sliderFloat = Float(movieDetailData!.pausedMinute) / Float(movieDetailData!.totalMinute)
      
      // 남은시간(분)
      let remainingMinute = movieDetailData!.totalMinute - movieDetailData!.pausedMinute
      
      // 남은시간(분)을 시간 기준으로 환산
      let remainingTimeHour = remainingMinute / 60
      let remainingTimeMinute = remainingMinute % 60
      
      // 남은시간 String값으로 만들어서 넘기기
      let remainingTime = "\(remainingTimeHour) 시간 \(remainingTimeMinute)분"
      
      // 배우이름 여러개일때 대비해서 붙이기
      var actorNum = movieDetailData!.actors.count - 1
      
      if actorNum >= 4 {
        actorNum = 4
      }
      
      var actors: String = ""
      
      for i in 0...actorNum {
        let actor = movieDetailData!.actors[i].name
        if i == 0 {
          actors += actor
        }else {
          actors += ", \(actor)"
         }
      }
      
      // 감독이름
      let direc = movieDetailData?.directors[0].name ?? ""
      
      // 등급기준 (긴글자 ======> 짧은 글자로 바꿔서 넘기기)
      let rate = ageSorting(rate: movieDetailData?.degree.name ?? "")
      
      let director = "\(direc)"
      
      // 무비아이디, 이미지 이외의 데이터를 표시하고 있는 디테일뷰의 테이블뷰에 전달
      cell.detailDataSetting(matchRate: movieDetailData?.matchRate, productionDate: movieDetailData?.productionDate, degree: rate, runningTime: movieDetailData?.runningTime, sliderTime: sliderFloat, remainingTime: remainingTime, synopsis: movieDetailData?.synopsis, actors: actors, directors: director, toBeContinue: movieDetailData?.toBeContinue, isPoked: movieDetailData!.marked, isPossibleSave: movieDetailData!.canIStore)
      
      return cell
      
    case 1 :
      let cell = tableView.dequeueReusableCell(withIdentifier: "DetailViewBelowCell", for: indexPath) as! DetailViewBelowCell
      cell.delegate = self
      
      // 셀에 무비아이디 및 비슷한 콘텐츠의 내용(영화들) 전달
      cell.movieId = self.movieId
      cell.similarMoviesData = movieDetailData!.similarMovies
      
      return cell
      
    default:
      return UITableViewCell()
    }
  }
  
  // 테이블뷰 데이터소스
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func ageSorting(rate: String) -> String {
    switch rate {
    case "모든 연령에 해당하는 자가 관람할 수 있는 영화":
      return "전체관람가"
    case "만 12세 이상의 자가 관람할 수 있는 영화":
      return "12"
    case "만 15세 이상의 자가 관람할 수 있는 영화":
      return "15"
    case "청소년은 관람할 수 없는 영화":
      return "청불"
    default:
      return ""
    }
  }
}

// (델리게이트) 플레이버튼 눌렀을때 플레이어 띄우기
extension DetailVC: PlayButtonDelegate {
  func shareButtonDidTap() {
    let message = """
    본 콘텐츠를 지인에게 공유할 수 있습니다.
    """
    self.oneAlert(title: "공유하시겠습니까?", message: message, okButton: "공유하러 가기")
  }
  
  func saveButtonDidTap() {
    let message = """
    Wi-Fi에 연결되어야만 콘텐츠를 저장하실 수
    있습니다.
    """
    self.oneAlert(title: "저장하시겠습니까?", message: message, okButton: "콘텐츠 저장하기")
  }
  
  func didTapDismissBtn() {
    dismiss(animated: true)
  }
  
  func playButtonDidTap(movieId: Int) {
//    print("여기에 플레이어 붙이면 됩니다.")
//    print("run playVideo")
    let player = PlayerVC()
    
    let url = movieDetailData?.videoFile
    let title = movieDetailData?.name
    let id = movieDetailData?.id
    let time = movieDetailData?.pausedMinute
    
    player.configure(id: id, title: title, videoPath: url, seekTime: time)
    AppDelegate.instance.shouldSupportAllOrientation = false
    self.present(player, animated: true)

  }
}

// (델리게이트) 디테일뷰 다시 띄우기
extension DetailVC: SimilarMoviesDetailViewCellDelegate {
  
  func similarMovieDetailViewDidSelectItemAt(movieId: Int) {
    
    APICenter.shared.getDetailData(id: movieId) {
      switch $0 {
      case .success(let movie):
//        print("디테일뷰 다시띄우기 위해 영화정보 다시 띄우기: ", movie.id, movie.name)
        DispatchQueue.main.async {
          let detailVC = DetailVC()
          detailVC.movieId = movieId
          detailVC.movieDetailData = movie
          self.present(detailVC, animated: true)
        }
      case .failure(let err):
//        print("fail to login, reason: ", err)
        dump(err)
        let message = """
        죄송합니다. 해당 영화에 대한 정보를 가져오지
        못했습니다. 다시 시도해 주세요.
        """
        DispatchQueue.main.async {
          self.oneAlert(title: "영화데이터 오류", message: message, okButton: "재시도")
        }
      }
    }
  }
}



