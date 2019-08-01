//
//  Network.swift
//  Fastflix
//
//  Created by hyeoktae kwon on 2019/07/10.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import Foundation
import Alamofire


final class APICenter {
  static let shared = APICenter()
  
  let group = DispatchGroup()
  let downloadQueue = DispatchQueue(label: "downloadQueue", attributes: .concurrent)
  
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
      case .failure(_):
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
      case .failure(_):
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
        print("Error: ", err)
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
        print("result: ", err)
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
        print("result: ", err)
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
        print("result: ", err)
        completion(.failure(ErrorType.networkError))
      }
    }
  }
  
  
  
  // MARK: - 프로필사진들 가져오기
  func changeProfileImage(completion: @escaping (Result<ProfileImage>) -> ()) {
    let header = getHeader(needSubuser: false)
    
    let req = Alamofire.request(RequestString.changeProfileListURL.rawValue, method: .get, headers: header)
    
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
      AppDelegate.instance.checkLoginState()
      return ""}
    return token
  }
  
  func getMainImgCellData(completion: @escaping (Result<MainImgCellData>) -> ()) {
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
      
      guard let result = try? JSONDecoder().decode(MainImgCellData.self, from: data) else {
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
        //        print("data: ", data as? [String])
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
          //          print("run", res.data as? [String: String])
          guard let data = res.data else {
            completion(.failure(ErrorType.NoData))
            return }
          guard let origin = try? JSONDecoder().decode(Login.self, from: data) else {
            completion(.failure(ErrorType.NoData))
            return }
          let token = origin.token
          let subUserArr = origin.subUserList.sorted(by: { $0.id < $1.id })
          print("subUser: ", subUserArr)
          
          // 토큰값 유저디폴트에 저장하기
          self.saveToken(token: token)
          
          completion(.success(subUserArr))
        }
      case .failure(let err):
        print(err)
        completion(.failure(ErrorType.NoData))
        break
      }
    }
  }
  
  
  
  // MARK: 유저디폴트에 키값"token"로 토큰값 저장하기
  private func saveToken(token: String) {
    path.set(token, forKey: "token")
    print("'Token' save complete ")
  }
  
  
  // MARK: 서브 유저 관련 메서드
  // MARK: 유저디폴트에 Int값으로된 서브유저 아이디 가져오기
  func getSubUserID() -> Int {
    print("subUserID: ", path.integer(forKey: "subUserID"))
    return path.integer(forKey: "subUserID")
  }
  
  // MARK: 유저디폴트에 Int값으로 서브유저 아이디 저장하기
  func saveSubUserID(id: Int) {
    path.set(id, forKey: "subUserID")
    print("'subUserID' save complete ")
  }
  
  // MARK: 유저디폴트에 현재 저장된 서브유저 아이디 지우기
  func deleteCurrentSubUserID() {
    path.removeObject(forKey: "subUserID")
    print("'subUserID' is deleted")
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
            print("Error while fetching tags: \(String(describing: response.result.error))")
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
        print("유저생성 subUser: ", subUserArr)
        
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
            print("Error while fetching tags: \(String(describing: response.result.error))")
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
        print("유저생성 subUser: ", subUserArr)
        
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
      case .failure(_):
        completion(.failure(ErrorType.networkError))
      }
    }
    
    
    
  }
  
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
  
}
