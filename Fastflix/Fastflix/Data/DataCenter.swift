////
////  DataCenter.swift
////  Fastflix
////
////  Created by hyeoktae kwon on 2019/08/01.
////  Copyright © 2019 hyeoktae kwon. All rights reserved.
////
//
//import Foundation
//
//class DataCenter {
//  static let shared = DataCenter()
//
//  let downloadPath = APICenter.shared
//
//  var mainImageCellData: MainImgCellData?
//
//  var preViewCellData: PreviewData?
//
//  var brandNewMovieData: BrandNewMovie?
//
//  var forkData: ListOfFork?
//
//  var top10Data: Top10?
//
//  let group = DispatchGroup()
//  let downloadQueue = DispatchQueue(label: "downloadQueue", attributes: .concurrent)
//
//
//
//  func downloadDatas() {
//    downloadQueue.async(group: group) {
//      self.getMainImgCellData()
//      self.getMainImgCellData()
//      self.getPreViewData()
//      self.getBrandNewData()
//      self.getForkData()
//      self.getTop10Data()
//    }
//
//
//  }
//
//  private func getMainImgCellData() {
//    downloadPath.getMainImgCellData { (result) in
//      switch result {
//      case .success(let value):
//        self.mainImageCellData = value
//        print("getMainImgCellData")
//      case .failure(let err):
//        dump(err)
//        self.mainImageCellData = nil
//      }
//    }
//  }
//
//  private func getPreViewData() {
//    downloadPath.getPreviewData { (result) in
//      switch result {
//      case .success(let value):
//        self.preViewCellData = value
//        print("previewcelldata")
//      case .failure(let err):
//        dump(err)
//        self.preViewCellData = nil
//      }
//    }
//  }
//
//  private func getBrandNewData() {
//    downloadPath.getBrandNewMovie { (result) in
//      switch result {
//      case .success(let value):
//        self.brandNewMovieData = value
//        print("brandnewmovieData")
//      case .failure(let err):
//        dump(err)
//        self.brandNewMovieData = nil
//      }
//    }
//  }
//
//  private func getForkData() {
//    downloadPath.getListOfFork { (result) in
//      switch result {
//      case .success(let value):
//        self.forkData = value
//        print("forkData")
//      case .failure(let err):
//        dump(err)
//        self.forkData = nil
//      }
//    }
//  }
//
//  private func getTop10Data() {
//    downloadPath.getTop10 { (result) in
//      switch result {
//      case .success(let value):
//        self.top10Data = value
//        print("top10data")
//      case .failure(let err):
//        dump(err)
//        self.top10Data = nil
//      }
//    }
//  }
//}
