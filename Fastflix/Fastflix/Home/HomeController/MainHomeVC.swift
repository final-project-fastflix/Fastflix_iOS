//
//  MainHomeVC.swift
//  Fastflix
//
//  Created by Jeon-heaji on 21/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import AVKit

class MainHomeVC: UIViewController {
  
  let subUserSingle = SubUserSingleton.shared
  var preViewPlayerVC: PreViewPlayerVC? = nil
  
  // download 가 끝났을 시, 결과값이 true라면 reload
  var finishDownload = false {
    willSet(new) {
      DispatchQueue.main.async {
        new ? self.tableView.reloadData() : ()
      }
      self.finishDownload = false
    }
  }
  
  // floatingView를 움직이기위한 properties
  var originValue: CGFloat = 0
  var compareArr: [CGFloat] = []
  var originY: CGFloat {
    get {
      return floatingView.frame.origin.y
    }
    set {
      guard newValue >= -floatingView.frame.height || newValue <= 0 else { return }
      floatingView.frame.origin.y = newValue
    }
  }
  
  var mainMovieId: Int?
  
  // streamingCell이 보여질때 플레이 아니면 일시정지
  private var streamingCellFocus = false {
    willSet(newValue) {
      newValue ? streamingCell.playVideo() : streamingCell.pauseVideo()
    }
  }
  
  let path = DataCenter.shared
  
  private lazy var tableView: UITableView = {
    let tbl = UITableView()
    tbl.dataSource = self
    tbl.delegate = self
    tbl.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    tbl.separatorStyle = .none
    tbl.allowsSelection = false
    tbl.showsVerticalScrollIndicator = false
    return tbl
  }()
  
  // video가 있을때 configure 실행 아니면 재생안함
  private lazy var streamingCell: StreamingCell = {
    let cell = StreamingCell()
    guard let video = DataCenter.shared.goldenMovie?.videoFile else {
      return cell }
    cell.configure(url: video)
    return cell
  }()
  
  private lazy var floatingView: FloatingView = {
    let view = FloatingView()
    view.delegate = self
    return view
  }()
  
  var userName: String?
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addSubViews()
    registerTableViewCell()
    preViewPlayerVC?.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    userSetting()
    floatingView.movieBtn.setTitle("영화", for: .normal)
    
//    reGetPokedList()
  }
  
//  func reGetPokedList() {
//    APICenter.shared.getListOfFork {
//      switch $0 {
//      case .success(let list):
//        var imgPaths = [String]()
//        var movieIDArr = [Int]()
//
//        for i in 0...list.count - 1 {
//          imgPaths.append(list[i].verticalImage)
//          movieIDArr.append(list[i].id)
//        }
//
//        DispatchQueue.main.async {
//          let cell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? SubCell
//          cell?.configure(url: imgPaths, title: "찜 리스트", movieIDs: movieIDArr)
//
//          cell?.collectionView.reloadData()
//        }
//
//      case .failure(let err):
//        print("fail to parsing, reason: ", err)
//        let message = """
//          죄송합니다. 찜 정보를 가져오는데
//          실패했습니다.
//          다시 시도하세요.
//          """
//        self.oneAlert(title: "실패", message: message, okButton: "찜 목록 다시 확인하기")
//      }
//    }
//  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupSNP()
  }
  
  private func userSetting() {
    let user = subUserSingle.subUserList?.filter { $0.id == APICenter.shared.getSubUserID() }
    self.userName = user?[0].name
  }
  
  
  private func addSubViews() {
    [tableView, floatingView].forEach { view.addSubview($0) }
  }
  
  private func setupSNP() {
    tableView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    floatingView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(50 + topPadding)
      $0.top.equalToSuperview().offset(-10)
    }
  }
  
  private func registerTableViewCell() {
    
    tableView.register(MainImageTableCell.self, forCellReuseIdentifier: MainImageTableCell.identifier)
    tableView.register(PreviewTableCell.self, forCellReuseIdentifier: PreviewTableCell.identifier)
    tableView.register(OriginalTableCell.self, forCellReuseIdentifier: OriginalTableCell.identifier)
    tableView.register(SubCell.self, forCellReuseIdentifier: SubCell.identifier)
    tableView.register(WatchingMoviesTableCell.self, forCellReuseIdentifier: WatchingMoviesTableCell.identifier)
    
  }
  
}

