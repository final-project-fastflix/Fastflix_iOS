//
//  Network.swift
//  Fastflix
//
//  Created by hyeoktae kwon on 2019/07/10.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import Foundation
import Alamofire
import ImageIO


class APICenter {
  static let shared = APICenter()
  
  // MARK: 유저디폴트 객체
  private let path = UserDefaults.standard
  
  private var token: String {
    return getToken()
  }
  
  private var subUserID: Int {
    return getSubUserID()
  }
  
  // MARK: - 필요한 헤더를 가져옴
  private func getHeader(needSubuser: Bool) -> ([String: String]) {
    
    let withSubuser = [
      "Authorization": "Token \(token)",
      "subuserid": "\(subUserID)"
    ]
    
    let withOutSubuser = [
      "Authorization": "Token \(token)"
    ]
    
    switch needSubuser {
    case true:
      return withSubuser
    case false:
      return withOutSubuser
    }
  }
  
  
  func rekoMovie(image: UIImage, completion: @escaping (Result<RekoMovie>) -> ()) {
//    let header = getHeader(needSubuser: false)
    let header = [
      "Authorization": getToken()
    ]
    let url = RequestString.postRekoMovie.rawValue
    guard let convertImg = image.pngData() else {
      completion(.failure(ErrorType.NoData))
      return }
    let testData = Data(convertImg)
    let imgStr = String(data: convertImg, encoding: .ascii)
    let body = [
        "image": imgStr
      ]
    
    Alamofire.upload(multipartFormData: { (multi) in
//      multi.append(InputStream(data: convertImg), withLength: UInt64.init(1), headers: header)
      multi.append(convertImg, withName: "image")
    }, to: url, method: .post, headers: header) { (result) in
      switch result {
      case .success(request: let req, streamingFromDisk: _, streamFileURL: _):
        req.responseData(queue: .global()
          , completionHandler: { (data) in
            switch data.result {
            case .success(let value):
              guard let result = try? JSONDecoder().decode(RekoMovie.self, from: value) else {
                completion(.failure(ErrorType.FailToParsing))
                return }
              
              completion(.success(result))
            case .failure(let err):
              dump(err)
              completion(.failure(ErrorType.networkError))
            }
        })
        
        
      case .failure(let err):
        dump(err)
        completion(.failure(ErrorType.networkError))
      }
    }
    
//    Alamofire.upload(body!, to: url, method: .post, headers: header)
//      .responseData(queue: .main, completionHandler: { (result) in
//
//        switch result.result {
//        case .success(let value):
//          print("errorreko", value)
//          let test = try? JSONSerialization.jsonObject(with: value) as? [Any]
//          print("errorreko", test)
//          print("errorreko", result.response?.statusCode)
//
//          guard let data = try? JSONDecoder().decode(RekoMovie.self, from: value) else {
//            completion(.failure(ErrorType.FailToParsing))
//            return
//          }
//          completion(.success(data))
//
//        case .failure(let err):
//          dump(err)
//          completion(.failure(ErrorType.networkError))
//        }
//      })
    
    
  
//    let req1 = Alamofire.request(req!)
////    req.response
//      req1.responseData(queue: .main, completionHandler: { (result) in
//
//        switch result.result {
//        case .success(let value):
//          print("errorreko", value)
//          let test = try? JSONSerialization.jsonObject(with: value) as? [Any]
//          print("errorreko", test)
//          print("errorreko", result.response?.statusCode)
//
//          guard let data = try? JSONDecoder().decode(RekoMovie.self, from: value) else {
//            completion(.failure(ErrorType.FailToParsing))
//            return
//          }
//          completion(.success(data))
//
//        case .failure(let err):
//          dump(err)
//          completion(.failure(ErrorType.networkError))
//        }
//      })
    
    
//    Alamofire.upload(multipartFormData: { multi in
////      multi.append(convertImg, withName: "image", mimeType: "image/png")
//      multi.append(convertImg, withName: "image", fileName: "image", mimeType: "image/png")
//    }, to: url, method: .post, headers: header) { (result) in
//      switch result {
//      case .success(request: let req, streamingFromDisk: _, streamFileURL: _):
//        req.responseData(queue: .main, completionHandler: { (result) in
//
//          switch result.result {
//          case .success(let value):
//            print("errorreko", value)
//            let test = try? JSONSerialization.jsonObject(with: value) as? [Any]
//            print("errorreko", test)
//            guard let data = try? JSONDecoder().decode(RekoMovie.self, from: value) else {
//              completion(.failure(ErrorType.FailToParsing))
//              return
//            }
//            completion(.success(data))
//
//          case .failure(let err):
//            dump(err)
//            completion(.failure(ErrorType.networkError))
//          }
//        })
//
//      case .failure(let err):
//        dump(err)
//        completion(.failure(ErrorType.networkError))
//      }
//    }
  }
  
