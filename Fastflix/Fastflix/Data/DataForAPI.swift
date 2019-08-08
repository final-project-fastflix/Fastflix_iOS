//
//  DataForAPI.swift
//  Fastflix
//
//  Created by hyeoktae kwon on 2019/07/19.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import Foundation

// MARK: - URLString
enum RequestString: String {
  case loginURL = "http://www.api.fastflix.co.kr/accounts/login/"
  case movieURL = "http://www.api.fastflix.co.kr/movies/genre_select_before/"
  case requestSubUserListURL = "http://www.api.fastflix.co.kr/accounts/sub_user_list/"
  case createSubUserURL = "http://www.api.fastflix.co.kr/accounts/create_sub_user/"
  case changeProfileImageURL = "http://www.api.fastflix.co.kr//accounts/change_profile/"
  case getMainImgURL = "http://www.api.fastflix.co.kr//movies/"
  case toggleForkMovieURL = "http://www.api.fastflix.co.kr/movies/add_delete_my_list/"
  case getBrandNewMovieURL = "http://www.api.fastflix.co.kr/movies/brand_new/"
  case toggleHateMovieURL = "http://www.api.fastflix.co.kr/movies/dislike/"
  case toggleLikeMovieURL = "http://www.api.fastflix.co.kr//movies/like/"
  case getPreviewDataURL = "http://www.api.fastflix.co.kr/movies/preview/"
  case getListOfForkURL = "http://www.api.fastflix.co.kr/movies/my_list/"
  case getTop10URL = "http://www.api.fastflix.co.kr/movies/most_likes/"
  case postPauseTimeMovieURL = "http://www.api.fastflix.co.kr/movies/paused_time/"
  case getFollowUpListURL = "http://www.api.fastflix.co.kr/movies/followup/"
  case changeProfileInfoURL = "http://www.api.fastflix.co.kr/accounts/change_sub_user/"
  case deleteProfileInfoURL = "http://www.api.fastflix.co.kr/accounts/delete_sub_user/"
  case getGoldenMovieURL = "http://www.api.fastflix.co.kr/movies/big_size_video/"
  case searchMovieURL = "http://www.api.fastflix.co.kr/movies/search/?search_key="
  case getDetailURL = "http://www.api.fastflix.co.kr/movies/"
  case getMovieGenre = "http://www.api.fastflix.co.kr/movies/genre/list/"
  case getListByGenre = "http://www.api.fastflix.co.kr/movies/list_by_genre/"
  case postRekoMovie = "http://www.api.fastflix.co.kr/face_reko/"
}


// MARK: - MovieDetail
struct MovieDetail: Codable {
  let id: Int
  let name: String
  let videoFile, sampleVideoFile, verticalSampleVideoFile: String
  let productionDate, uploadedDate, synopsis, runningTime: String
  let realRunningTime: Int
  let logoImagePath: String
  let horizontalImagePath: String
  let verticalImage: String
  let originalVerticalImagePath, circleImage: String
  let bigImagePath: String
  let iosMainImage: String
  let degree: Degree
  let directors, actors, feature, author: [Actor]
  let genre: [Actor]
  let matchRate: Int
  let progressBar: Float
  let marked: Bool
  let like, totalMinute, toBeContinue, pausedMinute: Int
  let canIStore: Bool
  let similarMovies: [SimilarMovie]
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case videoFile = "video_file"
    case sampleVideoFile = "sample_video_file"
    case verticalSampleVideoFile = "vertical_sample_video_file"
    case productionDate = "production_date"
    case uploadedDate = "uploaded_date"
    case synopsis
    case runningTime = "running_time"
    case realRunningTime = "real_running_time"
    case logoImagePath = "logo_image_path"
    case horizontalImagePath = "horizontal_image_path"
    case verticalImage = "vertical_image"
    case originalVerticalImagePath = "original_vertical_image_path"
    case circleImage = "circle_image"
    case bigImagePath = "big_image_path"
    case iosMainImage = "ios_main_image"
    case degree, directors, actors, feature, author, genre, marked, like
    case matchRate = "match_rate"
    case progressBar = "progress_bar"
    case pausedMinute = "paused_minute"
    case totalMinute = "total_minute"
    case toBeContinue = "to_be_continue"
    case canIStore = "can_i_store"
    case similarMovies = "similar_movies"
  }
}


// MARK: - SimilarMovie
struct SimilarMovie: Codable {
  let id: Int
  let name: String
  let degree: Degree
  let synopsis: String
  let horizontalImagePath: String
  let verticalImage: String
  let productionDate, runningTime: String
  let matchRate: Int
  
