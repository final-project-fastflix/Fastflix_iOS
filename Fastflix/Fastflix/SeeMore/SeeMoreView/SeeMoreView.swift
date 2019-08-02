//
//  SeeMoreView.swift
//  Fastflix
//
//  Created by Jeon-heaji on 25/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

// MARK: - 델리게이트 1) 로그아웃 버튼 눌렀을때, 2) 프로필추가버튼눌렀을때 3) 프로필관리 눌렀을때
protocol SeeMoreViewDelegate: class {
  func logoutCellDidTap(indexPath: IndexPath)
  func addProfileButtonDidTap()
  func profileAdminButtonDidTap()
}

import UIKit
import SnapKit
import Kingfisher

class SeeMoreView: UIView {
  
  // 서브유저 저장을 위한 싱글톤
  let subUserSingle = SubUserSingleton.shared

  
  // 로그인 하면서 싱글톤에 "서브유저 리스트"를 저장함 ==> 뷰 로드시점에 싱글톤에서 numberOfUsers(유저 숫자)불러옴
  var numberOfUsers: Int?
  // 뷰 로드시점에 싱글톤에서 "서브유저 리스트"불러옴
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

  let tableView = UITableView()
  
  // 유저정보를 위한 뷰
  var profileView1 = ProfileView()
  var profileView2 = ProfileView()
  var profileView3 = ProfileView()
  var profileView4 = ProfileView()
  var profileView5 = ProfileView()
  var addView = AddView()
  lazy var viewArray = [profileView1, profileView2, profileView3, profileView4, profileView5, addView]
  
  // 유저뷰(ProfileView) 및 프로필추가(AddView)를 위한 스택뷰
  lazy var profileStackView: UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
    view.spacing = 15
    return view
  }()
  

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
   
  }
  
  // MARK: - 뷰 생성
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = #colorLiteral(red: 0.05203045685, green: 0.05203045685, blue: 0.05203045685, alpha: 1)
    // 생성 시점에 싱글톤에서 서브유저 리스트와 유저 숫자를 불러옴
    subUserList = subUserSingle.subUserList
    numberOfUsers = subUserSingle.subUserList?.count
    
    setupDelegate()
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
  
  // MARK: - 델리게이트 설정
  private func setupDelegate() {
    [profileView1, profileView2, profileView3, profileView4, profileView5].forEach { $0.delegate = self }
    addView.delegate = self
  }
  
  // MARK: - 서브유저 중에서 몇번째 유저가 현재 선택되어 있는지를 확인
  func checkingSelectedSubUser() {
    
    // 유저디폴트에 있는 서브유저 아이디(getSubUserID)와 싱글톤의 서브유저리스트의 아이디가 같은 인덱스(서브유저 순서/위치) 뽑아냄
    let index = subUserSingle.subUserList?.firstIndex(where: { $0.id == APICenter.shared.getSubUserID() })
    
    // 뽑아낸 인덱스 위치에 isSelected속성을 true로 넘겨서, 선택되어 있다는 것을 알림 / 나머지는 선택되어 있지 않음
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
      $0.top.equalTo(topView.snp.top).offset(50)
      $0.height.equalTo(80)
      $0.centerX.equalTo(topView.snp.centerX)
    }
    profileAdminBtn.snp.makeConstraints {
      $0.top.equalTo(profileStackView.snp.bottom).offset(23)
      $0.centerX.equalToSuperview()
    }
  }
  
  // MARK: - 유저의 숫자에 따라 각 유저의 뷰(ProfileView)에 UI구현을 위한 정보 전달 (이름, 태그(아이디), 이미지url)
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
  
  // MARK: - 유저의 수에 따라 스택뷰에서 보이는 것(몇명이 보일지, 프로필추가는 보일지 말지)을 구현 하기 위한 메서드
  // 스택뷰위에 올려진 뷰들은 isHidden의 속성에 따라 자동으로 스택뷰에서 나타나기도 하고 사라지기도 함
  // 유저 재선택에 따라 뷰가 변할 수 있으므로, 뷰 재설정을 위한 setNeedsLayout(), layoutIfNeeded() 메서드 추가
  func setupProfileLayout() {
    
    switch numberOfUsers {
    case 1:
      [profileView2, profileView3, profileView4, profileView5].forEach { $0.isHidden = true }
      [profileView1,addView].forEach { $0.isHidden = false }
      [profileView1, profileView2, profileView3, profileView4, profileView5, addView].forEach {
        $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
    case 2:
      [profileView3, profileView4, profileView5].forEach { $0.isHidden = true }
      [profileView1, profileView2, addView].forEach { $0.isHidden = false }
      [profileView1, profileView2, profileView3, profileView4, profileView5, addView].forEach { $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
    case 3:
      [profileView4, profileView5].forEach { $0.isHidden = true }
      [profileView1, profileView2, profileView3, addView].forEach { $0.isHidden = false }
      [profileView1, profileView2, profileView3, profileView4, profileView5, addView].forEach { $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
    case 4:
      profileView5.isHidden = true
      [profileView1, profileView2, profileView3, profileView4, addView].forEach { $0.isHidden = false }
      [profileView1, profileView2, profileView3, profileView4, profileView5, addView].forEach { $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
    case 5:
      [profileView1, profileView2, profileView3, profileView4, profileView5].forEach { $0.isHidden = false }
      addView.isHidden = true
      [profileView1, profileView2, profileView3, profileView4, profileView5, addView].forEach { $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
    default:
      addView.isHidden = true
    }
  }
  
  // MARK: - "프로필 관리" 눌렀다는 것을 뷰컨트롤러에 알리기 위함
  @objc func profileAdminBtnDidTap(_ sender: UIButton) {
    print("@@@@profileAdminBtnDidTap")
    delegate?.profileAdminButtonDidTap()
  }
  
  @objc func profileViewDidTap(_ sender: Any) {

  }
  
  @objc func profileAddDidTap(_ sender: Any) {

  }

}

// MARK: - TableView Extension
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

// MARK: - 테이블뷰 델리게이트 구현
extension SeeMoreView: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.logoutCellDidTap(indexPath: indexPath)
  }
}

// MARK: - 프로필 선택(태그로 유저 전달) 델리게이트 구현
extension SeeMoreView: ProfileViewDelegate {
  // ProfileView에서 선택하면 델리게이트로 SeeMoreView로 전달
  func didSelectUser(tag: Int) {
    // 선택된 서브유저 아이디 유저디폴트에 저장
    APICenter.shared.saveSubUserID(id: tag)
    // 선택하면 누가 선택되었는지 확인 및 레이아웃 다시 잡기
    AppDelegate.instance.reloadRootView()
//    checkingSelectedSubUser()
//    setupProfileLayout()
  }
}

// MARK: - "프로필추가" 버튼에 대한 델리게이트 구현
extension SeeMoreView: AddViewDelegate {
  // AddView에서 누르면 델리게이트로 SeeMoreView로 전달 다시 "뷰컨트롤러"로 전달
  func addProfileButtonTapped() {
    delegate?.addProfileButtonDidTap()
  }
}
