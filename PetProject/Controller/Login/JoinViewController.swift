//
//  JoinViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


class JoinViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let joinRequest = JoinRequest()
    let logoutRequest = LogoutRequest()
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - NickName
    lazy var nickNameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = SPACE_XXS
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var nickNameContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var nickNameTextContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var nickNameTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = .mainColor
        tf.textAlignment = .right
        tf.font = .systemFont(ofSize: 18)
        tf.placeholder = "국문 최대 8자 영문 최대 10자 입력"
        tf.addTarget(self, action: #selector(checkIsValid), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var nickNameBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Agree
    lazy var agreeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = SPACE_XXS
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var agreeContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var agree1Label: UILabel = {
        let label = UILabel()
        label.text = "서비스 이용약관"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var agreeView1: AgreeView = {
        let av = AgreeView(title: "서비스 이용 동의", action: "agreement")
        av.delegate = self
        return av
    }()
    lazy var agreeView2: AgreeView = {
        let av = AgreeView(title: "서비스 약관 동의", action: "agreement")
        av.delegate = self
        return av
    }()
    
    lazy var agree2Label: UILabel = {
        let label = UILabel()
        label.text = "개인정보 처리방침"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var agreeView4: AgreeView = {
        let av = AgreeView(title: "개인정보수집/이용 동의", action: "privacy")
        av.delegate = self
        return av
    }()
    lazy var agreeView5: AgreeView = {
        let av = AgreeView(title: "개인정보관리 동의", action: "privacy")
        av.delegate = self
        return av
    }()
    lazy var agreeView6: AgreeView = {
        let av = AgreeView(title: "개인정보위탁처리 동의", action: "privacy")
        av.delegate = self
        return av
    }()
    
    lazy var allAgreeTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var allAgreeContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allAgreeTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var allAgreeLabel: UILabel = {
        let label = UILabel()
        label.text = "모두 동의합니다."
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var allAgreeImageView: UIImageView = {
        let img = UIImage(systemName: "checkmark.circle.fill")
        let iv = UIImageView(image: img)
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: View - Other
    lazy var joinButton: ConfirmButton = {
        let cb = ConfirmButton(type: .system)
        cb.setTitle("회원가입 완료", for: .normal)
        cb.titleLabel?.font = .boldSystemFont(ofSize: 24)
        cb.addTarget(self, action: #selector(joinTapped), for: .touchUpInside)
        return cb
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        UINavigationBar.appearance().tintColor = .black
        
        navigationItem.title = "회원가입"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backTapped))
    
//        navigationController?.navigationBar.tintColor = .mainColor
        
        configureView()
        
        hideKeyboardWhenTappedAround()
        
        joinRequest.delegate = self
        logoutRequest.delegate = self
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: (SCREEN_WIDTH * 0.06)).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -(SCREEN_WIDTH * 0.12)).isActive = true
        
        // MARK: ConfigureView - NickName
        stackView.addArrangedSubview(nickNameContainerView)
        nickNameContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        nickNameContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        
        nickNameContainerView.addSubview(nickNameContentView)
        nickNameContentView.topAnchor.constraint(equalTo: nickNameContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        nickNameContentView.widthAnchor.constraint(equalTo: nickNameContainerView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        nickNameContentView.centerXAnchor.constraint(equalTo: nickNameContainerView.centerXAnchor).isActive = true
        nickNameContentView.bottomAnchor.constraint(equalTo: nickNameContainerView.bottomAnchor, constant: -SPACE_XXL).isActive = true
        
        nickNameContentView.addSubview(nickNameLabel)
        nickNameLabel.topAnchor.constraint(equalTo: nickNameContentView.topAnchor).isActive = true
        nickNameLabel.leadingAnchor.constraint(equalTo: nickNameContentView.leadingAnchor).isActive = true
        
        nickNameContentView.addSubview(nickNameTextContainerView)
        nickNameTextContainerView.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor).isActive = true
        nickNameTextContainerView.leadingAnchor.constraint(equalTo: nickNameContentView.leadingAnchor).isActive = true
        nickNameTextContainerView.trailingAnchor.constraint(equalTo: nickNameContentView.trailingAnchor).isActive = true
        
        nickNameTextContainerView.addSubview(nickNameTextField)
        nickNameTextField.topAnchor.constraint(equalTo: nickNameTextContainerView.topAnchor, constant: SPACE_XS).isActive = true
        nickNameTextField.leadingAnchor.constraint(equalTo: nickNameTextContainerView.leadingAnchor).isActive = true
        nickNameTextField.trailingAnchor.constraint(equalTo: nickNameTextContainerView.trailingAnchor).isActive = true
        nickNameTextField.bottomAnchor.constraint(equalTo: nickNameTextContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        nickNameContentView.addSubview(nickNameBottomLine)
        nickNameBottomLine.topAnchor.constraint(equalTo: nickNameTextContainerView.bottomAnchor).isActive = true
        nickNameBottomLine.leadingAnchor.constraint(equalTo: nickNameContentView.leadingAnchor).isActive = true
        nickNameBottomLine.trailingAnchor.constraint(equalTo: nickNameContentView.trailingAnchor).isActive = true
        nickNameBottomLine.bottomAnchor.constraint(equalTo: nickNameContentView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Agree
        stackView.addArrangedSubview(agreeContainerView)
        agreeContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        agreeContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        
        agreeContainerView.addSubview(agreeContentView)
        agreeContentView.topAnchor.constraint(equalTo: agreeContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        agreeContentView.widthAnchor.constraint(equalTo: agreeContainerView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        agreeContentView.centerXAnchor.constraint(equalTo: agreeContainerView.centerXAnchor).isActive = true
        agreeContentView.bottomAnchor.constraint(equalTo: agreeContainerView.bottomAnchor, constant: -SPACE_XXL).isActive = true
        
        agreeContentView.addSubview(agree1Label)
        agree1Label.topAnchor.constraint(equalTo: agreeContentView.topAnchor).isActive = true
        agree1Label.leadingAnchor.constraint(equalTo: agreeContentView.leadingAnchor).isActive = true
        
        agreeContentView.addSubview(agreeView1)
        agreeView1.topAnchor.constraint(equalTo: agree1Label.bottomAnchor, constant: SPACE_S).isActive = true
        agreeView1.leadingAnchor.constraint(equalTo: agreeContentView.leadingAnchor, constant: SPACE_XS).isActive = true
        agreeView1.trailingAnchor.constraint(equalTo: agreeContentView.trailingAnchor, constant: -SPACE_XS).isActive = true
        agreeContentView.addSubview(agreeView2)
        agreeView2.topAnchor.constraint(equalTo: agreeView1.bottomAnchor).isActive = true
        agreeView2.leadingAnchor.constraint(equalTo: agreeContentView.leadingAnchor, constant: SPACE_XS).isActive = true
        agreeView2.trailingAnchor.constraint(equalTo: agreeContentView.trailingAnchor, constant: -SPACE_XS).isActive = true
        
        agreeContentView.addSubview(agree2Label)
        agree2Label.topAnchor.constraint(equalTo: agreeView2.bottomAnchor, constant: SPACE_XXL).isActive = true
        agree2Label.leadingAnchor.constraint(equalTo: agreeContentView.leadingAnchor).isActive = true
        
        agreeContentView.addSubview(agreeView4)
        agreeView4.topAnchor.constraint(equalTo: agree2Label.bottomAnchor, constant: SPACE_S).isActive = true
        agreeView4.leadingAnchor.constraint(equalTo: agreeContentView.leadingAnchor, constant: SPACE_XS).isActive = true
        agreeView4.trailingAnchor.constraint(equalTo: agreeContentView.trailingAnchor, constant: -SPACE_XS).isActive = true
        agreeContentView.addSubview(agreeView5)
        agreeView5.topAnchor.constraint(equalTo: agreeView4.bottomAnchor).isActive = true
        agreeView5.leadingAnchor.constraint(equalTo: agreeContentView.leadingAnchor, constant: SPACE_XS).isActive = true
        agreeView5.trailingAnchor.constraint(equalTo: agreeContentView.trailingAnchor, constant: -SPACE_XS).isActive = true
        agreeContentView.addSubview(agreeView6)
        agreeView6.topAnchor.constraint(equalTo: agreeView5.bottomAnchor).isActive = true
        agreeView6.leadingAnchor.constraint(equalTo: agreeContentView.leadingAnchor, constant: SPACE_XS).isActive = true
        agreeView6.trailingAnchor.constraint(equalTo: agreeContentView.trailingAnchor, constant: -SPACE_XS).isActive = true
        
        agreeContentView.addSubview(allAgreeTopLine)
        allAgreeTopLine.topAnchor.constraint(equalTo: agreeView6.bottomAnchor, constant: SPACE_XXL).isActive = true
        allAgreeTopLine.leadingAnchor.constraint(equalTo: agreeContentView.leadingAnchor).isActive = true
        allAgreeTopLine.trailingAnchor.constraint(equalTo: agreeContentView.trailingAnchor).isActive = true
        
        agreeContentView.addSubview(allAgreeContainerView)
        allAgreeContainerView.topAnchor.constraint(equalTo: allAgreeTopLine.bottomAnchor, constant: SPACE_XXL).isActive = true
        allAgreeContainerView.leadingAnchor.constraint(equalTo: agreeContentView.leadingAnchor).isActive = true
        allAgreeContainerView.trailingAnchor.constraint(equalTo: agreeContentView.trailingAnchor).isActive = true
        allAgreeContainerView.bottomAnchor.constraint(equalTo: agreeContentView.bottomAnchor).isActive = true
        
        allAgreeContainerView.addSubview(allAgreeImageView)
        allAgreeImageView.topAnchor.constraint(equalTo: allAgreeContainerView.topAnchor).isActive = true
        allAgreeImageView.trailingAnchor.constraint(equalTo: allAgreeContainerView.trailingAnchor).isActive = true
        allAgreeImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        allAgreeImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        allAgreeImageView.bottomAnchor.constraint(equalTo: allAgreeContainerView.bottomAnchor).isActive = true
        
        allAgreeContainerView.addSubview(allAgreeLabel)
        allAgreeLabel.leadingAnchor.constraint(equalTo: allAgreeContainerView.leadingAnchor).isActive = true
        allAgreeLabel.centerYAnchor.constraint(equalTo: allAgreeImageView.centerYAnchor).isActive = true
        
        // MARK: ConfigureView - Other
        stackView.addArrangedSubview(joinButton)
        joinButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        joinButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        joinButton.heightAnchor.constraint(equalToConstant: CONFIRM_BUTTON_HEIGHT).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func backTapped() {
        dismissKeyboard()
        
        logoutRequest.fetch(vc: self, paramDict: [:])
    }
    
    @objc func checkIsValid() {
        guard let nickName = nickNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            joinButton.setActive(isActive: false)
            return
        }
        
        if !isValidString(min: 2, utf8Min: 4, max: 10, utf8Max: 24, value: nickName) {
            joinButton.setActive(isActive: false)
            return
        }
        
        var agreeCnt = 0
        agreeCnt += agreeView1.isAgree ? 1 : 0
        agreeCnt += agreeView2.isAgree ? 1 : 0
        agreeCnt += agreeView4.isAgree ? 1 : 0
        agreeCnt += agreeView5.isAgree ? 1 : 0
        agreeCnt += agreeView6.isAgree ? 1 : 0
        if agreeCnt < 5 {
            joinButton.setActive(isActive: false)
            return
        }
        
        joinButton.setActive(isActive: true)
    }
    
    @objc func allAgreeTapped() {
        dismissKeyboard()
        
        var isAgree = false
        if allAgreeImageView.tintColor == UIColor.systemGray3 {
            isAgree = true
            allAgreeImageView.tintColor = .mainColor
        } else {
            isAgree = false
            allAgreeImageView.tintColor = .systemGray3
            navigationItem.rightBarButtonItem = nil
        }
        
        agreeView1.setAgree(isAgree: isAgree)
        agreeView2.setAgree(isAgree: isAgree)
        agreeView4.setAgree(isAgree: isAgree)
        agreeView5.setAgree(isAgree: isAgree)
        agreeView6.setAgree(isAgree: isAgree)
        
        checkIsValid()
    }
    
    @objc func joinTapped() {
        dismissKeyboard()
        
        if !joinButton.isActive { return }
        
        guard let nickName = nickNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        joinRequest.fetch(vc: self, paramDict: ["nickName": nickName])
    }
}


// MARK: AgreeView
extension JoinViewController: AgreeViewProtocol {
    func openAgree(action: String) {
        dismissKeyboard()
        
        let termsWebVC = TermsWebViewController()
        termsWebVC.terms = action
        navigationController?.pushViewController(termsWebVC, animated: true)
    }
    
    func agree(isAgree: Bool) {
        dismissKeyboard()
        
        if isAgree {
            var agreeCnt = 0
            agreeCnt += agreeView1.isAgree ? 1 : 0
            agreeCnt += agreeView2.isAgree ? 1 : 0
            agreeCnt += agreeView4.isAgree ? 1 : 0
            agreeCnt += agreeView5.isAgree ? 1 : 0
            agreeCnt += agreeView6.isAgree ? 1 : 0
            if agreeCnt == 5 { allAgreeImageView.tintColor = .mainColor }
            
        } else {
            if allAgreeImageView.tintColor == UIColor.mainColor {
                allAgreeImageView.tintColor = .systemGray3
                navigationItem.rightBarButtonItem = nil
            }
        }
        
        checkIsValid()
    }
}

// MARK: HTTP - Join
extension JoinViewController: JoinRequestProtocol {
    func response(user: User?, join status: String) {
        print("[HTTP RES]", joinRequest.apiUrl, status)
        
        if status == "OK" {
            guard let user = user else { return }
            app.login(user: user)
            changeRootViewController(rootViewController: UINavigationController(rootViewController: PetInfoViewController()))
        }
    }
}

// MARK: HTTP - Logout
extension JoinViewController: LogoutRequestProtocol {
    func response(logout status: String) {
        print("[HTTP RES]", logoutRequest.apiUrl, status)
        
        if status == "OK" {
            app.logout()
            changeRootViewController(rootViewController: LoginViewController())
        }
    }
}
