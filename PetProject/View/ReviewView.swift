//
//  ReviewView.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/13.
//

import UIKit
import SDWebImage


class ReviewView: UIView {
    
    // MARK: Property
    var review: Review? {
        didSet {
            guard let review = self.review else { return }
            
            nameLabel.text = review.uNickName
            infoLabel.text = "\(review.bName) / \(review.peBirth.monthAge())개월 / \((review.peGender == "M") ? "남아" : "여아")"
            dateLabel.text = String(review.createdDate.split(separator: " ")[0])
            
            totalScoreLabel.text = " \(String(format: "%.1f", review.avgScore))"
            palaScoreLabel.text = " \(Int(review.palaScore))"
            beneScoreLabel.text = " \(Int(review.beneScore))"
            costScoreLabel.text = " \(Int(review.costScore))"
            
            sideLabel.text = (review.side == "Y") ? " 1" : " 0"
            sideLabel.textColor = (review.side == "Y") ? .systemRed : .mainColor
            
            guard let descAdv = review.descAdv else { return }
            guard let descDisAdv = review.descDisadv else { return }
            if descAdv.isEmpty { descAdvContainerView.isHidden = true }
            if descDisAdv.isEmpty { descDisAdvContainerView.isHidden = true }
            
            descAdvLabel.text = review.descAdv
            descDisAdvLabel.text = review.descDisadv
            
            if review.imageList.count > 0 {
                if review.imageList.count > 0 {
                    if let url = URL(string: PROJECT_URL + review.imageList[0]) { image1ImageView.sd_setImage(with: url, completed: nil) }
                    if review.imageList.count > 1 {
                        if let url = URL(string: PROJECT_URL + review.imageList[1]) { image2ImageView.sd_setImage(with: url, completed: nil) }
                        if review.imageList.count > 2 {
                            if let url = URL(string: PROJECT_URL + review.imageList[2]) { image3ImageView.sd_setImage(with: url, completed: nil) }
                            if review.imageList.count > 3 {
                                if let url = URL(string: PROJECT_URL + review.imageList[3]) { image4ImageView.sd_setImage(with: url, completed: nil) }
                            }
                        }
                    }
                }
                
            } else {
                imageContainerView.isHidden = true
            }
        }
    }
    
    
    // MARK: View
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_S
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Header
    lazy var headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var headerBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Score
    lazy var scoreContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var totalScoreImageView: UIImageView = {
        let img = UIImage(systemName: "star.fill")
        let iv = UIImageView(image: img)
        iv.tintColor = .mainColor
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var totalScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var palaScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "기호성"
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var palaScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var beneScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "기대효과"
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var beneScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var costScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가성비"
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var costScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var sideTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "부작용"
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var sideLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Image
    lazy var imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var image1ImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var image2ImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var image3ImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var image4ImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: View - Desc
    lazy var descAdvContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var descAdvTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "장점"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var descAdvTextContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = LINE_WIDTH
        view.layer.cornerRadius = SPACE_XXS
        view.layer.borderColor = UIColor.separator.cgColor
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var descAdvLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descDisAdvContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var descDisAdvTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "단점"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var descDisAdvTextContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = LINE_WIDTH
        view.layer.cornerRadius = SPACE_XXS
        view.layer.borderColor = UIColor.separator.cgColor
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var descDisAdvLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Header
        stackView.addArrangedSubview(headerContainerView)
        headerContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        headerContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        headerContainerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        
        headerContainerView.addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        
        headerContainerView.addSubview(dateLabel)
        dateLabel.centerYAnchor.constraint(equalTo: infoLabel.centerYAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        
        headerContainerView.addSubview(headerBottomLine)
        headerBottomLine.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: SPACE_XXS).isActive = true
        headerBottomLine.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        headerBottomLine.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        headerBottomLine.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Score
        stackView.addArrangedSubview(scoreContainerView)
        scoreContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        scoreContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        scoreContainerView.addSubview(totalScoreImageView)
        totalScoreImageView.topAnchor.constraint(equalTo: scoreContainerView.topAnchor).isActive = true
        totalScoreImageView.leadingAnchor.constraint(equalTo: scoreContainerView.leadingAnchor).isActive = true
        totalScoreImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        totalScoreImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        totalScoreImageView.bottomAnchor.constraint(equalTo: scoreContainerView.bottomAnchor).isActive = true
        
        scoreContainerView.addSubview(totalScoreLabel)
        totalScoreLabel.centerYAnchor.constraint(equalTo: totalScoreImageView.centerYAnchor).isActive = true
        totalScoreLabel.leadingAnchor.constraint(equalTo: totalScoreImageView.trailingAnchor).isActive = true
        
        scoreContainerView.addSubview(sideLabel)
        sideLabel.centerYAnchor.constraint(equalTo: totalScoreImageView.centerYAnchor).isActive = true
        sideLabel.trailingAnchor.constraint(equalTo: scoreContainerView.trailingAnchor).isActive = true
        
        scoreContainerView.addSubview(sideTitleLabel)
        sideTitleLabel.centerYAnchor.constraint(equalTo: totalScoreImageView.centerYAnchor).isActive = true
        sideTitleLabel.trailingAnchor.constraint(equalTo: sideLabel.leadingAnchor).isActive = true
        
        scoreContainerView.addSubview(costScoreLabel)
        costScoreLabel.centerYAnchor.constraint(equalTo: totalScoreImageView.centerYAnchor).isActive = true
        costScoreLabel.trailingAnchor.constraint(equalTo: sideTitleLabel.leadingAnchor, constant: -SPACE_XXS).isActive = true
        
        scoreContainerView.addSubview(costScoreTitleLabel)
        costScoreTitleLabel.centerYAnchor.constraint(equalTo: totalScoreImageView.centerYAnchor).isActive = true
        costScoreTitleLabel.trailingAnchor.constraint(equalTo: costScoreLabel.leadingAnchor).isActive = true
        
        scoreContainerView.addSubview(beneScoreLabel)
        beneScoreLabel.centerYAnchor.constraint(equalTo: totalScoreImageView.centerYAnchor).isActive = true
        beneScoreLabel.trailingAnchor.constraint(equalTo: costScoreTitleLabel.leadingAnchor, constant: -SPACE_XXS).isActive = true
        
        scoreContainerView.addSubview(beneScoreTitleLabel)
        beneScoreTitleLabel.centerYAnchor.constraint(equalTo: totalScoreImageView.centerYAnchor).isActive = true
        beneScoreTitleLabel.trailingAnchor.constraint(equalTo: beneScoreLabel.leadingAnchor).isActive = true
        
        scoreContainerView.addSubview(palaScoreLabel)
        palaScoreLabel.centerYAnchor.constraint(equalTo: totalScoreImageView.centerYAnchor).isActive = true
        palaScoreLabel.trailingAnchor.constraint(equalTo: beneScoreTitleLabel.leadingAnchor, constant: -SPACE_XXS).isActive = true
        
        scoreContainerView.addSubview(palaScoreTitleLabel)
        palaScoreTitleLabel.centerYAnchor.constraint(equalTo: totalScoreImageView.centerYAnchor).isActive = true
        palaScoreTitleLabel.trailingAnchor.constraint(equalTo: palaScoreLabel.leadingAnchor).isActive = true
        
        // MARK: ConfigureView - Image
        stackView.addArrangedSubview(imageContainerView)
        imageContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        imageContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        imageContainerView.addSubview(image1ImageView)
        image1ImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor).isActive = true
        image1ImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor).isActive = true
        image1ImageView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 1 / 4, constant: -3).isActive = true
        image1ImageView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 1 / 4, constant: -3).isActive = true
        image1ImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        
        imageContainerView.addSubview(image2ImageView)
        image2ImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor).isActive = true
        image2ImageView.leadingAnchor.constraint(equalTo: image1ImageView.trailingAnchor, constant: 4).isActive = true
        image2ImageView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 1 / 4, constant: -3).isActive = true
        image2ImageView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 1 / 4, constant: -3).isActive = true
        image2ImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        
        imageContainerView.addSubview(image3ImageView)
        image3ImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor).isActive = true
        image3ImageView.leadingAnchor.constraint(equalTo: image2ImageView.trailingAnchor, constant: 4).isActive = true
        image3ImageView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 1 / 4, constant: -3).isActive = true
        image3ImageView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 1 / 4, constant: -3).isActive = true
        image3ImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        
        imageContainerView.addSubview(image4ImageView)
        image4ImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor).isActive = true
        image4ImageView.leadingAnchor.constraint(equalTo: image3ImageView.trailingAnchor, constant: 4).isActive = true
        image4ImageView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 1 / 4, constant: -3).isActive = true
        image4ImageView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 1 / 4, constant: -3).isActive = true
        image4ImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Desc
        stackView.addArrangedSubview(descAdvContainerView)
        descAdvContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        descAdvContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        descAdvContainerView.addSubview(descAdvTitleLabel)
        descAdvTitleLabel.topAnchor.constraint(equalTo: descAdvContainerView.topAnchor).isActive = true
        descAdvTitleLabel.leadingAnchor.constraint(equalTo: descAdvContainerView.leadingAnchor).isActive = true
        
        descAdvContainerView.addSubview(descAdvTextContainerView)
        descAdvTextContainerView.topAnchor.constraint(equalTo: descAdvTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        descAdvTextContainerView.leadingAnchor.constraint(equalTo: descAdvContainerView.leadingAnchor).isActive = true
        descAdvTextContainerView.trailingAnchor.constraint(equalTo: descAdvContainerView.trailingAnchor).isActive = true
        descAdvTextContainerView.bottomAnchor.constraint(equalTo: descAdvContainerView.bottomAnchor).isActive = true

        descAdvTextContainerView.addSubview(descAdvLabel)
        descAdvLabel.topAnchor.constraint(equalTo: descAdvTextContainerView.topAnchor, constant: SPACE_XXS).isActive = true
        descAdvLabel.leadingAnchor.constraint(equalTo: descAdvTextContainerView.leadingAnchor, constant: SPACE_XS).isActive = true
        descAdvLabel.trailingAnchor.constraint(equalTo: descAdvTextContainerView.trailingAnchor, constant: -SPACE_XS).isActive = true
        descAdvLabel.bottomAnchor.constraint(equalTo: descAdvTextContainerView.bottomAnchor, constant: -SPACE_XXS).isActive = true
        
        stackView.addArrangedSubview(descDisAdvContainerView)
        descDisAdvContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        descDisAdvContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        descDisAdvContainerView.addSubview(descDisAdvTitleLabel)
        descDisAdvTitleLabel.topAnchor.constraint(equalTo: descDisAdvContainerView.topAnchor).isActive = true
        descDisAdvTitleLabel.leadingAnchor.constraint(equalTo: descDisAdvContainerView.leadingAnchor).isActive = true
        
        descDisAdvContainerView.addSubview(descDisAdvTextContainerView)
        descDisAdvTextContainerView.topAnchor.constraint(equalTo: descDisAdvTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        descDisAdvTextContainerView.leadingAnchor.constraint(equalTo: descDisAdvContainerView.leadingAnchor).isActive = true
        descDisAdvTextContainerView.trailingAnchor.constraint(equalTo: descDisAdvContainerView.trailingAnchor).isActive = true
        descDisAdvTextContainerView.bottomAnchor.constraint(equalTo: descDisAdvContainerView.bottomAnchor).isActive = true

        descDisAdvTextContainerView.addSubview(descDisAdvLabel)
        descDisAdvLabel.topAnchor.constraint(equalTo: descDisAdvTextContainerView.topAnchor, constant: SPACE_XXS).isActive = true
        descDisAdvLabel.leadingAnchor.constraint(equalTo: descDisAdvTextContainerView.leadingAnchor, constant: SPACE_XS).isActive = true
        descDisAdvLabel.trailingAnchor.constraint(equalTo: descDisAdvTextContainerView.trailingAnchor, constant: -SPACE_XS).isActive = true
        descDisAdvLabel.bottomAnchor.constraint(equalTo: descDisAdvTextContainerView.bottomAnchor, constant: -SPACE_XXS).isActive = true
    }
}
