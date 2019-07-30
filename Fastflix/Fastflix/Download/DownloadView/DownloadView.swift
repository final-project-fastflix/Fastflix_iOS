//
//  DownloadView.swift
//  Fastflix
//
//  Created by Jeon-heaji on 30/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//


import UIKit
import SnapKit

class DownloadView: UIView {
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    tableView.dataSource = self
    tableView.delegate = self
    return tableView
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSubViews()
    setupSNP()
    registerTableCell()
  }
  private func addSubViews() {
    [tableView]
      .forEach { self.addSubview($0) }
  }
  private func setupSNP() {
    tableView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func registerTableCell() {
    tableView.register(DownloadTableCell.self, forCellReuseIdentifier: DownloadTableCell.identifire)
  }
}
extension DownloadView: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: DownloadTableCell.identifire, for: indexPath) as! DownloadTableCell
    return cell
  }
  
}

extension DownloadView: UITableViewDelegate {
  
}
