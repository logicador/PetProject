//
//  ProductView.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/12.
//

import UIKit
import SDWebImage


protocol ProductViewProtocol {
    func selectProduct(product: Product)
}


class ProductView: UIView {
    
    // MARK: Property
    var delegate: ProductViewProtocol?
    var product: Product? {
        didSet {
            guard let product = self.product else { return }
            
            if let url = URL(string: ADMIN_URL + product.thumbnail) {
                thumbnailImageView.sd_setImage(with: url, completed: nil)
            }
            
            brandLabel.text = product.pbName
            nameLabel.text = product.name
            priceLabel.text = "\(product.packingVolume) / \(product.price.intComma())원"
            
            totalScoreLabel.text = " \(String(format: "%.1f", product.avgScore)) "
            totalScoreCntLabel.text = "(\(String(product.reviewCnt)))"
            palaScoreLabel.text = String(format: "%.1f", product.palaScore)
            beneScoreLabel.text = String(format: "%.1f", product.beneScore)
            costScoreLabel.text = String(format: "%.1f", product.costScore)
        }
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.borderWidth = LINE_WIDTH
        iv.layer.borderColor = UIColor.separator.cgColor
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var descContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - TotalScore
    lazy var totalScoreContainerView: UIView = {
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
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var totalScoreCntLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Score
    lazy var scoreContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var palaScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "기호성 "
        label.font = .systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var palaScoreLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 11)
        label.textColor = .mainColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var palaLine: LineView = {
        let lv = LineView(orientation: .vertical, width: 1, color: .black)
        return lv
    }()
    
    lazy var beneScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "기대효과 "
        label.font = .systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var beneScoreLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 11)
        label.textColor = .mainColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var beneLine: LineView = {
        let lv = LineView(orientation: .vertical, width: 1, color: .black)
        return lv
    }()
    
