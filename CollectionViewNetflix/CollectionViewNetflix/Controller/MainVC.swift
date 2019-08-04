//
//  MainVC.swift
//  CollectionViewNetflix
//
//  Created by hyeoktae kwon on 2019/07/10.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
  
  private let tableView: UITableView = {
    let tbl = UITableView()
    tbl.backgroundColor = .darkGray
    tbl.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
    tbl.rowHeight = UIScreen.main.bounds.height / 3.5
    tbl.separatorStyle = .none
    return tbl
  }()
  
  override func loadView() {
    self.view = tableView
    tableView.dataSource = self
    
    
  }
  
}

extension MainVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
    
    return cell
  }
  
  
}