extension MainHomeVC: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 14
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: MainImageTableCell.identifier, for: indexPath) as! MainImageTableCell
      let bigImgPath = path.mainImageCellData?.mainMovie?.iosMainImage
      let logoImgPath = path.mainImageCellData?.mainMovie?.logoImagePath
      var text = ""
      let id = path.mainImageCellData?.mainMovie?.id
      
      cell.delegate = self
      cell.movieId = id
      self.mainMovieId = id
      cell.configure(imageURLString: bigImgPath, logoImageURLString: logoImgPath)
      if let data = path.mainImageCellData?.mainMovie?.genre {
        for idx in 0...data.count {
          if idx < 3 {
            text += (data[idx].name + "･")
          }
        }
      }
      let lastText = String(text.dropLast())
      cell.selectionStyle = .none
      cell.movieDetailLabel.text = lastText
      
      return cell
      
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: PreviewTableCell.identifier, for: indexPath) as! PreviewTableCell
      
      var mainURLs: [String] = []
      var logoURLs: [String] = []
      var idArr: [Int] = []
      var videoPathArr: [String] = []
      
      if let data = path.preViewCellData {
        for index in data {
          mainURLs.append(index.circleImage)
          logoURLs.append(index.logoImagePath)
          idArr.append(index.id)
          videoPathArr.append(index.verticalSampleVideoFile ?? "")
        }
      }
      
      cell.configure(idArr: idArr, mainURLs: mainURLs, logoURLs: logoURLs, videos: videoPathArr)
      cell.delegate = self
      cell.selectionStyle = .none
      cell.layoutIfNeeded()
      return cell
      
    case 2:
      let cell = SubCell()
      var mainURLs: [String] = []
      var movieIDArr: [Int] = []
      if let data = path.brandNewMovieData {
        for index in data {
          mainURLs.append(index.verticalImage)
          movieIDArr.append(index.id)
        }
      }
      
      cell.configure(url: mainURLs, title: "최신영화", movieIDs: movieIDArr)
      cell.delegate = self
      return cell
      
    case 3:
      let cell = SubCell()
      var mainURLs: [String] = []
      var movieIDArr: [Int] = []
      if let data = path.forkData {
        for index in data {
          mainURLs.append(index.verticalImage)
          movieIDArr.append(index.id)
        }
      }
      
      cell.configure(url: mainURLs, title: "찜 리스트", movieIDs: movieIDArr)
      cell.delegate = self
      return cell
      
    case 4:
      let cell = SubCell()
      var mainURLs: [String] = []
      var movieIDArr: [Int] = []
      if let data = path.top10Data {
        for index in data {
          mainURLs.append(index.verticalImage)
          movieIDArr.append(index.id)
        }
      }
      
      cell.configure(url: mainURLs, title: "좋아요 TOP 10", movieIDs: movieIDArr)
      cell.delegate = self
      return cell
      
    case 5:
      let cell = streamingCell
      return cell
      
    case 6:
      let cell = tableView.dequeueReusableCell(withIdentifier: OriginalTableCell.identifier, for: indexPath) as! OriginalTableCell
      cell.selectionStyle = .none
      cell.delegate = self
      
      var mainURLs: [String] = []
      var movieIDArr: [Int] = []
      
      if let data = path.fastFlixOriginal {
        print("오리지널 데이터", data)
        for index in data {
          mainURLs.append(index.verticalImage)
          movieIDArr.append(index.id)
        }
      }
      print("오리지널 전달 어레이 데이터", mainURLs, movieIDArr)
      cell.configure(url: mainURLs, movieIDs: movieIDArr)
      
      return cell
      
    case 7:
      let cell = tableView.dequeueReusableCell(withIdentifier: WatchingMoviesTableCell.identifier, for: indexPath) as! WatchingMoviesTableCell
      
      let user = subUserSingle.subUserList?.filter { $0.id == APICenter.shared.getSubUserID() }
      self.userName = user?[0].name
      
      if let data = path.followUpMovie {
        cell.configure(data: data, subUserName: self.userName)
      }
      cell.selectionStyle = .none
      cell.delegate = self
      return cell
      
    case 8:
      let cell = SubCell()
      var mainURLs: [String] = []
      var movieIDArr: [Int] = []
      
      if let data = path.recommendMovie {
        for index in data {
          mainURLs.append(index.verticalImage!)
          movieIDArr.append(index.id)
        }
      }
      
      cell.configure(url: mainURLs, title: "추천영화", movieIDs: movieIDArr)
      cell.delegate = self
      return cell
      
    case 9:
      let cell = SubCell()
      var mainURLs: [String] = []
      var movieIDArr: [Int] = []
      
      if let data = path.goodOstMovie {
        for index in data {
          mainURLs.append(index.verticalImage)
          movieIDArr.append(index.id)
        }
      }
      
      cell.configure(url: mainURLs, title: "ost가 좋은 영화", movieIDs: movieIDArr)
      cell.delegate = self
      return cell
      
    case 10:
      let cell = SubCell()
      var mainURLs: [String] = []
      var movieIDArr: [Int] = []
      
      if let data = path.summerMovie {
        for index in data {
          mainURLs.append(index.verticalImage)
          movieIDArr.append(index.id)
        }
      }
      
      cell.configure(url: mainURLs, title: "여름에 볼만한 영화", movieIDs: movieIDArr)
      cell.delegate = self
      return cell
      
    case 11:
      let cell = SubCell()
      var mainURLs: [String] = []
      var movieIDArr: [Int] = []
      
      if let data = path.funnyMovie {
        for index in data {
          mainURLs.append(index.verticalImage)
          movieIDArr.append(index.id)
        }
      }
      
      cell.configure(url: mainURLs, title: "미치도록 웃긴영화", movieIDs: movieIDArr)
      cell.delegate = self
      return cell
      
    case 12:
      let cell = SubCell()
      var mainURLs: [String] = []
      var movieIDArr: [Int] = []
      
      if let data = path.englishStudyMovie {
        for index in data {
          mainURLs.append(index.verticalImage)
          movieIDArr.append(index.id)
        }
      }
      
      cell.configure(url: mainURLs, title: "영어 공부하기 좋은 영화", movieIDs: movieIDArr)
      cell.delegate = self
      return cell
      
    case 13:
      let cell = SubCell()
      var mainURLs: [String] = []
      var movieIDArr: [Int] = []
      
      if let data = path.disneyMovie {
        for index in data {
          mainURLs.append(index.verticalImage)
          movieIDArr.append(index.id)
        }
      }
      
      cell.configure(url: mainURLs, title: "디즈니 영화", movieIDs: movieIDArr)
      cell.delegate = self
      return cell
      
      
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: SubCell.identifier, for: indexPath) as! SubCell
      cell.configure(url: imageUrls, title: "\(indexPath)", movieIDs: nil)
      cell.delegate = self
      return cell
    }
  }
  
}

