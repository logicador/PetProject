//
//  ProductAllIngredientViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/15.
//

import UIKit


class ProductAllIngredientViewController: UIViewController {
    
    // MARK: Property
    
    
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
    
    lazy var warningStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var warningTitleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .warningColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var warningTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var goodStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var goodTitleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var goodTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var normalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var normalTitleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var normalTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "전체성분 살펴 보기"
        
        isModalInPresentation = true
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
        
        stackView.addArrangedSubview(warningStackView)
        warningStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        warningStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(goodStackView)
        goodStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        goodStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(normalStackView)
        normalStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        normalStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        warningStackView.addArrangedSubview(warningTitleContainerView)
        warningTitleContainerView.leadingAnchor.constraint(equalTo: warningStackView.leadingAnchor).isActive = true
        warningTitleContainerView.trailingAnchor.constraint(equalTo: warningStackView.trailingAnchor).isActive = true
        
        warningTitleContainerView.addSubview(warningTitleLabel)
        warningTitleLabel.topAnchor.constraint(equalTo: warningTitleContainerView.topAnchor, constant: SPACE_S).isActive = true
        warningTitleLabel.centerXAnchor.constraint(equalTo: warningTitleContainerView.centerXAnchor).isActive = true
        warningTitleLabel.widthAnchor.constraint(equalTo: warningTitleContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        warningTitleLabel.bottomAnchor.constraint(equalTo: warningTitleContainerView.bottomAnchor, constant: -SPACE_S).isActive = true
        
        goodStackView.addArrangedSubview(goodTitleContainerView)
        goodTitleContainerView.leadingAnchor.constraint(equalTo: goodStackView.leadingAnchor).isActive = true
        goodTitleContainerView.trailingAnchor.constraint(equalTo: goodStackView.trailingAnchor).isActive = true
        
        goodTitleContainerView.addSubview(goodTitleLabel)
        goodTitleLabel.topAnchor.constraint(equalTo: goodTitleContainerView.topAnchor, constant: SPACE_S).isActive = true
        goodTitleLabel.centerXAnchor.constraint(equalTo: goodTitleContainerView.centerXAnchor).isActive = true
        goodTitleLabel.widthAnchor.constraint(equalTo: goodTitleContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        goodTitleLabel.bottomAnchor.constraint(equalTo: goodTitleContainerView.bottomAnchor, constant: -SPACE_S).isActive = true
        
        normalStackView.addArrangedSubview(normalTitleContainerView)
        normalTitleContainerView.leadingAnchor.constraint(equalTo: normalStackView.leadingAnchor).isActive = true
        normalTitleContainerView.trailingAnchor.constraint(equalTo: normalStackView.trailingAnchor).isActive = true
        
        normalTitleContainerView.addSubview(normalTitleLabel)
        normalTitleLabel.topAnchor.constraint(equalTo: normalTitleContainerView.topAnchor, constant: SPACE_S).isActive = true
        normalTitleLabel.centerXAnchor.constraint(equalTo: normalTitleContainerView.centerXAnchor).isActive = true
        normalTitleLabel.widthAnchor.constraint(equalTo: normalTitleContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        normalTitleLabel.bottomAnchor.constraint(equalTo: normalTitleContainerView.bottomAnchor, constant: -SPACE_S).isActive = true
    }
    
    func configureIngredientView(productWarningFoodList: [Food], productWarningNutrientList: [Nutrient], productGoodFoodList: [Food], productGoodNutrientList: [Nutrient], productNormalFoodList: [Food], productNormalNutrientList: [Nutrient]) {
        
        configureView()
        
        for food in productWarningFoodList {
            let piv = ProductIngredientView(effect: "WARNING")
            piv.food = food

            warningStackView.addArrangedSubview(piv)
            piv.centerXAnchor.constraint(equalTo: warningStackView.centerXAnchor).isActive = true
            piv.widthAnchor.constraint(equalTo: warningStackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
            
            let lv = LineView()
            warningStackView.addArrangedSubview(lv)
            lv.leadingAnchor.constraint(equalTo: warningStackView.leadingAnchor).isActive = true
            lv.trailingAnchor.constraint(equalTo: warningStackView.trailingAnchor).isActive = true
        }
        
        for nutrient in productWarningNutrientList {
            let piv = ProductIngredientView(effect: "WARNING")
            piv.nutrient = nutrient

            warningStackView.addArrangedSubview(piv)
            piv.centerXAnchor.constraint(equalTo: warningStackView.centerXAnchor).isActive = true
            piv.widthAnchor.constraint(equalTo: warningStackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
            
            let lv = LineView()
            warningStackView.addArrangedSubview(lv)
            lv.leadingAnchor.constraint(equalTo: warningStackView.leadingAnchor).isActive = true
            lv.trailingAnchor.constraint(equalTo: warningStackView.trailingAnchor).isActive = true
        }
        
        if productWarningFoodList.count + productWarningNutrientList.count > 0 {
            warningStackView.subviews[warningStackView.subviews.count - 1].isHidden = true
        }
        
        for food in productGoodFoodList {
            let piv = ProductIngredientView(effect: "GOOD")
            piv.food = food

            goodStackView.addArrangedSubview(piv)
            piv.centerXAnchor.constraint(equalTo: goodStackView.centerXAnchor).isActive = true
            piv.widthAnchor.constraint(equalTo: goodStackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
            
            let lv = LineView()
            goodStackView.addArrangedSubview(lv)
            lv.leadingAnchor.constraint(equalTo: goodStackView.leadingAnchor).isActive = true
            lv.trailingAnchor.constraint(equalTo: goodStackView.trailingAnchor).isActive = true
        }
        
        for nutrient in productGoodNutrientList {
            let piv = ProductIngredientView(effect: "GOOD")
            piv.nutrient = nutrient

            goodStackView.addArrangedSubview(piv)
            piv.centerXAnchor.constraint(equalTo: goodStackView.centerXAnchor).isActive = true
            piv.widthAnchor.constraint(equalTo: goodStackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
            
            let lv = LineView()
            goodStackView.addArrangedSubview(lv)
            lv.leadingAnchor.constraint(equalTo: goodStackView.leadingAnchor).isActive = true
            lv.trailingAnchor.constraint(equalTo: goodStackView.trailingAnchor).isActive = true
        }
        
        if productGoodFoodList.count + productGoodNutrientList.count > 0 {
            goodStackView.subviews[goodStackView.subviews.count - 1].isHidden = true
        }
        
        for food in productNormalFoodList {
            let piv = ProductIngredientView()
            piv.food = food

            normalStackView.addArrangedSubview(piv)
            piv.centerXAnchor.constraint(equalTo: normalStackView.centerXAnchor).isActive = true
            piv.widthAnchor.constraint(equalTo: normalStackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
            
            let lv = LineView()
            normalStackView.addArrangedSubview(lv)
            lv.leadingAnchor.constraint(equalTo: normalStackView.leadingAnchor).isActive = true
            lv.trailingAnchor.constraint(equalTo: normalStackView.trailingAnchor).isActive = true
        }
        
        for nutrient in productNormalNutrientList {
            let piv = ProductIngredientView()
            piv.nutrient = nutrient

            normalStackView.addArrangedSubview(piv)
            piv.centerXAnchor.constraint(equalTo: normalStackView.centerXAnchor).isActive = true
            piv.widthAnchor.constraint(equalTo: normalStackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
            
            let lv = LineView()
            normalStackView.addArrangedSubview(lv)
            lv.leadingAnchor.constraint(equalTo: normalStackView.leadingAnchor).isActive = true
            lv.trailingAnchor.constraint(equalTo: normalStackView.trailingAnchor).isActive = true
        }
        
        if productNormalFoodList.count + productNormalNutrientList.count > 0 {
            normalStackView.subviews[normalStackView.subviews.count - 1].isHidden = true
        }
        
        warningTitleLabel.text = "주의성분 (\(productWarningFoodList.count + productWarningNutrientList.count))"
        goodTitleLabel.text = "긍정성분 (\(productGoodFoodList.count + productGoodNutrientList.count))"
        normalTitleLabel.text = "보통성분 (\(productNormalFoodList.count + productNormalNutrientList.count))"
    }
}
