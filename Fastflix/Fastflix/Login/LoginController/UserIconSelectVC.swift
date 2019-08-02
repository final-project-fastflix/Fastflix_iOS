//
//  UserIconSelectVC.swift
//  Fastflix
//
//  Created by HongWeonpyo on 02/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class UserIconSelectVC: UIViewController {
  
  var profileImages = [String: [ProfileImageElement]]()
  
  var categories: [String] = []
  
  let tableView: UITableView = {
      let tableView = UITableView()
      return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configure()
    addSubViews()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupSNP()
  }
  
  private func configure() {
    view.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
    tableView.dataSource = self
//    tableView.rowHeight = 160
    tableView.register(UserIconTableCell.self, forCellReuseIdentifier: "UserIconTableCell")
  }
  
  private func addSubViews() {
    view.addSubview(tableView)
  }
  
  private func setupSNP() {
    tableView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
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
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 160
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // 현재의 뷰 컨트롤러에서 각 테이블뷰셀에 각 카테고리에 따른 1)카테고리이름 2) 카테고리에 해당하는 이미지요소 배열 전달
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserIconTableCell", for: indexPath) as? UserIconTableCell
    let aCategory = self.categories[indexPath.section]
    if let imageArray = profileImages[aCategory] {
      cell?.setupTableViewCell(category: aCategory, items: imageArray)
    }
    cell?.cellDelegate = self
    return cell!
  }
  
  private func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "UserIconHeaderView") as? UserIconHeaderView
    let aCategory = self.categories[section]
    headerView?.headerLabel.text = aCategory
    return headerView
  }
  
}

// MARK: - 테이블뷰안의 컬렉션뷰 안의 셀을 선택한 후의 동작에 대한 델리게이트 구현
extension UserIconSelectVC: UserIconCollectionCellDelegate {
  func collectionView(collectioncell: UserIconCollectionViewCell?, imageURL: String, didTappedInTableview TableCell: UserIconTableCell) {
    
    //셀 선택 후 이미지 전달해야함
    if let cell = collectioncell, let tableCategory = TableCell.aCategory {
      
      let image = cell.mainImageView.image
      
      // 이미지 주소값 던져야함
      let imagePath = cell.cellImageName
      
      guard let navi = presentingViewController as? UINavigationController else { return }
      guard let profileChangeVC = navi.viewControllers.last as? ProfileChangeVC else { return }
      profileChangeVC.profileImagePath = imagePath
      profileChangeVC.userView.userImageView.image = image ?? UIImage(named: "profile1")
      dismiss(animated: true)
      
    }
  }
}