  enum CodingKeys: String, CodingKey {
    case id, name, degree, synopsis
    case horizontalImagePath = "horizontal_image_path"
    case verticalImage = "vertical_image"
    case productionDate = "production_date"
    case runningTime = "running_time"
    case matchRate = "match_rate"
  }
}


// MARK: - SearchMovie
struct SearchMovie: Codable {
  let contents: [String]
  let firstMovie, otherMovie: [Search]
  
  enum CodingKeys: String, CodingKey {
    case contents
    case firstMovie = "first_movie"
    case otherMovie = "other_movie"
  }
}

// MARK: - RekoMovie
struct RekoMovie: Codable {
  let response: Response
}

// MARK: - Response
struct Response: Codable {
  let id: Int
  let name: String
  let horizontalImagePath: String
  let verticalImage: String
  let iosMainImage: String
  let sampleVideoFile: String
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case horizontalImagePath = "horizontal_image_path"
    case verticalImage = "vertical_image"
    case iosMainImage = "ios_main_image"
    case sampleVideoFile = "sample_video_file"
  }
}

// MARK: - Movie
struct Search: Codable {
  let id: Int
  let name: String
  let horizontalImagePath: String
  let verticalImage: String?
  let iosMainImage: String?
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case horizontalImagePath = "horizontal_image_path"
    case verticalImage = "vertical_image"
    case iosMainImage = "ios_main_image"
  }
}



// MARK: - GoldenMovie
struct GoldenMovie: Codable {
  let id: Int
  let name: String
  let videoFile: String
  let horizontalImagePath: String
  let logoImagePath: String
  let synopsis: String
  let bigImagePath: String
  let degree: Degree
  let marked: Bool
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case videoFile = "video_file"
    case horizontalImagePath = "horizontal_image_path"
    case logoImagePath = "logo_image_path"
    case synopsis
    case bigImagePath = "big_image_path"
    case degree, marked
  }
}


// MARK: - FollowUpElement
struct FollowUpElement: Codable {
  let movie: Movie
  let toBeContinue, progressBar, totalMinute: Int
  
  enum CodingKeys: String, CodingKey {
    case movie
    case toBeContinue = "to_be_continue"
    case progressBar = "progress_bar"
    case totalMinute = "total_minute"
  }
}

// MARK: - Movie
struct Movie: Codable {
  let id: Int
  let name: String
  let videoFile: String?
  let logoImagePath: String
  let horizontalImagePath: String
  let verticalImage: String
  let realRunningTime: Int
  let toBeContinue: Int?
  let progressBar: Int?
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case videoFile = "video_file"
    case logoImagePath = "logo_image_path"
    case horizontalImagePath = "horizontal_image_path"
    case verticalImage = "vertical_image"
    case realRunningTime = "real_running_time"
    case toBeContinue = "to_be_continue"
    case progressBar = "progress_bar"
  }
}

typealias FollowUp = [FollowUpElement]


// MARK: - Top10Element
struct Top10Element: Codable {
  let id: Int
  let name: String
  let sampleVideoFile: String?
  let logoImagePath: String
  let horizontalImagePath: String
  let verticalImage: String
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case sampleVideoFile = "sample_video_file"
    case logoImagePath = "logo_image_path"
    case horizontalImagePath = "horizontal_image_path"
    case verticalImage = "vertical_image"
  }
}

typealias Top10 = [Top10Element]

// MARK: - ListOfForkElement
struct ListOfForkElement: Codable {
  let id: Int
  let name: String
  let horizontalImagePath: String
  let verticalImage: String
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case horizontalImagePath = "horizontal_image_path"
    case verticalImage = "vertical_image"
  }
}

typealias ListOfFork = [ListOfForkElement]

// MARK: - PreviewDatum
struct PreviewDatas: Codable {
  let id: Int
  let name: String
  let circleImage: String
  let logoImagePath: String
  let videoFile: String?
  let verticalSampleVideoFile: String?
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case circleImage = "circle_image"
    case logoImagePath = "logo_image_path"
    case videoFile = "video_file"
    case verticalSampleVideoFile = "vertical_sample_video_file"
  }
}

typealias PreviewData = [PreviewDatas]

// MARK: - BrandNewMovieElement
struct BrandNewMovieElement: Codable {
  let id: Int
  let name: String
  let sampleVideoFile: String?
  let logoImagePath: String
  let horizontalImagePath: String
  let verticalImage: String
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case sampleVideoFile = "sample_video_file"
    case logoImagePath = "logo_image_path"
    case horizontalImagePath = "horizontal_image_path"
    case verticalImage = "vertical_image"
  }
}

