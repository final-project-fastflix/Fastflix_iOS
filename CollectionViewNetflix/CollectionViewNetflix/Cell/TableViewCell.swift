//
//  CollectionVC.swift
//  CollectionViewNetflix
//
//  Created by hyeoktae kwon on 2019/07/09.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
  
  static let identifier = "TableViewCell"
  
  private let tableViewInside: UITableView = {
    let tbl = UITableView()
    tbl.backgroundColor = .darkGray
    tbl.separatorStyle = .none
    tbl.register(HeaderView.self, forCellReuseIdentifier: HeaderView.identifier)
    tbl.register(CollectionCell.self, forCellReuseIdentifier: CollectionCell.identifier)
    return tbl
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    print("before datasource")
    tableViewInside.dataSource = self
    tableViewInside.delegate = self
    print("after datasource")
    setupAutoLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func setupAutoLayout() {
    [tableViewInside].forEach { addSubview($0) }
    tableViewInside.snp.makeConstraints {
      $0.leading.trailing.top.bottom.equalToSuperview()
    }
  }
  
  
}

extension TableViewCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("in numberofinsec")
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print("run")
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
      cell.backgroundColor = .clear
      
      cell.configure(title: "Test")
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
      cell.backgroundColor = .clear
      cell.configure(url: imageUrls)
      return cell
    }
  }
  
  
}

extension TableViewCell: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 50
    } else {
      return 200
    }
  }
}
