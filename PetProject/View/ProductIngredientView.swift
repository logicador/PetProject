//
//  ProductIngredientView.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/13.
//

import UIKit


protocol ProductIngredientViewProtocol {
    func selectIngredient(nutrient: Nutrient?, food: Food?)
}


class ProductIngredientView: UIView {
    
    // MARK: Property
    var delegate: ProductIngredientViewProtocol?
    var nutrient: Nutrient? {
        didSet {
            guard let nutrient = self.nutrient else { return }
            
            nameLabel.text = nutrient.name
            descLabel.text = nutrient.descShort // desc descOver
        }
    }
    var food: Food? {
        didSet {
            guard let food = self.food else { return }
            
            nameLabel.text = food.name
            descLabel.text = food.descShort
        }
    }
    
    
    // MARK: View
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dotView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: Init
    init(effect: String = "NORMAL") {
        super.init(frame: .zero)
        
        if effect == "WARNING" {
            dotView.backgroundColor = .warningColor
        } else if effect == "GOOD" {
            dotView.backgroundColor = .mainColor
        } else {
            dotView.backgroundColor = .systemGray
        }
        
        configureView()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: SPACE_S).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SPACE_XS + 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE_S).isActive = true
        
        addSubview(dotView)
        dotView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dotView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        dotView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dotView.heightAnchor.constraint(equalToConstant: 8).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func selfTapped() {
        delegate?.selectIngredient(nutrient: nutrient, food: food)
    }
}