typealias BrandNewMovie = [BrandNewMovieElement]




// MARK: - ProfileImageElement
struct ProfileImageElement: Codable {
  let name: String?
  let imagePath: String
  
  enum CodingKeys: String, CodingKey {
    case name
    case imagePath = "image_path"
  }
}

typealias ProfileImage = [String: [ProfileImageElement]]




// MARK: - Login
struct Login: Codable {
  let token: String
  let subUserList: [SubUser]
  
  enum CodingKeys: String, CodingKey {
    case token
    case subUserList = "sub_user_list"
  }
}

struct SubUserList: Codable {
  let subUserList: [SubUser]
  
  enum CodingKeys: String, CodingKey {
    case subUserList = "sub_user_list"
  }
}

// MARK: - SubUserList
struct SubUser: Codable {
  let id: Int
  let profileInfo: ProfileInfo
  let name: String
  let kid: Bool
  let parentUser: Int
  
  enum CodingKeys: String, CodingKey {
    case id
    case profileInfo = "profile_info"
    case name, kid
    case parentUser = "parent_user"
  }
}

struct ProfileInfo: Codable {
  let imageID: Int
  let profileImagePath: String
  
  enum CodingKeys: String, CodingKey {
    case imageID = "image_id"
    case profileImagePath = "profile_image_path"
  }
}

// MARK: - RequestMovieElement
struct RequestMovieElement: Codable {
  let mainMovie: MainMovie
  let listOfGenre: [String]
  let moviesByGenre: [String: [MoviesByGenre]]
  
  enum CodingKeys: String, CodingKey {
    case mainMovie = "메인 영화"
    case listOfGenre = "장르리스트"
    case moviesByGenre = "장르별 영화리스트"
  }
}

//typealias MainImgCellData = [MainImgCellElement]

// MARK: - MainCellElement
struct MainImgCellElement: Codable { 
  let mainMovie: MainMovie?
  
  enum CodingKeys: String, CodingKey {
    case mainMovie = "메인 영화"
  }
}

struct MainMovie: Codable {
  let id: Int?
  let name: String?
  let videoFile: String?
  let sampleVideoFile, verticalSampleVideoFile: String?
  let productionDate, uploadedDate, synopsis, runningTime: String?
  let realRunningTime, viewCount, likeCount: Int?
  let logoImagePath: String?
  let horizontalImagePath: String?
  let verticalImage: String?
  let circleImage, bigImagePath: String?
  let iosMainImage: String?
  let created: String?
  let degree: Degree?
  let directors, actors, feature, author: [Actor]?
  let genre: [Actor]?
  let marked: Bool?
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case videoFile = "video_file"
    case sampleVideoFile = "sample_video_file"
    case verticalSampleVideoFile = "vertical_sample_video_file"
    case productionDate = "production_date"
    case uploadedDate = "uploaded_date"
    case synopsis
    case runningTime = "running_time"
    case realRunningTime = "real_running_time"
    case viewCount = "view_count"
    case likeCount = "like_count"
    case logoImagePath = "logo_image_path"
    case horizontalImagePath = "horizontal_image_path"
    case verticalImage = "vertical_image"
    case circleImage = "circle_image"
    case bigImagePath = "big_image_path"
    case iosMainImage = "ios_main_image"
    case created, degree, directors, actors, feature, author, genre, marked
  }
}

// MARK: - Actor
struct Actor: Codable {
  let id: Int
  let name: String
}

// MARK: - Degree
struct Degree: Codable {
  let id: Int
  let name: String
  let degreeImagePath: String
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case degreeImagePath = "degree_image_path"
  }
}

// MARK: - 장르별영화리스트
struct MoviesByGenre: Codable {
  let id: Int
  let name: String
  let sampleVideoFile: String?
  let logoImagePath: String?
  let horizontalImagePath: String
  let verticalImage: String
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case sampleVideoFile = "sample_video_file"
    case logoImagePath = "logo_image_path"
    case horizontalImagePath = "horizontal_image_path"
    case verticalImage = "vertical_image"
  }
}

typealias RequestMovie = [RequestMovieElement]


//struct ListMovieElement: Codable {
//  let id: Int
//  let name: String
//  let sampleVideoFile: String
//  let logoImagePath: String
//  let horizontalImagePath: String
//  let verticalImage: String
//
//  enum CodingKeys: String, CodingKey {
//    case id, name
//    case sampleVideoFile
//    case logoImagePath
//    case horizontalImagePath
//    case verticalImage
//  }
//}

typealias RequestListByGenre = [String: [MoviesByGenre]]
