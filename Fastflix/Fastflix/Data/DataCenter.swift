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
  
  var followUpMovie: FollowUp?
  
  var recommendMovie: [Search]?
  
  var fastFlixOriginal: [MoviesByGenre]?

  var goodOstMovie: [MoviesByGenre]?
  
  var summerMovie: [MoviesByGenre]?
  
  var funnyMovie: [MoviesByGenre]?
  
  var englishStudyMovie: [MoviesByGenre]?
  
  var disneyMovie: [MoviesByGenre]?
  
  let group = DispatchGroup()
  
  let downloadQueue = DispatchQueue(label: "downloadQueue", attributes: .concurrent)

  func downloadDatas() {
    
      self.getMainImgCellData()
      self.getPreViewData()
      self.getBrandNewData()
      self.getForkData()
      self.getTop10Data()
      self.getGoldenMovieData()
      self.getFollowUpData()
      self.getRecommendData()
      self.getFastFlixOriginalData()
      self.getGoodOstData()
      self.getSummerData()
      self.getFunnyData()
      self.getEnglishData()
      self.getDisneyData()
  }
  
  private func getGoldenMovieData() {
    group.enter()
    downloadPath.getGoldenMovieData { (result) in
      switch result {
      case .success(let value):
        self.goldenMovie = value
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
        self.group.leave()
      case .failure(let err):
        dump(err)
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
        self.group.leave()
      case .failure(let err):
        dump(err)
        self.top10Data = nil
        self.group.leave()
      }
    }
  }
  
  private func getFollowUpData() {
    group.enter()
    downloadPath.getFollowUpList { (result) in
      switch result {
      case .success(let value):
        self.followUpMovie = value
        self.group.leave()
      case .failure(let err):
        dump(err)
        self.followUpMovie = nil
        self.group.leave()
      }
    }
  }
  
  private func getRecommendData() {
    group.enter()
    downloadPath.getRecommendMovieData { (result) in
      switch result {
      case .success(let value):
        self.recommendMovie = value
        self.group.leave()
      case .failure(let err):
        dump(err)
        self.recommendMovie = nil
        self.group.leave()
      }
    }
  }
  
  private func getFastFlixOriginalData() {
    group.enter()
    downloadPath.getListMovieGenreData(genre: "넷플릭스 오리지널") { (result) in
      switch result {
      case .success(let value):
        self.fastFlixOriginal = value
        self.group.leave()
      case .failure(let err):
        dump(err)
        self.fastFlixOriginal = nil
        self.group.leave()
      }
    }
  }
  
  private func getGoodOstData() {
    group.enter()
    downloadPath.getListMovieGenreData(genre: "ost가 좋은 영화") { (result) in
      switch result {
      case .success(let value):
        self.goodOstMovie = value
        self.group.leave()
      case .failure(let err):
        dump(err)
        self.goodOstMovie = nil
        self.group.leave()
      }
    }
  }
  
  private func getSummerData() {
    group.enter()
    downloadPath.getListMovieGenreData(genre: "여름과 관련된 영화") { (result) in
      switch result {
      case .success(let value):
        self.summerMovie = value
        self.group.leave()
      case .failure(let err):
        dump(err)
        self.summerMovie = nil
        self.group.leave()
      }
    }
  }
  
  private func getFunnyData() {
    group.enter()
    downloadPath.getListMovieGenreData(genre: "미치도록 웃긴영화") { (result) in
      switch result {
      case .success(let value):
        self.funnyMovie = value
        self.group.leave()
      case .failure(let err):
        dump(err)
        self.funnyMovie = nil
        self.group.leave()
      }
    }
  }
  
  private func getEnglishData() {
    group.enter()
    downloadPath.getListMovieGenreData(genre: "영어 공부하기 좋은 영화") { (result) in
      switch result {
      case .success(let value):
        self.englishStudyMovie = value
        self.group.leave()
      case .failure(let err):
        dump(err)
        self.englishStudyMovie = nil
        self.group.leave()
      }
    }
  }
  
  private func getDisneyData() {
    group.enter()
    downloadPath.getListMovieGenreData(genre: "디즈니 영화") { (result) in
      switch result {
      case .success(let value):
        self.disneyMovie = value
        self.group.leave()
      case .failure(let err):
        dump(err)
        self.disneyMovie = nil
        self.group.leave()
      }
    }
  }
  
  
  
  
  
  
}
