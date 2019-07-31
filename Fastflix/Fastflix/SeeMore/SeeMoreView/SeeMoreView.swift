//
//  SeeMoreView.swift
//  Fastflix
//
//  Created by Jeon-heaji on 25/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//
protocol SeeMoreViewDelegate: class {
  func logoutCellDidTap(indexPath: IndexPath)
  func didSelectUser(tag: Int)
}

import UIKit
import SnapKit
import Kingfisher

class SeeMoreView: UIView {
  
  let subUserSingle = SubUserSingleton.shared
  
//  var profileCount = 0
  
  var numberOfUsers: Int?
  var subUserList: [SubUser]? {
    didSet {
      numberOfUsers = subUserList?.count
    }
  }
  
  
  weak var delegate: SeeMoreViewDelegate?
  
  let datas = [ "앱설정", "계정", "개인정보", "고객 센터", "로그아웃"]
  let notificationData = ["내가 찜한 콘텐츠"]
  let pokeData = [" 알림 설정"]
  
  let topView: UIView = {
    let topView = UIView()
    topView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
//    let tap = UITapGestureRecognizer(target: self, action: #selector(profileAddDidTap(_:)))
//    view.addGestureRecognizer(tap)
//    view.isUserInteractionEnabled = true
//    return view
//  }()

  let tableView = UITableView()
  
  var profileView1: ProfileView = {
    let view = ProfileView()
    let tap = UITapGestureRecognizer(target: self, action: #selector(profileViewDidTap(_:)))
    view.addGestureRecognizer(tap)
    view.isUserInteractionEnabled = true
    return view
  }()
  var profileView2: ProfileView = {
    let view = ProfileView()
    let tap = UITapGestureRecognizer(target: self, action: #selector(profileViewDidTap(_:)))
    view.addGestureRecognizer(tap)
    view.isUserInteractionEnabled = true
    return view
  }()
  var profileView3: ProfileView = {
    let view = ProfileView()
    let tap = UITapGestureRecognizer(target: self, action: #selector(profileViewDidTap(_:)))
    view.addGestureRecognizer(tap)
    view.isUserInteractionEnabled = true
    return view
  }()
  var profileView4: ProfileView = {
    let view = ProfileView()
    let tap = UITapGestureRecognizer(target: self, action: #selector(profileViewDidTap(_:)))
    view.addGestureRecognizer(tap)
    view.isUserInteractionEnabled = true
    return view
  }()
  var profileView5: ProfileView = {
    let view = ProfileView()
    let tap = UITapGestureRecognizer(target: self, action: #selector(profileViewDidTap(_:)))
    view.addGestureRecognizer(tap)
    view.isUserInteractionEnabled = true
    return view
  }()
  
  var addView = AddView()
  lazy var viewArray = [profileView1, profileView2, profileView3, profileView4, profileView5, addView]
  
  lazy var profileStackView: UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
//    view.distribution = .fillEqually
    view.spacing = 15
    return view
  }()

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    subUserList = subUserSingle.subUserList
    numberOfUsers = subUserSingle.subUserList?.count
    
    print("씨모어의 뷰의 유저리스트: ",  subUserList)
    print("씨모어뷰의 싱글톤의 유저리스트: ", SubUserSingleton.shared.subUserList)
    addSubViews()
    setupSNP()
    setupTableView()
  
    setupStackView()
    setUserViews()
    setupProfileLayout()
    checkingSelectedSubUser()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func checkingSelectedSubUser() {
    
    let index = subUserSingle.subUserList?.firstIndex(where: { $0.id == APICenter.shared.getSubUserID() })
    
    switch index {
    case 0:
      profileView1.isSelected = true
      [profileView2, profileView3, profileView4, profileView5].forEach { $0.isSelected = false }
    case 1:
      profileView2.isSelected = true
      [profileView1, profileView3, profileView4, profileView5].forEach { $0.isSelected = false }
    case 2:
      profileView3.isSelected = true
      [profileView1, profileView2, profileView4, profileView5].forEach { $0.isSelected = false }
    case 3:
      profileView4.isSelected = true
      [profileView1, profileView2, profileView3, profileView5].forEach { $0.isSelected = false }
    case 4:
      profileView5.isSelected = true
      [profileView1, profileView2, profileView3, profileView4].forEach { $0.isSelected = false }
    default:
      profileView5.isSelected = true
    }
  }
  
  
  func setupStackView() {
    viewArray.forEach { profileStackView.addArrangedSubview($0) }
  
  }
  
  
  private func setupTableView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
    tableView.separatorColor = .black
    
  }
  
  private func addSubViews() {
//    profileView1.isSelected = true
    [topView, tableView].forEach { self.addSubview($0)}
      [profileStackView, profileAdminBtn].forEach {topView.addSubview($0)}
  }
  
  private func setupSNP() {
    topView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.3)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(topView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    addView.snp.makeConstraints {
      $0.width.equalTo(60)
      $0.height.equalTo(75)
    }
    
    profileStackView.snp.makeConstraints {
      $0.top.equalTo(topView.snp.top).offset(60)
      $0.height.equalTo(80)
      $0.centerX.equalTo(topView.snp.centerX)
    }
    
    profileAdminBtn.snp.makeConstraints {
      $0.top.equalTo(profileStackView.snp.bottom).offset(25)
      $0.centerX.equalToSuperview()
    }
  }
  
  func setUserViews() {
    
    print("유저숫자는???????", numberOfUsers)
    print("서브유저는???????", subUserList)
    
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
  
  func setupProfileLayout() {
    
    switch numberOfUsers {
    case 1:
      [profileView2, profileView3, profileView4, profileView5].forEach { $0.isHidden = true }
      [profileView1,addView].forEach { $0.isHidden = false }
      
      [profileView1, profileView2, profileView3, profileView4, profileView5, addView].forEach {
        $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
      print("======================유저 1명======================")
    case 2:
      [profileView3, profileView4, profileView5].forEach { $0.isHidden = true }
      [profileView1, profileView2, addView].forEach { $0.isHidden = false }
 
      [profileView1, profileView2, profileView3, profileView4, profileView5, addView].forEach { $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
      print("======================유저 2명======================")
    case 3:
      [profileView4, profileView5].forEach { $0.isHidden = true }
      [profileView1, profileView2, profileView3, addView].forEach { $0.isHidden = false }

      [profileView1, profileView2, profileView3, profileView4, profileView5, addView].forEach { $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
      print("======================유저 3명======================")
    case 4:
      profileView5.isHidden = true
      [profileView1, profileView2, profileView3, profileView4, addView].forEach { $0.isHidden = false }

      [profileView1, profileView2, profileView3, profileView4, profileView5, addView].forEach { $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
      print("======================유저 4명======================")
    case 5:
      [profileView1, profileView2, profileView3, profileView4, profileView5].forEach { $0.isHidden = false }
      addView.isHidden = true
      [profileView1, profileView2, profileView3, profileView4, profileView5, addView].forEach { $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
      print("======================유저 5명======================")
    default:
      addView.isHidden = true
    }
  }
  
  
  
  @objc func profileAdminBtnDidTap(_ sender: UIButton) {
    print("@@@@profileAdminBtnDidTap")
  }
  
  @objc func profileViewDidTap(_ sender: Any) {
    print("프로필선택")
    
    //    let createProfielVC = CreateProfileVC()
    //    present(createProfielVC, animated: true)
    
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
    cell.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
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
