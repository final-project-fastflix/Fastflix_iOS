//
//  DataCenter.swift
//  Fastflix
//
//  Created by hyeoktae kwon on 2019/08/01.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import Foundation

class DataCenter {
  static let shared = DataCenter()

  let downloadPath = APICenter.shared

  var mainImageCellData: MainImgCellElement?

  var preViewCellData: PreviewData?

  var brandNewMovieData: BrandNewMovie?

  var forkData: ListOfFork?

  var top10Data: Top10?
  
  var goldenMovie: GoldenMovie?

  let group = DispatchGroup()
  
  let downloadQueue = DispatchQueue(label: "downloadQueue", attributes: .concurrent)



  func downloadDatas() {
    
      self.getMainImgCellData()
      self.getPreViewData()
      self.getBrandNewData()
      self.getForkData()
      self.getTop10Data()
      self.getGoldenMovieData()
    
  }
  
  private func getGoldenMovieData() {
    group.enter()
    downloadPath.getGoldenMovieData { (result) in
      switch result {
      case .success(let value):
        self.goldenMovie = value
        print("Queue getGoldenMovieData")
        self.group.leave()
      case .failure(let err):
        dump(err)
        self.mainImageCellData = nil
        self.group.leave()
      }
    }
  }

  private func getMainImgCellData() {
    group.enter()
    downloadPath.getMainImgCellData { (result) in
      switch result {
      case .success(let value):
        self.mainImageCellData = value
        print("Queue getMainImgCellData")
        self.group.leave()
      case .failure(let err):
        dump(err)
        print("Queue getMainImgCellData Fail", err)
        self.mainImageCellData = nil
        self.group.leave()
      }
    }
  }

  private func getPreViewData() {
    group.enter()
    downloadPath.getPreviewData { (result) in
      switch result {
      case .success(let value):
        self.preViewCellData = value
        print("Queue previewcelldata")
        self.group.leave()
      case .failure(let err):
        dump(err)
        self.preViewCellData = nil
        self.group.leave()
      }
    }
  }

  private func getBrandNewData() {
    group.enter()
    downloadPath.getBrandNewMovie { (result) in
      switch result {
      case .success(let value):
        self.brandNewMovieData = value
        print("Queue brandnewmovieData")
        self.group.leave()
      case .failure(let err):
        dump(err)
        self.brandNewMovieData = nil
        self.group.leave()
      }
    }
  }

  private func getForkData() {
    group.enter()
    downloadPath.getListOfFork { (result) in
      switch result {
      case .success(let value):
        self.forkData = value
        print("Queue forkData")
        self.group.leave()
      case .failure(let err):
        dump(err)
        self.forkData = nil
        self.group.leave()
      }
    }
  }

  private func getTop10Data() {
    group.enter()
    downloadPath.getTop10 { (result) in
      switch result {
      case .success(let value):
        self.top10Data = value
        print("Queue top10data")
        self.group.leave()
      case .failure(let err):
        dump(err)
        self.top10Data = nil
        self.group.leave()
      }
    }
  }
}