  // post pause movie time
  func postPauseTime(movieID: Int?, time: Int?, completion: @escaping (Result<Bool>) -> ()) {
    let header = [
      "Authorization": "Token \(getToken())",
      "Content-Type": "application/json"
    ]
    
    let url = RequestString.postPauseTimeMovieURL.rawValue
    
    let body = """
      {
      "sub_user_id": \(getSubUserID()),
      "movie_id": "\(movieID ?? 0)",
      "paused_time": \(time ?? 0)
      }
      """.data(using: .utf8)
    
    Alamofire.upload(body!, to: url, method: .post, headers: header)
      .responseJSON(queue: .global()) { (result) in
        switch result.result {
        case .success(let value):
          guard let dict = value as? [String: Bool], let result = dict["saved"] else {
            completion(.failure(ErrorType.FailToParsing))
            return
          }
          completion(.success(result))
        case .failure(let err):
          dump(err)
          completion(.failure(ErrorType.networkError))
        }
    }
  }
  
  
  func getDetailData(id: Int, completion: @escaping (Result<MovieDetail>) -> ()) {
    let header = getHeader(needSubuser: true)
    let fullURL = RequestString.getDetailURL.rawValue + "\(id)/"
    
    Alamofire.request(fullURL, method: .get, headers: header)
      .responseData(queue: .global()) { (result) in
        switch result.result {
        case .success(let value):
          guard let result = try? JSONDecoder().decode(MovieDetail.self, from: value) else {
            completion(.failure(ErrorType.FailToParsing))
            return
          }
          completion(.success(result))
        case .failure(let err):
          dump(err)
          completion(.failure(ErrorType.networkError))
        }
    }
    
  }
  
  
  // search Movie with key!
  func searchMovie(searchKey: String, completion: @escaping (Result<SearchMovie>) -> ()) {
    let header = getHeader(needSubuser: true)
    let url = RequestString.searchMovieURL.rawValue
    let param = [
      "search_key": searchKey
    ]
    
    Alamofire.request(url, method: .get, parameters: param, headers: header).responseData(queue: .global()) { (res) in
      switch res.result {
      case .success(let value):
        guard let result = try? JSONDecoder().decode(SearchMovie.self, from: value) else {
          completion(.failure(ErrorType.FailToParsing))
          return }
        
        completion(.success(result))
      case .failure(let err):
        dump(err)
        completion(.failure(ErrorType.networkError))
      }
    }
  }
  
  
  
