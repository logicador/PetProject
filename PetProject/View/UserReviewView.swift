//
//  UserReviewView.swift
//  PetProject
//
//  Created by 서원영 on 2021/03/16.
//

import UIKit


protocol UserReviewViewProtocol {
    func selectProduct(pId: Int)
    func removeUserReview(userReview: UserReview)
}


class UserReviewView: UIView {
    
    // MARK: Property
    var delegate: UserReviewViewProtocol?
    var userReview: UserReview? {
        didSet {
            guard let userReview = self.userReview else { return }
            
            let descAdv = userReview.descAdv ?? ""
            let descDisadv = userReview.descDisadv ?? ""
            
            label.text = (descAdv.isEmpty) ? descDisadv : descAdv
            
            if let url = URL(string: ADMIN_URL + userReview.pThumbnail) {
                thumbnailImageView.sd_setImage(with: url, completed: nil)
            }
        }
    }
    
    
    // MARK: View
    lazy var thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제", for: .normal)
        button.tintColor = .mainColor
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var bottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        configureView()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(thumbnailImageView)
        thumbnailImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        
        addSubview(label)
        label.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: SPACE).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(removeButton)
        removeButton.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: SPACE_XXS).isActive = true
        removeButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(bottomLine)
        bottomLine.topAnchor.constraint(equalTo: removeButton.bottomAnchor, constant: SPACE_XXS).isActive = true
        bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func selfTapped() {
        guard let userReview = self.userReview else { return }
        delegate?.selectProduct(pId: userReview.pId)
    }
    
    @objc func removeTapped() {
        guard let userReview = self.userReview else { return }
        delegate?.removeUserReview(userReview: userReview)
    }
}
