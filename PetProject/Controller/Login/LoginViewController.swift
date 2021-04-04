//
//  LoginViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser


class LoginViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let loginRequest = LoginRequest()
    
    
    // MARK: View
    lazy var titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var titleImageView: UIImageView = {
        let image = UIImage(named: "logo_text.png")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: View - Buttons
    lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var kakaoButton: UIImageView = {
        let img = UIImage(named: "kakao_login_large_wide.png")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kakaoTapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var appleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        button.addTarget(self, action: #selector(appleTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Indicator
    lazy var indicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.style = .large
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    lazy var blurOverlayView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let vev = UIVisualEffectView(effect: blurEffect)
        vev.alpha = 0.3
        vev.translatesAutoresizingMaskIntoConstraints = false
        return vev
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        UINavigationBar.appearance().tintColor = .black
        
        configureView()
        
        loginRequest.delegate = self
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(titleContainerView)
        titleContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleContainerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5).isActive = true
        
        titleContainerView.addSubview(titleImageView)
        titleImageView.centerXAnchor.constraint(equalTo: titleContainerView.centerXAnchor).isActive = true
        titleImageView.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor).isActive = true
        titleImageView.widthAnchor.constraint(equalTo: titleContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XXXXXXXS).isActive = true
        
        // MARK: ConfigureView - Buttons
        view.addSubview(buttonContainerView)
        buttonContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        buttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        buttonContainerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5).isActive = true
        
        buttonContainerView.addSubview(kakaoButton)
        kakaoButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor).isActive = true
        kakaoButton.centerXAnchor.constraint(equalTo: buttonContainerView.centerXAnchor).isActive = true
        kakaoButton.widthAnchor.constraint(equalTo: buttonContainerView.widthAnchor, multiplier: 0.8).isActive = true
        
        buttonContainerView.addSubview(appleButton)
        appleButton.topAnchor.constraint(equalTo: kakaoButton.bottomAnchor, constant: SPACE_XS).isActive = true
        appleButton.centerXAnchor.constraint(equalTo: buttonContainerView.centerXAnchor).isActive = true
        appleButton.widthAnchor.constraint(equalTo: buttonContainerView.widthAnchor, multiplier: 0.8).isActive = true
        appleButton.heightAnchor.constraint(equalTo: buttonContainerView.widthAnchor, multiplier: 0.115).isActive = true
    }
    
    func showLoginFailedAlert(message: String) {
        let alert = UIAlertController(title: "로그인 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        present(alert, animated: true)
    }
    
    func fetchKakaoLogin(user: KakaoSDKUser.User) {
        var socialId = ""
        var email = ""
        
        socialId = String(user.id)
        if let kakaoAccount = user.kakaoAccount {
            if let _email = kakaoAccount.email { email = _email }
        }
        
        loginRequest.fetch(vc: self, paramDict: ["type": "KAKAO", "socialId": socialId, "email": email])
    }
    
    // MARK: Function - @OBJC
    @objc func kakaoTapped() {
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            // KAKAO App Login
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let _ = error {
                    self.hideIndicator(idv: self.indicatorView, bov: self.blurOverlayView)
                    self.showLoginFailedAlert(message: "사용자에 의해 카카오 로그인이 취소되었습니다.")
                    return
                }
                UserApi.shared.me() { (user, error) in
                    if let _ = error {
                        self.hideIndicator(idv: self.indicatorView, bov: self.blurOverlayView)
                        self.showLoginFailedAlert(message: "사용자 정보를 가져올 수 없습니다.")
                        return
                    }
                    guard let user = user else {
                        self.hideIndicator(idv: self.indicatorView, bov: self.blurOverlayView)
                        self.showLoginFailedAlert(message: "사용자 정보를 가져올 수 없습니다.")
                        return
                    }
                    self.fetchKakaoLogin(user: user)
                }
            }
            
        } else {
            // KAKAO Web Login
            AuthApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let _ = error {
                    self.hideIndicator(idv: self.indicatorView, bov: self.blurOverlayView)
                    self.showLoginFailedAlert(message: "사용자에 의해 카카오 로그인이 취소되었습니다.")
                    return
                }
                UserApi.shared.me() { (user, error) in
                    if let _ = error {
                        self.hideIndicator(idv: self.indicatorView, bov: self.blurOverlayView)
                        self.showLoginFailedAlert(message: "사용자 정보를 가져올 수 없습니다.")
                        return
                    }
                    guard let user = user else {
                        self.hideIndicator(idv: self.indicatorView, bov: self.blurOverlayView)
                        self.showLoginFailedAlert(message: "사용자 정보를 가져올 수 없습니다.")
                        return
                    }
                    self.fetchKakaoLogin(user: user)
                }
            }
        }
    }
    
    @objc func appleTapped() {
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
            
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}


// MARK: HTTP - Login
extension LoginViewController: LoginRequestProtocol {
    func response(user: User?, login status: String) {
        print("[HTTP RES]", loginRequest.apiUrl, status)
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
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

// MARK: AppleLogin
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // 애플 로그인 성공
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let socialId = appleIDCredential.user
            var email = ""
            if let _email = appleIDCredential.email { email = _email }
            loginRequest.fetch(vc: self, paramDict: ["type": "APPLE", "socialId": socialId, "email": email])
            
        default:
            hideIndicator(idv: indicatorView, bov: blurOverlayView)
            showLoginFailedAlert(message: "사용자 정보를 가져올 수 없습니다.")
            break
        }
    }
    
    // 애플 로그인 취소 혹은 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
        showLoginFailedAlert(message: "사용자에 의해 애플 로그인이 취소되었습니다.")
    }
}
