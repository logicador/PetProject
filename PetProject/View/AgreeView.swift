//
//  AgreeView.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


protocol AgreeViewProtocol {
    func openAgree(action: String)
    func agree(isAgree: Bool)
}


class AgreeView: UIView {
    
    // MARK: Property
    var delegate: AgreeViewProtocol?
    var isAgree: Bool = false {
        didSet {
            agreeImageView.tintColor = (isAgree) ? .mainColor: .systemGray3
        }
    }
    var action: String = ""
    
    
    // MARK: View
    lazy var agreeImageView: UIImageView = {
        let img = UIImage(systemName: "checkmark")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .mainColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var openButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("보기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.tintColor = .systemGray2
        button.addTarget(self, action: #selector(openTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: Init
    init(title: String, action: String) {
        super.init(frame: CGRect.zero)
        
        titleLabel.text = title
        self.action = action
        
        configureView()
        
        setAgree()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(agreeImageView)
        agreeImageView.topAnchor.constraint(equalTo: topAnchor, constant: SPACE_XS).isActive = true
        agreeImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        agreeImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        agreeImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        agreeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE_XS).isActive = true
        
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: agreeImageView.trailingAnchor, constant: SPACE_S).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: agreeImageView.centerYAnchor).isActive = true
        
        addSubview(openButton)
        openButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        openButton.centerYAnchor.constraint(equalTo: agreeImageView.centerYAnchor).isActive = true
    }
    
    func setAgree(isAgree: Bool = false) {
        self.isAgree = isAgree
    }
    
    // MARK: Function - @OBJC
    @objc func openTapped() {
        delegate?.openAgree(action: action)
    }
    
    @objc func selfTapped() {
        isAgree = !isAgree
        delegate?.agree(isAgree: isAgree)
    }
}
