//
//  SeeMoreView.swift
//  Fastflix
//
//  Created by Jeon-heaji on 25/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//
protocol SeeMoreViewDelegate {
  func logoutCellDidTap(indexPath: IndexPath)
}

import UIKit
import SnapKit
import Kingfisher


class SeeMoreView: UIView {
  
  let subUserSingle = SubUserSingleton.shared
  
//  var profileCount = 0
  var numberOfUsers: Int?
  var subUserList: [SubUser]?
  
  var delegate: SeeMoreViewDelegate?
  
  let datas = [ "앱설정", "계정", "개인정보", "고객 센터", "로그아웃"]
  let notificationData = ["내가 찜한 콘텐츠"]
  let pokeData = [" 알림 설정"]
  
  let topView: UIView = {
    let topView = UIView()
    topView.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    return topView
  }()
  
  let profileAdminBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.addTarget(self, action: #selector(profileAdminBtnDidTap(_:)), for: .touchUpInside)
    button.setImage(UIImage(named: "profileEdit"), for: .normal)
    button.setTitle("  프로필 관리", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    button.setTitleColor(.gray, for: .normal)
    return button
  }()
  
  let profileAddLabel: UILabel = {
    let label = UILabel()
    label.text = "프로필 추가"
    label.font = UIFont.systemFont(ofSize: 15, weight: .light)
    label.textColor = .gray
    return label
  }()
  
//  lazy var profileView: ProfileView = {
//    let view = ProfileView()
////    view.configure(image: UIImage(named: "profile3"), name: "hea")
//    return view
//  }()
  
//  lazy var profileAddView: ProfileView = {
//    let view = ProfileView()
////    view.configure(image: nil, name: nil)
//    view.profileNameLabel.textColor = .gray
//    let tap = UITapGestureRecognizer(target: self, action: #selector(profileAddDidTap(_:)))
//    view.userImageView.addGestureRecognizer(tap)
//    view.userImageView.isUserInteractionEnabled = true
//    return view
//  }()
  
  let tableView = UITableView()
  
  var profileView1 = UserView()
  var profileView2 = UserView()
  var profileView3 = UserView()
  var profileView4 = UserView()
  var profileView5 = UserView()
  lazy var viewArray = [profileView1, profileView2, profileView3, profileView4, profileView5]
  
  lazy var profileStackView: UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
    view.distribution = .fillEqually
    view.spacing = 20
    return view
  }()

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    setupStackView()
    addSubViews()
    setupSNP()
    setupTableView()
    setUserViews()
  }
  
  func setupStackView() {
    viewArray.forEach { profileStackView.addArrangedSubview($0) }
  
  }
  
  
  private func setupTableView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = #colorLiteral(red: 0.1087603109, green: 0.1087603109, blue: 0.1087603109, alpha: 1)
    tableView.separatorColor = .black
    
  }
  
  private func addSubViews() {
    [topView, tableView].forEach { self.addSubview($0)}
      [profileStackView, profileAdminBtn].forEach {topView.addSubview($0)}
  }
  
  private func setupSNP() {
    topView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.31)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(topView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    profileStackView.snp.makeConstraints {
      $0.top.equalTo(topView.snp.top).offset(20)
      $0.centerX.equalTo(topView.snp.centerX)
    }
    
    profileAdminBtn.snp.makeConstraints {
      $0.top.equalTo(profileStackView.snp.bottom).offset(25)
      $0.centerX.equalToSuperview()
    }
  }
  
  func setUserViews() {
    
    switch numberOfUsers {
    case 5:
      profileView5.profileUserName = subUserList?[4].name
      profileView5.tag = (subUserList?[4].id)!
      profileView5.configureImage(imageURLString: subUserList?[4].profileInfo.profileImagePath)
      fallthrough
    case 4:
      profileView4.profileUserName = subUserList?[3].name
      profileView4.tag = (subUserList?[3].id)!
      profileView4.configureImage(imageURLString: subUserList?[3].profileInfo.profileImagePath)
      fallthrough
    case 3:
      profileView3.profileUserName = subUserList?[2].name
      profileView3.tag = (subUserList?[2].id)!
      profileView3.configureImage(imageURLString: subUserList?[2].profileInfo.profileImagePath)
      fallthrough
    case 2:
      profileView2.profileUserName = subUserList?[1].name
      profileView2.tag = (subUserList?[1].id)!
      profileView2.configureImage(imageURLString: subUserList?[1].profileInfo.profileImagePath)
      fallthrough
    case 1:
      profileView1.profileUserName = subUserList?[0].name
      profileView1.tag = (subUserList?[0].id)!
      profileView1.configureImage(imageURLString: subUserList?[0].profileInfo.profileImagePath)
    default:
      return
    }
  }
  
  @objc func profileAdminBtnDidTap(_ sender: UIButton) {
    print("@@@@profileAdminBtnDidTap")
  }
  
  @objc func profileAddDidTap(_ sender: Any) {
    print("프로필추가추가추가추가추가추가")
    
    //    let createProfielVC = CreateProfileVC()
    //    present(createProfielVC, animated: true)
    
  }

}
// tableView extension
extension SeeMoreView: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch section {
    case 0:
      return notificationData.count
    case 1:
      return pokeData.count
    case 2:
      return datas.count
    default:
      return 0
    }
    
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2))
    footerView.backgroundColor = .black
    return footerView
  }
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 2
  }
  
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    cell.selectionStyle = .none
    cell.backgroundColor = #colorLiteral(red: 0.08262611039, green: 0.08262611039, blue: 0.08262611039, alpha: 1)
    cell.textLabel?.textColor = .lightGray
    cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
    tableView.separatorStyle = .none
    
    switch indexPath.section {
    case 0:
      if indexPath.row == 0 {
        cell.imageView?.image = UIImage(named: "notification")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = " 알림 설정"
        tableView.separatorStyle = .none
      } else {
        cell.textLabel?.text = notificationData[indexPath.row]
      }
    case 1:
      if indexPath.row == 0 {
        cell.imageView?.image = UIImage(named: "check")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "내가 찜한 콘텐츠"
        
      } else {
        cell.textLabel?.text = pokeData[indexPath.row]
      }
    case 2:
      cell.textLabel?.text = datas[indexPath.row]
      
    default:
      break
    }
    
    return cell
  }
  
}


extension SeeMoreView: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.logoutCellDidTap(indexPath: indexPath)
  }
  
  
}
