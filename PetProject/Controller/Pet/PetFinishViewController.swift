//
//  PetFinishViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/11.
//

import UIKit


class PetFinishViewController: UIViewController {
    
    // MARK: View
    lazy var checkImageView: UIImageView = {
        let img = UIImage(systemName: "checkmark.circle.fill")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .mainColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "정보입력이 완료되었습니다."
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var backButton: ConfirmButton = {
        let cb = ConfirmButton(type: .system)
        cb.setTitle("뒤로 돌아가기", for: .normal)
        cb.titleLabel?.font = .boldSystemFont(ofSize: 24)
        cb.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return cb
    }()
    
    lazy var homeButton: ConfirmButton = {
        let cb = ConfirmButton(type: .system)
        cb.setActive(isActive: true)
        cb.setTitle("홈으로", for: .normal)
        cb.titleLabel?.font = .boldSystemFont(ofSize: 24)
        cb.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        return cb
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureView()
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(checkImageView)
        checkImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SPACE_XXXXXXL).isActive = true
        checkImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        checkImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        checkImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: checkImageView.bottomAnchor, constant: SPACE_L).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(backButton)
        backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -SPACE_XXXXL).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: CONFIRM_BUTTON_HEIGHT).isActive = true
        
        view.addSubview(homeButton)
        homeButton.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -SPACE).isActive = true
        homeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        homeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        homeButton.heightAnchor.constraint(equalToConstant: CONFIRM_BUTTON_HEIGHT).isActive = true
    }
    
    // MARK: Functions - @OBJC
    @objc func backTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func homeTapped() {
        changeRootViewController(rootViewController: UINavigationController(rootViewController: MainViewController()))
    }
}