    lazy var costScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가성비 "
        label.font = .systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var costScoreLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 11)
        label.textColor = .mainColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE).isActive = true
        
        containerView.addSubview(thumbnailImageView)
        thumbnailImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        thumbnailImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalToConstant: (SCREEN_WIDTH * CONTENTS_RATIO) / 3).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: (SCREEN_WIDTH * CONTENTS_RATIO) / 3).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        containerView.addSubview(descContainerView)
        descContainerView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        descContainerView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: (SCREEN_WIDTH * (1 - CONTENTS_RATIO)) / 2).isActive = true
        descContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        descContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        descContainerView.addSubview(brandLabel)
        brandLabel.topAnchor.constraint(equalTo: descContainerView.topAnchor).isActive = true
        brandLabel.leadingAnchor.constraint(equalTo: descContainerView.leadingAnchor).isActive = true
        brandLabel.trailingAnchor.constraint(equalTo: descContainerView.trailingAnchor).isActive = true
        
        descContainerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: descContainerView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: descContainerView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - TotalScore
        descContainerView.addSubview(totalScoreContainerView)
        totalScoreContainerView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: SPACE_XXS).isActive = true
        totalScoreContainerView.leadingAnchor.constraint(equalTo: descContainerView.leadingAnchor).isActive = true
        totalScoreContainerView.trailingAnchor.constraint(equalTo: descContainerView.trailingAnchor).isActive = true
        
        totalScoreContainerView.addSubview(totalScoreImageView)
        totalScoreImageView.leadingAnchor.constraint(equalTo: totalScoreContainerView.leadingAnchor).isActive = true
        totalScoreImageView.topAnchor.constraint(equalTo: totalScoreContainerView.topAnchor).isActive = true
        totalScoreImageView.leadingAnchor.constraint(equalTo: totalScoreContainerView.leadingAnchor).isActive = true
        totalScoreImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        totalScoreImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        totalScoreImageView.bottomAnchor.constraint(equalTo: totalScoreContainerView.bottomAnchor).isActive = true
        
        totalScoreContainerView.addSubview(totalScoreLabel)
        totalScoreLabel.centerYAnchor.constraint(equalTo: totalScoreImageView.centerYAnchor).isActive = true
        totalScoreLabel.leadingAnchor.constraint(equalTo: totalScoreImageView.trailingAnchor).isActive = true
        
        totalScoreContainerView.addSubview(totalScoreCntLabel)
        totalScoreCntLabel.centerYAnchor.constraint(equalTo: totalScoreImageView.centerYAnchor).isActive = true
        totalScoreCntLabel.leadingAnchor.constraint(equalTo: totalScoreLabel.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Score
        descContainerView.addSubview(scoreContainerView)
        scoreContainerView.topAnchor.constraint(equalTo: totalScoreContainerView.bottomAnchor, constant: SPACE_XXS).isActive = true
        scoreContainerView.leadingAnchor.constraint(equalTo: descContainerView.leadingAnchor).isActive = true
        scoreContainerView.trailingAnchor.constraint(equalTo: descContainerView.trailingAnchor).isActive = true
        
        scoreContainerView.addSubview(palaScoreTitleLabel)
        palaScoreTitleLabel.topAnchor.constraint(equalTo: scoreContainerView.topAnchor).isActive = true
        palaScoreTitleLabel.leadingAnchor.constraint(equalTo: scoreContainerView.leadingAnchor).isActive = true
        palaScoreTitleLabel.bottomAnchor.constraint(equalTo: scoreContainerView.bottomAnchor).isActive = true
        
        scoreContainerView.addSubview(palaScoreLabel)
        palaScoreLabel.centerYAnchor.constraint(equalTo: palaScoreTitleLabel.centerYAnchor).isActive = true
        palaScoreLabel.leadingAnchor.constraint(equalTo: palaScoreTitleLabel.trailingAnchor).isActive = true
        
        scoreContainerView.addSubview(palaLine)
        palaLine.leadingAnchor.constraint(equalTo: palaScoreLabel.trailingAnchor, constant: SPACE_XXS).isActive = true
        palaLine.topAnchor.constraint(equalTo: scoreContainerView.topAnchor, constant: SPACE_XXXXXS).isActive = true
        palaLine.bottomAnchor.constraint(equalTo: scoreContainerView.bottomAnchor, constant: -SPACE_XXXXXS).isActive = true
        
        scoreContainerView.addSubview(beneScoreTitleLabel)
        beneScoreTitleLabel.centerYAnchor.constraint(equalTo: palaScoreTitleLabel.centerYAnchor).isActive = true
        beneScoreTitleLabel.leadingAnchor.constraint(equalTo: palaLine.trailingAnchor, constant: SPACE_XXS).isActive = true
        
        scoreContainerView.addSubview(beneScoreLabel)
        beneScoreLabel.centerYAnchor.constraint(equalTo: palaScoreTitleLabel.centerYAnchor).isActive = true
        beneScoreLabel.leadingAnchor.constraint(equalTo: beneScoreTitleLabel.trailingAnchor).isActive = true
        
        scoreContainerView.addSubview(beneLine)
        beneLine.leadingAnchor.constraint(equalTo: beneScoreLabel.trailingAnchor, constant: SPACE_XXS).isActive = true
        beneLine.topAnchor.constraint(equalTo: scoreContainerView.topAnchor, constant: SPACE_XXXXXS).isActive = true
        beneLine.bottomAnchor.constraint(equalTo: scoreContainerView.bottomAnchor, constant: -SPACE_XXXXXS).isActive = true
        
        scoreContainerView.addSubview(costScoreTitleLabel)
        costScoreTitleLabel.centerYAnchor.constraint(equalTo: palaScoreTitleLabel.centerYAnchor).isActive = true
        costScoreTitleLabel.leadingAnchor.constraint(equalTo: beneLine.trailingAnchor, constant: SPACE_XXS).isActive = true
        
        scoreContainerView.addSubview(costScoreLabel)
        costScoreLabel.centerYAnchor.constraint(equalTo: palaScoreTitleLabel.centerYAnchor).isActive = true
        costScoreLabel.leadingAnchor.constraint(equalTo: costScoreTitleLabel.trailingAnchor).isActive = true
        
        descContainerView.addSubview(priceLabel)
        priceLabel.leadingAnchor.constraint(equalTo: descContainerView.leadingAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: descContainerView.trailingAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: descContainerView.bottomAnchor).isActive = true
        
        addSubview(bottomLine)
        bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func selfTapped() {
        guard let product = self.product else { return }
        delegate?.selectProduct(product: product)
    }
}
