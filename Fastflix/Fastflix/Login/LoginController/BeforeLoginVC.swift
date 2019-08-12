//
//  BeforeLoginVC.swift
//  Fastflix
//
//  Created by HongWeonpyo on 20/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - 로그인 하기전 스크롤 뷰 화면
final class BeforeLoginVC: UIViewController {
  
  // 서브유저(계정)관리 싱글톤
  private let subUserSingle = SubUserSingleton.shared
  
  // 스태터스바 설정 (글자 하얗게)
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - 속성 정의
  // 네이게이션뷰(네비게이션 커스텀하기 위해, 뷰를 네이게이션바처럼 보이게하기 위함)
  private lazy var navigationView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.addSubview(logoView)
    view.addSubview(customerCenterButton)
    return view
  }()
  
  // 로고 이미지뷰(패스트 플릭스)
  private let logoView: UIImageView = {
    let image = UIImage(named: "fastflix")
    let view = UIImageView()
    view.image = image
    view.contentMode = .scaleToFill
    return view
  }()
  
  // 고객센터 버튼
  private lazy var customerCenterButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("고객 센터", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(customerCenterTapped(_:)), for: .touchUpInside)
    return button
  }()
  
  // MARK: - 스크롤뷰에 관한 속성 정의
  // 스크롤뷰
  private let scrollView: UIScrollView = {
    let sv = UIScrollView()
    sv.backgroundColor = .black
    return sv
  }()
  
  // 영화포스터 모인 첫번째 백그라운드 이미지
  private let backgroundView: UIView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "netfilxbackground")
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  // 스크롤뷰 - 스크롤되는 첫번째 글자올려진 투명 뷰
  private let firstView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }()
  
  // 스크롤뷰 - 두번째 화면 (첫번째 그림 안내 화면)
  private let introView1: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "intro1")
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .black
    imageView.isUserInteractionEnabled = false
    return imageView
  }()
  
  // 스크롤뷰 - 세번째 화면 (두번째 그림 안내 화면)
  private let introView2: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "intro2")
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .black
    return imageView
  }()
  
  // 스크롤뷰 - 네번째 화면 (세번째 그림 안내 화면)
  private let introView3: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "intro3")
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .black
    return imageView
  }()
  
  // 첫화면 안내문구
  private let introlabel1: UILabel = {
    let label = UILabel()
    label.text = "찾아주셔서 감사합니다."
    label.font = UIFont.boldSystemFont(ofSize: 32)
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()
  
  private let introlabel2: UILabel = {
    let label = UILabel()
    label.text = """
    앱 내에서는 Netflix에 가입할 수
    없습니다. 번거로우시겠지만, 회원 가입
    완료 후 앱을 통해 TV 프로그램과 영화를
    시청하세요.
    """
    label.font = UIFont.systemFont(ofSize: 18)
    label.textAlignment = .center
    label.textColor = .white
    label.numberOfLines = 4
    return label
  }()
  
  // 하단 로그인 버튼
  private lazy var loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("로그인", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.textAlignment = .center
    button.backgroundColor = .red
    button.layer.cornerRadius = 3
    button.addTarget(self, action: #selector(loginButtonDidTap(_:)), for: .touchUpInside)
    return button
  }()
  
  // 페이지 컨트롤
  private lazy var pageControl:UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.numberOfPages = 4
    pageControl.tintColor = UIColor.gray
    pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    pageControl.currentPageIndicatorTintColor = UIColor.red
    return pageControl
  }()
  
  // MARK: - 시점 viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    downloadSubUserList()
    navigationBarSetting()
    scrollViewSetting()
    addSubViews()
  }
  
  // MARK: - 시점 viewDidAppear
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupSNP()
  }
  
  // MARK: - 서브유저리스트 다운받기
  func downloadSubUserList() {
    
    APICenter.shared.getSubUserList() {
      switch $0 {
      case .success(let subUsers):
        // 다운 받아서 싱글톤에 저장
        self.subUserSingle.subUserList = subUsers
        // 현재 유저디폴트에 저장된 서브유저아이디와 불러온 싱글톤에 같은 아이디를 갖고 있는 유저가 있다면 그 서브유저아이디를 사용, 없다면 첫번째 서브유저(싱글톤)의 첫번째 유저의 아이디를 유저디폴트에 저장해서 사용
        if self.subUserSingle.subUserList?.filter({ $0.id == APICenter.shared.getSubUserID() }) == nil {
          APICenter.shared.saveSubUserID(id: (self.subUserSingle.subUserList?[0].id)!)
        }
        
      case .failure(let err):
        dump(err)
      }
    }
  }
  
  // MARK: - 네비게이션바 설정
  private func navigationBarSetting() {
    let navCon = navigationController!
    navCon.isNavigationBarHidden = true
  }
  
  // MARK: - 스크롤뷰 설정
  private func scrollViewSetting() {
    scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * 4, height: self.scrollView.frame.size.height)
    scrollView.delegate = self
    scrollView.isPagingEnabled = true
  }
  
  private func addSubViews() {
    
    [scrollView, loginButton, navigationView, pageControl].forEach { view.addSubview($0) }
    //스크롤뷰 관련
    [backgroundView, firstView, introView1, introView2, introView3].forEach { scrollView.addSubview($0) }
    //첫 안내문구 레이블
    [introlabel1, introlabel2].forEach { firstView.addSubview($0) }
  }
  
  private func setupSNP() {
    
    scrollView.snp.makeConstraints {
      $0.top.equalTo(view.snp.top).offset(0)
      $0.leading.equalTo(view.snp.leading)
      $0.trailing.equalTo(view.snp.trailing)
      $0.bottom.equalTo(view.snp.bottom).offset(0)
    }
    
    loginButton.snp.makeConstraints {
      $0.height.equalTo(45)
      $0.leading.equalToSuperview().offset(5)
      $0.trailing.equalToSuperview().offset(-5)
      $0.bottom.equalToSuperview().offset(-20)
    }
    
    navigationView.snp.makeConstraints {
      $0.top.equalTo(view.snp.top)
      $0.leading.equalTo(view.snp.leading)
      $0.trailing.equalTo(view.snp.trailing)
      $0.height.equalTo(UIScreen.main.bounds.height * 0.11)
    }
    
    logoView.snp.makeConstraints {
      $0.bottom.equalTo(navigationView.snp.bottom).offset(8)
      $0.centerX.equalTo(navigationView.snp.centerX)
      $0.width.equalToSuperview().multipliedBy(0.25)
      $0.height.equalTo(logoView.snp.width).multipliedBy(0.70)
    }
    
    customerCenterButton.snp.makeConstraints {
      $0.centerY.equalTo(logoView.snp.centerY)
      $0.trailing.equalTo(view.snp.trailing).offset(-15)
    }
    
    pageControl.snp.makeConstraints {
      $0.bottom.equalTo(loginButton.snp.top).offset(-10)
      $0.centerX.equalTo(loginButton.snp.centerX)
      $0.width.equalTo(50)
      $0.height.equalTo(30)
    }
    
    backgroundView.snp.makeConstraints {
      $0.leading.equalTo(scrollView.snp.leading)
      $0.width.equalTo(scrollView.snp.width)
      $0.height.equalTo(scrollView.snp.height)
      $0.centerY.equalTo(scrollView.snp.centerY)
    }
    
    firstView.snp.makeConstraints {
      $0.leading.equalTo(scrollView.snp.leading)
      $0.width.equalTo(scrollView.snp.width)
      $0.height.equalTo(scrollView.snp.height)
      $0.centerY.equalTo(scrollView.snp.centerY).offset(-40)
    }
    
    introView1.snp.makeConstraints {
      $0.leading.equalTo(firstView.snp.trailing)
      $0.width.equalTo(scrollView.snp.width)
      $0.height.equalTo(scrollView.snp.height)
      $0.centerY.equalTo(scrollView.snp.centerY).offset(-40)
    }
    
    introView2.snp.makeConstraints {
      $0.leading.equalTo(introView1.snp.trailing)
      $0.width.equalTo(scrollView.snp.width)
      $0.height.equalTo(scrollView.snp.height)
      $0.centerY.equalTo(scrollView.snp.centerY).offset(-40)
    }
    
    introView3.snp.makeConstraints {
      $0.leading.equalTo(introView2.snp.trailing)
      $0.width.equalTo(scrollView.snp.width)
      $0.height.equalTo(scrollView.snp.height)
      $0.centerY.equalTo(scrollView.snp.centerY).offset(-40)
      $0.trailing.equalTo(scrollView.snp.trailing)
    }
    
    introlabel1.snp.makeConstraints {
      $0.centerX.equalTo(firstView.snp.centerX)
      $0.centerY.equalTo(scrollView.snp.centerY).offset(-40)
    }
    
    introlabel2.snp.makeConstraints {
      $0.top.equalTo(introlabel1.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
    }
  }
  
  // 로그인버튼 눌렀을때의 동작
  @objc private func loginButtonDidTap(_ sender: UIButton) {
    let loginVC = LoginVC()
    navigationController?.pushViewController(loginVC, animated: true)
  }
  
  // 고객센터 버튼 눌렀을때의 동작
  @objc private func customerCenterTapped(_ sender: UIButton) {
    let customerCenterVC = CustomerCenterVC()
    present(customerCenterVC, animated: true)
  }
  
}

// MARK: - 페이지 컨트롤러 위한 델리게이트 정의
extension BeforeLoginVC: UIScrollViewDelegate {
  
  // 페이지컨트롤러의 표시 위해 좌표 계산
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // contentOffset은 현재 스크롤된 좌표
    pageControl.currentPage = Int(floor(scrollView.contentOffset.x / UIScreen.main.bounds.width))
    print("스크롤뷰 contentoffset X 찍어보기:", scrollView.contentOffset.x)
  }
  
}
