//
//  UserIconSelectVC.swift
//  Fastflix
//
//  Created by HongWeonpyo on 02/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class UserIconSelectVC: UIViewController {
  
  // 네이게이션뷰
  lazy var navigationView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.addSubview(backButton)
    view.addSubview(titleLabel)
    return view
  }()
  
  // 뒤로가기 버튼
  lazy var backButton: UIButton = {
    let button = UIButton(type: .system)
    let image = UIImage(named: "back")
    button.setImage(image, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.tintColor = .white
    button.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    return button
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "아이콘 선택"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 18)
    return label
  }()
  
  var profileImages = [String: [ProfileImageElement]]()
  
  var categories: [String] = []
  
  let tableView: UITableView = {
      let tableView = UITableView()
      return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configure()
    addSubViews()
    navigationBarSetting()
    setupSNP()
  }
  
  private func configure() {
    view.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
    tableView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
    tableView.dataSource = self
    tableView.rowHeight = 160
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    tableView.separatorColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
    tableView.register(UserIconTableCell.self, forCellReuseIdentifier: "UserIconTableCell")
    tableView.allowsSelection = false
    tableView.reloadData()
    
  }
  
  private func addSubViews() {
    view.addSubview(navigationView)
    view.addSubview(tableView)
  }
  
  private func setupSNP() {
    
    navigationView.snp.makeConstraints {
      $0.top.equalTo(view.snp.top)
      $0.leading.equalTo(view.snp.leading)
      $0.trailing.equalTo(view.snp.trailing)
      $0.height.equalTo(UIScreen.main.bounds.height * 0.11)
    }
    
    backButton.snp.makeConstraints {
      $0.bottom.equalTo(navigationView.snp.bottom).offset(-12)
      $0.width.height.equalTo(20)
      $0.leading.equalTo(view.snp.leading).offset(15)
    }
    
    titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(navigationView.snp.bottom).offset(-12)
    }
  
    tableView.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func navigationBarSetting() {
    let navCon = navigationController!
    navCon.isNavigationBarHidden = true
  }
  
  @objc private func backButtonTapped(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  
}

extension UserIconSelectVC: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return  categories.count
  }
  
  // 각 섹션별로는 테이블 1개만 존재
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // 현재의 뷰 컨트롤러에서 각 테이블뷰셀에 각 카테고리에 따른 1)카테고리이름 2) 카테고리에 해당하는 이미지요소 배열 전달
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserIconTableCell", for: indexPath) as? UserIconTableCell
    let aCategory = self.categories[indexPath.section]
    if let imageArray = profileImages[aCategory] {
      cell?.setupTableViewCell(category: aCategory, items: imageArray)
    }
    cell?.cellDelegate = self
    cell?.headerLabel.text = "  " + "\(self.categories[indexPath.section])"
    return cell!
  }
  
}

// MARK: - 테이블뷰안의 컬렉션뷰 안의 셀을 선택한 후의 동작에 대한 델리게이트 구현
extension UserIconSelectVC: UserIconCollectionCellDelegate {
  func collectionViewCellDidTap(collectioncell: UserIconCollectionViewCell?, imageURL: String, didTappedInTableview TableCell: UserIconTableCell) {
    
    print("클릭은 전달됨?????")
    //셀 선택 후 이미지 전달해야함
    if let cell = collectioncell {
      print("안으로 들어감?")
      let image = cell.mainImageView.image
      
      // 이미지 주소값 던져야함
      let imagePath = cell.imageURL
      
      guard let navi = presentingViewController as? UINavigationController else { return print("네비리턴")}
      guard let profileChangeVC = navi.viewControllers.first as? ProfileChangeVC else { return print("뷰컨없음") }
      
      print("????")
      
      profileChangeVC.profileImagePath = imagePath
      profileChangeVC.userView.userImageView.image = image ?? UIImage(named: "profile1")
      
      dismiss(animated: true)
    }
  }
}