  // get golden movie data
  func getGoldenMovieData(completion: @escaping (Result<GoldenMovie>) -> ()) {
    let header = getHeader(needSubuser: true)
    
    Alamofire.request(RequestString.getGoldenMovieURL.rawValue, method: .get, headers: header)
      .validate(statusCode: 200...299)
      .responseData(queue: .global()) { (res) in
        switch res.result {
        case .success(let value):
          guard let dict = try? JSONDecoder().decode(GoldenMovie.self, from: value) else {
            completion(.failure(ErrorType.FailToParsing))
            return
          }
          
          completion(.success(dict))
        case .failure(let err):
          dump(err)
          completion(.failure(ErrorType.networkError))
        }
    }
  }
  
  
  // 프로필 삭제
  func deleteProfileInfo(id: Int, completion: @escaping (Result<Int>) -> ()) {
    let header = [
      "Authorization": "Token \(token)",
      "subuserid": "\(id)"
    ]
    
    Alamofire.request(RequestString.deleteProfileInfoURL.rawValue, method: .delete, headers: header)
      .validate(statusCode: 200...299)
      .responseData(queue: .global()) { (res) in
        switch res.result {
        case .success(_):
          guard let data = res.data else {
            completion(.failure(ErrorType.NoData))
            return }
          guard let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Int] else {
            completion(.failure(ErrorType.FailToParsing))
            return
          }
          guard let result = dict["response"] else {
            completion(.failure(ErrorType.FailToParsing))
            return }
          completion(.success(result))
        case .failure(let err):
          dump(err)
          completion(.failure(ErrorType.networkError))
          
        }
    }
  }
  
  
  // 시청중인 목록 가져오기
  func getFollowUpList(completion: @escaping (Result<FollowUp>) -> ()) {
    let header = getHeader(needSubuser: true)
    
    Alamofire.request(RequestString.getFollowUpListURL.rawValue, method: .get, headers: header).responseData(queue: .global()) { (res) in
      switch res.result {
      case .success(let value):
        guard let result = try? JSONDecoder().decode(FollowUp.self, from: value) else {
          completion(.failure(ErrorType.FailToParsing))
          return }
        completion(.success(result))
      case .failure(let err):
        dump(err)
        completion(.failure(ErrorType.networkError))
      }
    }
  }
  
  
  // MARK: - Top10Element
  func getTop10(completion: @escaping (Result<Top10>) -> ()) {
    
    let header = getHeader(needSubuser: true)
    
    Alamofire.request(RequestString.getTop10URL.rawValue, method: .get, headers: header).responseData(queue: .global()) { (res) in
      switch res.result {
      case .success(let value):
        guard let result = try? JSONDecoder().decode(Top10.self, from: value) else {
          completion(.failure(ErrorType.FailToParsing))
          return }
        completion(.success(result))
      case .failure(let err):
        dump(err)
        completion(.failure(ErrorType.networkError))
      }
    }
  }
  
  // MARK: - ListOfForkElement
  func getListOfFork(completion: @escaping (Result<ListOfFork>) -> ()) {
    let header = getHeader(needSubuser: true)
    
    Alamofire.request(RequestString.getListOfForkURL.rawValue, method: .get, headers: header).responseData(queue: .global()) { (data) in
      switch data.result {
      case .success(let data):
        guard let result = try? JSONDecoder().decode(ListOfFork.self, from: data) else {
          completion(.failure(ErrorType.FailToParsing))
          return
        }
        
        completion(.success(result))
      case .failure(let err):
        dump(err)
        completion(.failure(ErrorType.networkError))
      }
    }
  }
  
  // 미리보기 Data
  func getPreviewData(completion: @escaping (Result<PreviewData>) -> ()) {
    let header = getHeader(needSubuser: true)
    
    Alamofire.request(RequestString.getPreviewDataURL.rawValue, method: .get, headers: header).responseData(queue: .global()) { (data) in
      switch data.result {
      case .success(let value):
        guard let result = try? JSONDecoder().decode(PreviewData.self, from: value) else {
          completion(.failure(ErrorType.FailToParsing))
          return
        }
        completion(.success(result))
        
      case .failure(let err):
        dump(err)
        completion(.failure(ErrorType.NoData))
      }
    }
  }
  
  // get recent Movies
  func getBrandNewMovie(completion: @escaping (Result<BrandNewMovie>) -> ()) {
    let header = getHeader(needSubuser: true)
    
    let req = Alamofire.request(RequestString.getBrandNewMovieURL.rawValue, method: .get, headers: header)
    
    req.responseJSON(queue: .global()) { (res) in
      switch res.result {
      case .success(_):
        guard let data = res.data else {
          completion(.failure(ErrorType.NoData))
          return }
        
        guard let result = try? JSONDecoder().decode(BrandNewMovie.self, from: data) else {
          completion(.failure(ErrorType.FailToParsing))
          return }
        
        completion(.success(result))
        
      case .failure(let err):
        dump(err)
        completion(.failure(ErrorType.networkError))
      }
    }
  }
  
  
  // when click Fork Btn. result -> 0 == no fork, 1 == fork
  func toggleForkMovie(movieID: Int, completion: @escaping (Result<Int>) -> ()) {
    let header = getHeader(needSubuser: false)
    let subUserID = getSubUserID()
    
    let parameters = [
      "movieid": "\(movieID)",
      "subuserid": "\(subUserID)"
    ]
    
    
    Alamofire.upload(multipartFormData: { (MultipartFormData) in
      for (key, value) in parameters {
        MultipartFormData.append(value.data(using: .utf8)!, withName: key)
      }
    }, to: RequestString.toggleForkMovieURL.rawValue, method: .post, headers: header) {
      switch $0 {
      case .success(let upload, _, _):
        upload.responseJSON { res in
          guard let data = res.data else {
            completion(.failure(ErrorType.NoData))
            return }
          
          guard let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Int] else {
            completion(.failure(ErrorType.FailToParsing))
            return }
          
          guard let state = result["marked"] else {
            completion(.failure(ErrorType.FailToParsing))
            return }
          
          completion(.success(state))
        }
      case .failure(let err):
        dump(err)
        completion(.failure(ErrorType.networkError))
      }
    }
  }
  
  // when click hate Btn. result -> 0 == no hate, 1 == hate
  func toggleHateMovie(movieID: Int, completion: @escaping (Result<Int>) -> ()) {
    let header = getHeader(needSubuser: false)
    let subUserID = getSubUserID()
    
    let parameters = [
      "movieid": "\(movieID)",
      "subuserid": "\(subUserID)"
    ]
    
    Alamofire.upload(multipartFormData: { (MultipartFormData) in
      for (key, value) in parameters {
        MultipartFormData.append(value.data(using: .utf8)!, withName: key)
      }
    }, to: RequestString.toggleHateMovieURL.rawValue, method: .post, headers: header) {
      switch $0 {
      case .success(let upload, _, _):
        upload.responseJSON { res in
          guard let data = res.data else {
            completion(.failure(ErrorType.NoData))
            return }
          
          guard let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Int] else {
            completion(.failure(ErrorType.FailToParsing))
            return }
          
          guard let state = result["response"] else {
            completion(.failure(ErrorType.FailToParsing))
            return }
          
          completion(.success(state))
        }
      case .failure(let err):
        dump(err)
        completion(.failure(ErrorType.networkError))
      }
    }
  }
  
  
  // when click hate Btn. result -> 0 == no hate, 1 == hate
  func toggleLikeMovie(movieID: Int, completion: @escaping (Result<Int>) -> ()) {
    let header = getHeader(needSubuser: false)
    let subUserID = getSubUserID()
    
    let parameters = [
      "movieid": "\(movieID)",
      "subuserid": "\(subUserID)"
    ]
    
    
    Alamofire.upload(multipartFormData: { (MultipartFormData) in
      for (key, value) in parameters {
        MultipartFormData.append(value.data(using: .utf8)!, withName: key)
      }
    }, to: RequestString.toggleLikeMovieURL.rawValue, method: .post, headers: header) {
      switch $0 {
      case .success(let upload, _, _):
        upload.responseJSON { res in
          guard let data = res.data else {
            completion(.failure(ErrorType.NoData))
            return }
          
          guard let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Int] else {
            completion(.failure(ErrorType.FailToParsing))
            return }
          
          guard let state = result["response"] else {
            completion(.failure(ErrorType.FailToParsing))
            return }
          
          completion(.success(state))
        }
      case .failure(let err):
        dump(err)
        completion(.failure(ErrorType.networkError))
      }
    }
  }
  
  
  
  // MARK: - 유저 이미지 변경을 위한 "전체 프로필사진들" 가져오기
  func changeProfileImage(completion: @escaping (Result<ProfileImage>) -> ()) {
    let header = getHeader(needSubuser: false)
    
    let req = Alamofire.request(RequestString.changeProfileImageURL.rawValue, method: .get, headers: header)
    
    req.response(queue: .global()) { (res) in
      guard res.error == nil else {
        completion(.failure(ErrorType.networkError))
        return }
      
      guard let data = res.data else {
        completion(.failure(ErrorType.NoData))
        return
      }
      
      guard let result = try? JSONDecoder().decode(ProfileImage.self, from: data) else {
        completion(.failure(ErrorType.FailToParsing))
        return
      }
      
      completion(.success(result))
    }
  }
  
  // MARK: 유저디폴트에 저장된 토큰값 가져오기
  private func getToken() -> String {
    guard let token = path.string(forKey: "token") else {
      print("ERROR!!!, No Token")
      //      AppDelegate.instance.checkLoginState()
      return ""}
    return token
  }
  
  // getMainImgCellData
  func getMainImgCellData(completion: @escaping (Result<MainImgCellElement>) -> ()) {
    let header = getHeader(needSubuser: true)
    
    let req = Alamofire.request(RequestString.getMainImgURL.rawValue, method: .get, headers: header)
    
    req.response(queue: .global()) { (res) in
      guard res.error == nil else {
        completion(.failure(ErrorType.networkError))
        return
      }
      guard let data = res.data else {
        completion(.failure(ErrorType.NoData))
        return
      }
      guard let result = try? JSONDecoder().decode(MainImgCellElement.self, from: data) else {
        completion(.failure(ErrorType.FailToParsing))
        return
      }
      completion(.success(result))
    }
  }
  
  // MARK: (토큰값 및 서브유저아이디로)영화 데이터 받기
  func getMovieData(completion: @escaping (Result<RequestMovie>) -> ()) {
    //    RequestMovie.self
    let headers = getHeader(needSubuser: true)
    
    let request = Alamofire.request(RequestString.movieURL.rawValue, method: .get, headers: headers)
    
    request.response(queue: .global()) {
      guard let data = $0.data else {
        completion(.failure(ErrorType.NoData))
        return }
      guard let resultData = try? JSONDecoder().decode(RequestMovie.self, from: data) else {
        completion(.failure(ErrorType.FailToParsing))
        return }
      completion(.success(resultData))
    }
  }
  
  
  // MARK: 로그인 메서드 -> 토큰값 저장 및 컴플리션에 서브유저 배열 넘기기
  func login(id: String, pw: String, completion: @escaping (Result<[SubUser]>) -> ()) {
    
    let parameters =
      [
        "id": id,
        "pw": pw
    ]
    
    Alamofire.upload(multipartFormData: {
      MultipartFormData in
      for (key, value) in parameters {
        MultipartFormData.append(value.data(using: .utf8)!, withName: key)
      }
      
    }, to: RequestString.loginURL.rawValue, method: .post) {
      switch $0 {
      case .success(let upload, _, _):
        upload.responseJSON { (res) in
          guard let data = res.data else {
            completion(.failure(ErrorType.NoData))
            return }
          guard let origin = try? JSONDecoder().decode(Login.self, from: data) else {
            completion(.failure(ErrorType.NoData))
            return }
          let token = origin.token
          let subUserArr = origin.subUserList.sorted(by: { $0.id < $1.id })
          
          // 토큰값 유저디폴트에 저장하기
          self.saveToken(token: token)
          
          completion(.success(subUserArr))
        }
      case .failure(let err):
        dump(err)
        completion(.failure(ErrorType.NoData))
      }
    }
  }
  
  
  
  // MARK: 유저디폴트에 키값"token"로 토큰값 저장하기
  private func saveToken(token: String) {
    path.set(token, forKey: "token")
  }
  
  
  // MARK: 서브 유저 관련 메서드
  // MARK: 유저디폴트에 Int값으로된 서브유저 아이디 가져오기
  func getSubUserID() -> Int {
    return path.integer(forKey: "subUserID")
  }
  
  // MARK: 유저디폴트에 Int값으로 서브유저 아이디 저장하기
  func saveSubUserID(id: Int) {
    path.set(id, forKey: "subUserID")
  }
  
  // MARK: 유저디폴트에 현재 저장된 서브유저 아이디 지우기
  func deleteCurrentSubUserID() {
    path.removeObject(forKey: "subUserID")
  }
  
  
  // MARK: 서브유저 생성
  func createSubUser(name: String, kid: Bool, completion: @escaping (Result<[SubUser]>) -> ()) {
    
    let headers = getHeader(needSubuser: false)
    
    let parameters =
      [
        "name": "\(name)",
        "kid": "\(kid)"
    ]
    
    Alamofire.request(RequestString.createSubUserURL.rawValue, method: .post, parameters: parameters, headers: headers)
      .validate()
      .responseJSON { response in
        guard response.result.isSuccess,
          let _ = response.result.value else {
            completion(.failure(ErrorType.networkError))
            return
        }
        guard let data = response.data else {
          completion(.failure(ErrorType.NoData))
          return
        }
        guard let origin = try? JSONDecoder().decode(SubUserList.self, from:data) else {
          completion(.failure(ErrorType.FailToParsing))
          return
        }
        let subUserArr = origin.subUserList.sorted(by: { $0.id < $1.id })
        
        //서브유저 정보들 넘기기
        completion(.success(subUserArr))
    }
  }
  
  // 토큰값으로 바로 로그인시에 서브유저리스트 받아오기
  func getSubUserList(completion: @escaping (Result<[SubUser]>) -> ()) {
    
    let headers = getHeader(needSubuser: false)
    
    Alamofire.request(RequestString.requestSubUserListURL.rawValue, method: .get, headers: headers)
      .validate()
      .responseJSON { response in
        guard response.result.isSuccess,
          let _ = response.result.value else {
            completion(.failure(ErrorType.networkError))
            return
        }
        guard let data = response.data else {
          completion(.failure(ErrorType.NoData))
          return
        }
        guard let origin = try? JSONDecoder().decode([SubUser].self, from:data) else {
          completion(.failure(ErrorType.FailToParsing))
          return
        }
        // 서브유저 리스트를 받되, 정렬해서 넘김 --> 유저 이름 바꾸는 경우 정렬 순서가 바뀌기도 하기때문에
        let subUserArr = origin.sorted(by: { $0.id < $1.id })
        
        //서브유저 정보들 넘기기
        completion(.success(subUserArr))
    }
  }
  
  func changeProfileInfo(id: Int, name: String?, kid: Bool?, imgPath: String?, completion: @escaping (Result<Int>) -> ()) {
    let header = [
      "Authorization": "Token \(getToken())",
      "Content-Type": "application/json"
    ]
    
    let body = pickupBody(id: id, name: name, kid: kid, imgPath: imgPath)
    
    Alamofire.upload(body, to: RequestString.changeProfileInfoURL.rawValue, method: .patch, headers: header).responseJSON(queue: .global()) { (res) in
      switch res.result {
      case .success(let value):
        let dict = value as? [String: Int]
        guard let result = dict?["response"] else {
          completion(.failure(ErrorType.FailToParsing))
          return }
        completion(.success(result))
      case .failure(let err):
        dump(err)
        completion(.failure(ErrorType.networkError))
      }
    }
    
    
    
  }
  
  // profile 변경시 필요한 body 고르기
  func pickupBody(id: Int, name: String?, kid: Bool?, imgPath: String?) -> Data {
    
    if name != nil && kid != nil && imgPath != nil {
      let body = """
        {
        "sub_user_id": \(id),
        "name": "\(name!)",
        "kid": \(kid!),
        "profile_image_path": "\(imgPath!)"
        }
        """.data(using: .utf8)
      return body!
    } else if name != nil && kid != nil && imgPath == nil {
      let body = """
        {
        "sub_user_id": \(id),
        "name": "\(name!)",
        "kid": \(kid!)
        }
        """.data(using: .utf8)
      return body!
    } else if name != nil && kid == nil && imgPath != nil {
      let body = """
        {
        "sub_user_id": \(id),
        "name": "\(name!)",
        "profile_image_path": "\(imgPath!)"
        }
        """.data(using: .utf8)
      return body!
    } else if name != nil && kid == nil && imgPath == nil {
      let body = """
        {
        "sub_user_id": \(id),
        "name": "\(name!)"
        }
        """.data(using: .utf8)
      return body!
    } else if name == nil && kid != nil && imgPath != nil {
      let body = """
        {
        "sub_user_id": \(id),
        "kid": \(kid!),
        "profile_image_path": "\(imgPath!)"
        }
        """.data(using: .utf8)
      return body!
    } else if name == nil && kid != nil && imgPath == nil {
      let body = """
        {
        "sub_user_id": \(id),
        "kid": \(kid!)
        }
        """.data(using: .utf8)
      return body!
    } else if name == nil && kid == nil && imgPath != nil {
      let body = """
        {
        "sub_user_id": \(id)
        "profile_image_path": "\(imgPath!)"
        }
        """.data(using: .utf8)
      return body!
    } else {
      let body = """
        {
        "sub_user_id": \(id)
        }
        """.data(using: .utf8)
      return body!
    }
  }
  
  // 장르를 선택하면 보여줄 영화리스트
  func getListByGenreData(genre: String, completion: @escaping (Result<RequestListByGenre>) -> ()) {
    let header = getHeader(needSubuser: true)
    let fullURL = RequestString.getListByGenre.rawValue + "\(genre)/"
    
    let encoding = fullURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    
    let apiURL = URL(string: encoding)!
    
    Alamofire.request(apiURL, method: .get, headers: header)
      .responseData(queue: .global()) { (result) in
        switch result.result {
        case .success(let value):
          guard let result = try? JSONDecoder().decode(RequestListByGenre.self, from: value) else {
            completion(.failure(ErrorType.FailToParsing))
            return
          }
          completion(.success(result))
        case .failure(let err):
          dump(err)
          completion(.failure(ErrorType.networkError))
        }
    }
  }
  
  // 추천영화 가져오기
  func getRecommendMovieData(completion: @escaping (Result<[Search]>) -> ()) {
    let header = getHeader(needSubuser: true)
    
    Alamofire.request(RequestString.getRecommendMovieURL.rawValue, method: .get, headers: header)
      .validate(statusCode: 200...299)
      .responseData(queue: .global()) { (res) in
        switch res.result {
        case .success(let value):
          guard let dict = try? JSONDecoder().decode([Search].self, from: value) else {
            completion(.failure(ErrorType.FailToParsing))
            return
          }
          
          completion(.success(dict))
        case .failure(let err):
          dump(err)
          completion(.failure(ErrorType.networkError))
        }
    }
  }
  
  // 넷플릭스 오리지널 등 우리만의 영화리스트
  func getListMovieGenreData(genre: String, completion: @escaping (Result<[MoviesByGenre]>) -> ()) {
    let header = getHeader(needSubuser: true)
    let fullURL = RequestString.getListByFastFlixMovieURL.rawValue + "\(genre)/list/"
//    print("유알엘 찍어보기:", fullURL)
    
    let encoding = fullURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    
    let apiURL = URL(string: encoding)!
    
    Alamofire.request(apiURL, method: .get, headers: header)
      .responseData(queue: .global()) { (result) in
        switch result.result {
        case .success(let value):
          guard let result = try? JSONDecoder().decode([MoviesByGenre].self, from: value) else {
            completion(.failure(ErrorType.FailToParsing))
            return
          }
          completion(.success(result))
        case .failure(let err):
          dump(err)
          completion(.failure(ErrorType.networkError))
        }
    }
  }
  
}