// 미리보기
extension MainHomeVC: PreviewTableCellDelegate {
  func didSelectItemAt(indexPath: IndexPath, logoArr: [URL?]?, videoItems: [AVPlayerItem]?, idArr: [Int]?) {
    preViewPlayerVC = PreViewPlayerVC()
    preViewPlayerVC?.delegate = self
    preViewPlayerVC?.logoURLs = logoArr
    preViewPlayerVC?.playerItems = videoItems
    preViewPlayerVC?.idArr = idArr
    guard let view = preViewPlayerVC else { return }
    present(view, animated: true)
  }
}

extension MainHomeVC: PreViewPlayerVCDelegate {
  func finishVideo() {
    print("아에헹")
    preViewPlayerVC = nil
    AppDelegate.instance.checkLoginState()
  }
  
  
}


extension MainHomeVC: OriginalTableCellDelegate {
  
  
  func originalDidSelectItemAt(movieId: Int, movieInfo: MovieDetail) {
    
    // 오리지널 눌렀을때
    let detailVC = DetailVC()
    detailVC.movieId = movieId
    detailVC.movieDetailData = movieInfo
    
    self.present(detailVC, animated: true)
  }
  
}


extension MainHomeVC: WatchingMoviesTableCellDelegate {
  func WatchingMovielDidSelectItemAt(movieId: Int, url: String, movieTitle: String) {
    
    // 시청중인 콘텐츠 ===> 플레이어로 연결
    let player = PlayerVC()
    
    let url = url
    let title = movieTitle
    let id = movieId
    
    player.configure(id: id, title: title, videoPath: url, seekTime: nil)
    AppDelegate.instance.shouldSupportAllOrientation = false
    self.present(player, animated: true)
  }
  
}



