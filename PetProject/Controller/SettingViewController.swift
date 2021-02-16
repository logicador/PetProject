//
//  SettingViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/13.
//

import UIKit
import SDWebImage


class SettingViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let logoutRequest = LogoutRequest()
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var profileContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = SCREEN_WIDTH * 0.12
        iv.backgroundColor = .systemGray4
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var profileNickNameContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileNickNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var profileNickNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닉네임 편집", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.tintColor = .systemGray2
        button.addTarget(self, action: #selector(editNickNameTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var profileBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    lazy var noticeSettingView: SettingView = {
        let sv = SettingView()
        sv.label.text = "공지사항"
        sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(noticeTapped)))
        return sv
    }()
    lazy var questionSettingView: SettingView = {
        let sv = SettingView()
        sv.label.text = "1:1 문의"
        sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(questionTapped)))
        return sv
    }()
    lazy var agreementSettingView: SettingView = {
        let sv = SettingView()
        sv.label.text = "이용약관"
        sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(agreementTapped)))
        return sv
    }()
    lazy var privacySettingView: SettingView = {
        let sv = SettingView()
        sv.label.text = "개인정보 처리방침"
        sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(privacyTapped)))
        return sv
    }()
    lazy var logoutSettingView: SettingView = {
        let sv = SettingView()
        sv.imageView.isHidden = true
        sv.label.text = "로그아웃"
        sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutTapped)))
        return sv
    }()
    lazy var leaveSettingView: SettingView = {
        let sv = SettingView()
        sv.imageView.isHidden = true
        sv.label.text = "회원탈퇴"
        sv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leaveTapped)))
        return sv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "설정"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        logoutRequest.delegate = self
        
        let user = app.getUser()
        let pet = app.getPet()
        
        profileNickNameLabel.text = user.nickName
        
        guard let thumbnail = pet.thumbnail else { return }
        if let url = URL(string: PROJECT_URL + thumbnail) {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(profileContainerView)
        profileContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        profileContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        profileContainerView.addSubview(profileContentView)
        profileContentView.topAnchor.constraint(equalTo: profileContainerView.topAnchor).isActive = true
        profileContentView.centerXAnchor.constraint(equalTo: profileContainerView.centerXAnchor).isActive = true
        profileContentView.widthAnchor.constraint(equalTo: profileContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        profileContentView.bottomAnchor.constraint(equalTo: profileContainerView.bottomAnchor).isActive = true
        
        profileContentView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: profileContentView.topAnchor, constant: SPACE_L).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: profileContentView.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH * 0.24).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: SCREEN_WIDTH * 0.24).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: profileContentView.bottomAnchor, constant: -SPACE_L).isActive = true
        
        profileContentView.addSubview(profileNickNameContainerView)
        profileNickNameContainerView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: SPACE).isActive = true
        profileNickNameContainerView.trailingAnchor.constraint(equalTo: profileContentView.trailingAnchor).isActive = true
        profileNickNameContainerView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        profileNickNameContainerView.addSubview(profileNickNameLabel)
        profileNickNameLabel.topAnchor.constraint(equalTo: profileNickNameContainerView.topAnchor).isActive = true
        profileNickNameLabel.leadingAnchor.constraint(equalTo: profileNickNameContainerView.leadingAnchor).isActive = true
        
        profileNickNameContainerView.addSubview(profileNickNameButton)
        profileNickNameButton.topAnchor.constraint(equalTo: profileNickNameLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        profileNickNameButton.leadingAnchor.constraint(equalTo: profileNickNameContainerView.leadingAnchor).isActive = true
        profileNickNameButton.bottomAnchor.constraint(equalTo: profileNickNameContainerView.bottomAnchor).isActive = true
        
        profileContainerView.addSubview(profileBottomLine)
        profileBottomLine.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor).isActive = true
        profileBottomLine.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor).isActive = true
        profileBottomLine.bottomAnchor.constraint(equalTo: profileContainerView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(noticeSettingView)
        noticeSettingView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        noticeSettingView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(questionSettingView)
        questionSettingView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        questionSettingView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(agreementSettingView)
        agreementSettingView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        agreementSettingView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(privacySettingView)
        privacySettingView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        privacySettingView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(logoutSettingView)
        logoutSettingView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        logoutSettingView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(leaveSettingView)
        leaveSettingView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        leaveSettingView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func editNickNameTapped() {
        navigationController?.pushViewController(EditNickNameViewController(), animated: true)
    }
    
    @objc func noticeTapped() {
        navigationController?.pushViewController(NoticeListViewController(), animated: true)
    }
    
    @objc func questionTapped() {
        navigationController?.pushViewController(QuestionViewController(), animated: true)
    }
    
    @objc func agreementTapped() {
        let termsWevVC = TermsWebViewController()
        termsWevVC.navigationItem.title = "이용약관"
        termsWevVC.path = "/agreement"
        navigationController?.pushViewController(termsWevVC, animated: true)
    }
    
    @objc func privacyTapped() {
        let termsWevVC = TermsWebViewController()
        termsWevVC.navigationItem.title = "개인정보 처리방침"
        termsWevVC.path = "/privacy"
        navigationController?.pushViewController(termsWevVC, animated: true)
    }
    
    @objc func logoutTapped() {
        let alert = UIAlertController(title: nil, message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "네, 로그아웃 합니다.", style: .destructive, handler: { (_) in
            self.logoutRequest.fetch(vc: self, paramDict: [:])
        }))
        present(alert, animated: true)
    }
    
    @objc func leaveTapped() {
        navigationController?.pushViewController(LeaveViewController(), animated: true)
    }
}


// MARK: HTTP - Logout
extension SettingViewController: LogoutRequestProtocol {
    func response(logout status: String) {
        print("[HTTP RES]", logoutRequest.apiUrl, status)
        
        if status == "OK" {
            app.logout()
            changeRootViewController(rootViewController: LoginViewController())
        }
    }
}
