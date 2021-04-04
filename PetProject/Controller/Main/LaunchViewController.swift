//
//  LaunchViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


class LaunchViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let loginRequest = LoginRequest()
    
    
    // MARK: View
    lazy var logoTextImageView: UIImageView = {
        let image = UIImage(named: "logo_text.png")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // 이거 설정 해줘야 nav가 투명할때 보이는 검정부분 안보임
        UINavigationBar.appearance().barTintColor = .white // 필수 (nav 배경색)
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        UINavigationBar.appearance().tintColor = .black
        // 탭바 색변경
        UITabBar.appearance().tintColor = .mainColor
        
        configureView()
        
        loginRequest.delegate = self
        
        let isLogined = app.isLogined()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            if isLogined {
                let user = self.app.getUser()

                guard let type = user.type else {
                    self.changeRootViewController(rootViewController: LoginViewController())
                    return
                }

                if type == "KAKAO" || type == "NAVER" || type == "APPLE" {
                    guard let socialId = user.socialId else {
                        self.changeRootViewController(rootViewController: LoginViewController())
                        return
                    }

                    self.loginRequest.fetch(vc: self, paramDict: ["type": type, "socialId": socialId])
                    return
                }

                guard let email = user.email else {
                    self.changeRootViewController(rootViewController: LoginViewController())
                    return
                }
                guard let password = user.password else {
                    self.changeRootViewController(rootViewController: LoginViewController())
                    return
                }

                self.loginRequest.fetch(vc: self, paramDict: ["type": type, "email": email, "password": password])

            } else {
                self.changeRootViewController(rootViewController: LoginViewController())
            }
        })
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(logoTextImageView)
        logoTextImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoTextImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoTextImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_XXXXXXXS).isActive = true
    }
}


// MARK: HTTP - Login
extension LaunchViewController: LoginRequestProtocol {
    func response(user: User?, login status: String) {
        print("[HTTP RES]", loginRequest.apiUrl, status)
        
        if status == "OK" {
            guard let user = user else { return }
            app.login(user: user)
            
            if user.status == "JOINING" {
                changeRootViewController(rootViewController: UINavigationController(rootViewController: JoinViewController()))
            } else {
                if user.petCnt > 0 {
                    changeRootViewController(rootViewController: UINavigationController(rootViewController: MainViewController()))
                } else {
                    changeRootViewController(rootViewController: UINavigationController(rootViewController: PetInfoViewController()))
                }
            }
        }
    }
}