extension MainHomeVC: UITableViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let state = tableView.cellForRow(at: IndexPath(row: 5, section: 0))?.alpha
    
    streamingCellFocus = (state == nil) ? false : true
    
    let offset = scrollView.contentOffset.y
    
    let transition = scrollView.panGestureRecognizer.translation(in: scrollView).y.rounded()
    
    let fixValue = floatingView.frame.size.height
    
    var floatValue: CGFloat {
      get {
        return originValue
      }
      set {
        if newValue > -fixValue && newValue < 0 {
          originValue = newValue
        } else if newValue < -fixValue {
          originValue = -fixValue
        } else {
          return
        }
        
      }
    }
    
    
    if compareArr.count > 1 {
      compareArr.remove(at: 0)
    }
    compareArr.append(offset)
    
    if offset <= -topPadding {
      floatingView.frame.origin.y = -10
      return
    }
    
    if compareArr.count == 2 {
      if compareArr[0] > compareArr[1] {
        // show
        let addtionalValue = compareArr[1] - compareArr[0]
        floatValue += -addtionalValue
        originY = floatValue - 10
        return
      } else if compareArr[0] < compareArr[1] {
        // hide
        let addtionalValue = compareArr[1] - compareArr[0]
        floatValue += -addtionalValue
        originY = floatValue - 10
        
        return
      } else {
        return
      }
    }
    
    
  
  }
}


extension MainHomeVC: FloatingViewDelegate {
  func didTapHome() {
    AppDelegate.instance.checkLoginState()
  }
  
  func didTapMovie() {
    streamingCell.pauseVideo()
    
    APICenter.shared.getMovieData {
      switch $0 {
      case .success(let value):
        
        DispatchQueue.main.async {
          let mainMovieVC = MainMovieVC()
          mainMovieVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "tabBarhome2"), tag: 0)
          mainMovieVC.receiveData = value
          self.tabBarController?.viewControllers?[0] = mainMovieVC
        }
      case .failure(let err):
        dump(err)
      }
    }
  }
  
  func didTapPoke() {
    print("일단 눌러는 지는 겁니까????")
    
    streamingCell.pauseVideo()
//    let mainPokeVC = MainPokeVC()
//    mainPokeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "tabBarhome2"), tag: 0)
//    tabBarController?.viewControllers?[0] = mainPokeVC
    
    
    
    let mainPokeVC = MainPokeVC()
    
    var imgPaths: [String] = []
    var movieIDArr: [Int] = []
    
    APICenter.shared.getListOfFork {
      switch $0 {
      case .success(let list):
        
        for i in 0...list.count - 1 {
          imgPaths.append(list[i].verticalImage)
          movieIDArr.append(list[i].id)
        }
        DispatchQueue.main.async {
          mainPokeVC.mainPokeView.configure(url: imgPaths, movieIDs: movieIDArr)
//          self.navigationController?.show(mainPokeVC, sender: nil)
          
          mainPokeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "tabBarhome2"), tag: 0)
          self.tabBarController?.viewControllers?[0] = mainPokeVC
          
        }
        
      case .failure(let err):
        print("fail to parsing, reason: ", err)
        let message = """
          죄송합니다. 찜 정보를 가져오는데
          실패했습니다.
          다시 시도하세요.
          """
        self.oneAlert(title: "실패", message: message, okButton: "찜 목록 다시 확인하기")
      }
    }
  }
}

extension MainHomeVC: SubTableCellDelegate {
  func errOccurSendingAlert(message: String, okMessage: String) {
    self.oneAlert(title: "영화데이터 오류", message: message, okButton: okMessage)
  }
  
  func didSelectItemAt(movieId: Int, movieInfo: MovieDetail) {
    
    DispatchQueue.main.async {
      print("영화정보 디테일: ", movieId, movieInfo.name)
      let detailVC = DetailVC()
      detailVC.movieId = movieId
      detailVC.movieDetailData = movieInfo
      
      self.present(detailVC, animated: true)
    }
  }
}


extension MainHomeVC: MainImageTableCellDelegate {
  func mainImageCelltoDetailVC(id: Int) {
    
    APICenter.shared.getDetailData(id: mainMovieId!) {
      switch $0 {
      case .success(let movie):
        print("디테일뷰 다시띄우기 위해 영화정보 다시 띄우기: ", movie.id, movie.name)
        DispatchQueue.main.async {
          let detailVC = DetailVC()
          detailVC.movieId = self.mainMovieId!
          detailVC.movieDetailData = movie
          self.present(detailVC, animated: true)
        }
      case .failure(let err):
        print("fail to login, reason: ", err)
        
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
  
  func playVideo(id: Int) {
    print("run playVideo")
    let player = PlayerVC()
    
    let url = path.mainImageCellData?.mainMovie?.videoFile
    let title = path.mainImageCellData?.mainMovie?.name
    let id = path.mainImageCellData?.mainMovie?.id
    
    player.configure(id: id, title: title, videoPath: url, seekTime: nil)
    AppDelegate.instance.shouldSupportAllOrientation = false
    self.present(player, animated: true)
  }
  
  
}
