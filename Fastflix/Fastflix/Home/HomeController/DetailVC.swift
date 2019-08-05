//
//  DetailVC.swift
//  Fastflix
//
//  Created by HongWeonpyo on 17/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

final class DetailVC: UITableViewController {
  
  var movieImage: UIImage?
  var movieId: Int?
  var movieDetailData: MovieDetail?
  
  private let movieTitleLabel: UILabel = {
    let label = UILabel()
//    label.text = "토이스토리"
    label.textColor = .white
    label.font = UIFont.boldSystemFont(ofSize: 18)
    return label
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupDetailInfo()
    setTableView()
    registerTableViewCell()
    
  }
  
  private func setupDetailInfo() {
    //    movieDetailData.
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
  }
  
  // 테이블뷰 데이터소스
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.row {
    case 0 :
      let cell = tableView.dequeueReusableCell(withIdentifier: "DetailViewUpperCell", for: indexPath) as! DetailViewUpperCell
      cell.delegate = self
      
      // 무비아이디전달
      cell.movieId(movieId)
      // 이미지는 있는 것으로 그냥 전달
      cell.configureImage(image: movieImage)
      
      // 남은시간비율(Float)에 대한 계산 공식
      let sliderFloat = Float(0.3455555)
      let remainingTime = String(movieDetailData?.remainingTime ?? 0)
      
      let actorsss = "\(String(describing: movieDetailData?.actors[0].name)) + \(String(describing: movieDetailData?.actors[1].name))"
      let director = "\(String(describing: movieDetailData?.directors[0].name))"
      
      // 무비아이디, 이미지 이외의 데이터를 표시하고 있는 디테일뷰의 테이블뷰에 전달
      cell.detailDataSetting(matchRate: movieDetailData?.matchRate, productionDate: movieDetailData?.productionDate, degree: movieDetailData?.degree.name, runningTime: movieDetailData?.runningTime, sliderTime: sliderFloat, remainingTime: remainingTime, synopsis: movieDetailData?.synopsis, actors: actorsss, directors: director)
    
      return cell
      
    case 1 :
      let cell = tableView.dequeueReusableCell(withIdentifier: "DetailViewBelowCell", for: indexPath) as! DetailViewBelowCell
      cell.delegate = self
      // 셀에 비슷한 콘텐츠 내용 들어가야함
      
      
      
      
      
      
      
      
      return cell
      
    default:
      return UITableViewCell()
    }
  }
}

// (델리게이트) 플레이버튼 눌렀을때 플레이어 띄우기
extension DetailVC: PlayButtonDelegate {
  func didTapDismissBtn() {
    dismiss(animated: true)
  }
  
  func playButtonDidTap(sender: UIButton) {
    let detailVC = DetailVC()
    present(detailVC, animated: true)
  }
}

// (델리게이트) 디테일뷰 다시 띄우기
extension DetailVC: DetailViewCellDelegate {
  func detailViewDidSelectItemAt(indexPath: IndexPath) {
    let detailVC = DetailVC()
    present(detailVC, animated: true)
  }
}
