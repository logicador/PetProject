//
//  LeaveViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/16.
//

import UIKit


class LeaveViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let leaveRequest = LeaveRequest()
    
    
    // MARK: View
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var leaveButton: ConfirmButton = {
        let cb = ConfirmButton(type: .system)
        cb.backgroundColor = .systemGray3
        cb.setTitle("탈퇴하기", for: .normal)
        cb.titleLabel?.font = .boldSystemFont(ofSize: 20)
        cb.addTarget(self, action: #selector(leaveTapped), for: .touchUpInside)
        return cb
    }()
    
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
        sv.spacing = SPACE_XL
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원 탈퇴하기"
        label.font = .boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "탈퇴하기 전에 아래 내용을 꼭 확인하세요."
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var titleBottomLine: LineView = {
        let lv = LineView(width: 1, color: .black)
        return lv
    }()
    
    lazy var leave1Label: UILabel = {
        let label = UILabel()
        label.text = "1. 위 내용을 숙지했습니다. 전부 삭제하고 탈퇴하겠습니다. 탈퇴하겠습니다. 전부 삭제하고 탈퇴하겠습니다.전부 삭제하고 탈퇴하겠습니다. 탈퇴"
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var leave2Label: UILabel = {
        let label = UILabel()
        label.text = "2. 위 내용을 숙지했습니다. 전부 삭제하고 탈퇴하겠습니다. 탈퇴하겠습니다. 전부 삭제"
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var leave3Label: UILabel = {
        let label = UILabel()
        label.text = "3. 위 내용을 숙지했습니다. 전부 삭제하고 탈퇴하겠습니다. 탈퇴하겠습니다. 전부 삭제하고 탈퇴하겠습니다.전부 삭제하고 탈퇴하겠습니다. 탈퇴하 겠습니다. 전"
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var leave4Label: UILabel = {
        let label = UILabel()
        label.text = "4. 위 내용을 숙지했습니다. 전부 삭제하고 탈퇴하겠습니다. 탈퇴하겠습니다. 전부 삭제하고 탈퇴하겠습니다.전부 삭제하고 탈퇴하겠습니다. 탈퇴하 겠습니다. 전부 삭"
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var agreeContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(agreeTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var agreeImageView: UIImageView = {
        let img = UIImage(systemName: "checkmark.circle.fill")
        let iv = UIImageView(image: img)
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var agreeLabel: UILabel = {
        let label = UILabel()
        label.text = "위 내용을 숙지했습니다.\n전부 삭제하고 탈퇴하겠습니다."
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "회원탈퇴"
        
        configureView()
        
        leaveRequest.delegate = self
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(bottomView)
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        bottomView.addSubview(leaveButton)
        leaveButton.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        leaveButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        leaveButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        leaveButton.heightAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.12).isActive = true
        leaveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(titleContainerView)
        titleContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        titleContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
        
        titleContainerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor, constant: SPACE_XXXL).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: titleContainerView.centerXAnchor).isActive = true
        
        titleContainerView.addSubview(subTitleLabel)
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        subTitleLabel.centerXAnchor.constraint(equalTo: titleContainerView.centerXAnchor).isActive = true
        
        titleContainerView.addSubview(titleBottomLine)
        titleBottomLine.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: SPACE_XL).isActive = true
        titleBottomLine.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor).isActive = true
        titleBottomLine.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor).isActive = true
        titleBottomLine.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(leave1Label)
        leave1Label.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        leave1Label.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
        
        stackView.addArrangedSubview(leave2Label)
        leave2Label.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        leave2Label.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
        
        stackView.addArrangedSubview(leave3Label)
        leave3Label.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        leave3Label.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
        
        stackView.addArrangedSubview(leave4Label)
        leave4Label.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        leave4Label.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
        
        stackView.addArrangedSubview(agreeContainerView)
        agreeContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        agreeContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
        
        agreeContainerView.addSubview(agreeImageView)
        agreeImageView.topAnchor.constraint(equalTo: agreeContainerView.topAnchor, constant: SPACE_XL).isActive = true
        agreeImageView.leadingAnchor.constraint(equalTo: agreeContainerView.leadingAnchor).isActive = true
        agreeImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        agreeImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        agreeImageView.bottomAnchor.constraint(equalTo: agreeContainerView.bottomAnchor).isActive = true
        
        agreeContainerView.addSubview(agreeLabel)
        agreeLabel.centerYAnchor.constraint(equalTo: agreeImageView.centerYAnchor).isActive = true
        agreeLabel.leadingAnchor.constraint(equalTo: agreeImageView.trailingAnchor).isActive = true
        agreeLabel.trailingAnchor.constraint(equalTo: agreeContainerView.trailingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func leaveTapped() {
        if leaveButton.backgroundColor == .systemGray3 { return }
        
        leaveRequest.fetch(vc: self, paramDict: [:])
    }
    
    @objc func agreeTapped() {
        agreeImageView.tintColor = (agreeImageView.tintColor == .systemRed) ? .systemGray3 : .systemRed
        bottomView.backgroundColor = (agreeImageView.tintColor == .systemRed) ? .systemRed : .systemGray3
        leaveButton.backgroundColor = (agreeImageView.tintColor == .systemRed) ? .systemRed : .systemGray3
    }
}


// MARK: HTTP - Leave
extension LeaveViewController: LeaveRequestProtocol {
    func response(leave status: String) {
        print("[HTTP RES]", leaveRequest.apiUrl, status)

        if status == "OK" {
            app.logout()
            changeRootViewController(rootViewController: LoginViewController())
        }
    }
}
