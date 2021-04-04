//
//  BreedCharacterView.swift
//  PetProject
//
//  Created by 서원영 on 2021/04/04.
//

import UIKit


class BreedCharacterView: UIView {
    
    // MARK: Property
    var score: Int = 0 {
        didSet {
            if score == 1 {
                start1ImageView.tintColor = .mainColor
            } else if score == 2 {
                start1ImageView.tintColor = .mainColor
                start2ImageView.tintColor = .mainColor
            } else if score == 3 {
                start1ImageView.tintColor = .mainColor
                start2ImageView.tintColor = .mainColor
                start3ImageView.tintColor = .mainColor
            } else if score == 4 {
                start1ImageView.tintColor = .mainColor
                start2ImageView.tintColor = .mainColor
                start3ImageView.tintColor = .mainColor
                start4ImageView.tintColor = .mainColor
            } else if score == 5 {
                start1ImageView.tintColor = .mainColor
                start2ImageView.tintColor = .mainColor
                start3ImageView.tintColor = .mainColor
                start4ImageView.tintColor = .mainColor
                start5ImageView.tintColor = .mainColor
            }
        }
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var bottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var start1ImageView: UIImageView = {
        let image = UIImage(systemName: "star.fill")
        let iv = UIImageView(image: image)
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var start2ImageView: UIImageView = {
        let image = UIImage(systemName: "star.fill")
        let iv = UIImageView(image: image)
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var start3ImageView: UIImageView = {
        let image = UIImage(systemName: "star.fill")
        let iv = UIImageView(image: image)
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var start4ImageView: UIImageView = {
        let image = UIImage(systemName: "star.fill")
        let iv = UIImageView(image: image)
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var start5ImageView: UIImageView = {
        let image = UIImage(systemName: "star.fill")
        let iv = UIImageView(image: image)
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        configureView()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE_S).isActive = true
        
        containerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        
        containerView.addSubview(start1ImageView)
        start1ImageView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        start1ImageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: SPACE_XXS).isActive = true
        start1ImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        start1ImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        containerView.addSubview(start2ImageView)
        start2ImageView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        start2ImageView.leadingAnchor.constraint(equalTo: start1ImageView.trailingAnchor, constant: 1).isActive = true
        start2ImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        start2ImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        containerView.addSubview(start3ImageView)
        start3ImageView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        start3ImageView.leadingAnchor.constraint(equalTo: start2ImageView.trailingAnchor, constant: 1).isActive = true
        start3ImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        start3ImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        containerView.addSubview(start4ImageView)
        start4ImageView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        start4ImageView.leadingAnchor.constraint(equalTo: start3ImageView.trailingAnchor, constant: 1).isActive = true
        start4ImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        start4ImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        containerView.addSubview(start5ImageView)
        start5ImageView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        start5ImageView.leadingAnchor.constraint(equalTo: start4ImageView.trailingAnchor, constant: 1).isActive = true
        start5ImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        start5ImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        containerView.addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: SPACE_XXS).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        addSubview(bottomLine)
        bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
