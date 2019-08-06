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
      guard newValue >= -94 || newValue <= 0 else { return }
      floatingView.frame.origin.y = newValue
    }
  }
  
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
  
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addSubViews()
    registerTableViewCell()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupSNP()
  }
  
  
  
  private func addSubViews() {
    [tableView, floatingView].forEach { view.addSubview($0) }
  }
  
  private func setupSNP() {
    tableView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    floatingView.snp.makeConstraints {
      $0.leading.trailing.top.equalToSuperview()
      $0.height.equalTo(50 + topPadding)
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
    return 8
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: MainImageTableCell.identifier, for: indexPath) as! MainImageTableCell
      let bigImgPath = path.mainImageCellData?.mainMovie?.iosMainImage
      let logoImgPath = path.mainImageCellData?.mainMovie?.logoImagePath
      var text = ""
      
      cell.delegate = self
      cell.configure(imageURLString: bigImgPath, logoImageURLString: logoImgPath)
      if let data = path.mainImageCellData?.mainMovie?.genre {
        for idx in data {
          text += (idx.name + "･")
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
      if let data = path.preViewCellData {
        for index in data {
          mainURLs.append(index.circleImage)
          logoURLs.append(index.logoImagePath)
        }
      }
      cell.configure(mainURLs: mainURLs, logoURLs: logoURLs)
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
      return cell
      
    case 7:
      let cell = tableView.dequeueReusableCell(withIdentifier: WatchingMoviesTableCell.identifier, for: indexPath) as! WatchingMoviesTableCell
      if let data = path.followUpMovie {
        cell.configure(data: data, title: "시청중인 영화")
      }
      cell.selectionStyle = .none
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


extension MainHomeVC: PreviewTableCellDelegate {
  func didSelectItemAt(indexPath: IndexPath) {
    let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/test-64199.appspot.com/o/%E1%84%82%E1%85%A6%E1%86%BA%E1%84%91%E1%85%B3%E1%86%AF%E1%84%85%E1%85%B5%E1%86%A8%E1%84%89%E1%85%B3%E1%84%86%E1%85%B5%E1%84%85%E1%85%B5%E1%84%87%E1%85%A9%E1%84%80%E1%85%B5%E1%84%80%E1%85%A1%E1%84%8B%E1%85%A9%E1%84%80%E1%85%A2%E1%86%AF2.mp4?alt=media&token=96a3f3ef-3ff9-4f05-9675-2f13232a72cf")!
    
    let playerVC = AVPlayerViewController()
    let player = AVPlayer(url: url)
    playerVC.player = player
    
    present(playerVC, animated: true) {
      playerVC.player?.play()
    }
  }
  
}


extension MainHomeVC: OriginalTableCellDelegate {
  func originalDidSelectItemAt(indexPath: IndexPath) {
    let detailVC = DetailVC()
    present(detailVC, animated: true)
  }
  
}
extension MainHomeVC: WatchingMoviesTableCelllDelegate {
  func WatchingMovielDidSelectItemAt(indexPath: IndexPath) {
    print("MainHomeVC : WatchingMovielDidSelectItemAt")
  }
  
  
}

extension MainHomeVC: UITableViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let state = tableView.cellForRow(at: IndexPath(row: 5, section: 0))?.alpha
    
    streamingCellFocus = (state == nil) ? false : true
    
    let offset = scrollView.contentOffset.y
    
    let transition = scrollView.panGestureRecognizer.translation(in: scrollView).y.rounded()
    
    let fixValue = floatingView.frame.size.height
    
    var compareValue: CGFloat = 0
    
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
    
    if offset <= -44 {
      floatingView.frame.origin.y = 0
      return
    }
    
    if compareArr.count == 2 {
      if compareArr[0] > compareArr[1] {
        // show
        let addtionalValue = compareArr[1] - compareArr[0]
        floatValue += -addtionalValue
        originY = floatValue
        return
      } else if compareArr[0] < compareArr[1] {
        // hide
        let addtionalValue = compareArr[1] - compareArr[0]
        floatValue += -addtionalValue
        originY = floatValue
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
    streamingCell.pauseVideo()
    let mainPokeVC = MainPokeVC()
    mainPokeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "tabBarhome2"), tag: 0)
    tabBarController?.viewControllers?[0] = mainPokeVC
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
  func playVideo() {
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
