//
//  FoodViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/17.
//

import UIKit
import SDWebImage


class FoodViewController: UIViewController {
    
    // MARK: Property
    var food: Food? {
        didSet {
            guard let food = self.food else { return }
            
            navigationItem.title = food.name
            
            edibleLabel.textColor = (food.edible == "Y") ? .mainColor : .systemRed
            edibleLabel.text = (food.edible == "Y") ? "강아지는 \(food.name)를(을) 먹어도 됩니다." : "강아지는 \(food.name)를(을) 먹으면 안됩니다."
            
            if let desc = food.desc { descLabel.text = desc }
            
            getFoodDetailRequest.fetch(vc: self, paramDict: ["fId": String(food.id)])
            
            guard let thumbnail = food.thumbnail else { return }
            guard let url = URL(string: ADMIN_URL + thumbnail) else { return }
            thumbnailImageView.sd_setImage(with: url, completed: nil)
        }
    }
    let getFoodDetailRequest = GetFoodDetailRequest()
    
    
    // MARK: View
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
        sv.spacing = SPACE_XXXL
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .tertiarySystemGroupedBackground
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var edibleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Desc
    lazy var descContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var descTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "급여 방법 및 주의사항"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Nutrient
    lazy var nutrientContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var nutrientTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "관련 영양소"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var nutrientLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Disease
    lazy var diseaseContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var diseaseTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "관련 질병"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var diseaseLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Symptom
    lazy var symptomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var symptomTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "관련 증상"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var symptomLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureView()
        
        getFoodDetailRequest.delegate = self
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SCREEN_WIDTH * 0.06).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SPACE_XXXL).isActive = true
        
        stackView.addArrangedSubview(thumbnailImageView)
        thumbnailImageView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XXXXXXXS).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XXXXXXXS).isActive = true
        
        stackView.addArrangedSubview(edibleLabel)
        edibleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        edibleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        // MARK: ConfigureView - Desc
        stackView.addArrangedSubview(descContainerView)
        descContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        descContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        descContainerView.addSubview(descTitleLabel)
        descTitleLabel.topAnchor.constraint(equalTo: descContainerView.topAnchor).isActive = true
        descTitleLabel.leadingAnchor.constraint(equalTo: descContainerView.leadingAnchor).isActive = true
        
        descContainerView.addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: descTitleLabel.bottomAnchor, constant: SPACE).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: descContainerView.leadingAnchor).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: descContainerView.trailingAnchor).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: descContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Nutrient
        stackView.addArrangedSubview(nutrientContainerView)
        nutrientContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        nutrientContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        nutrientContainerView.addSubview(nutrientTitleLabel)
        nutrientTitleLabel.topAnchor.constraint(equalTo: nutrientContainerView.topAnchor).isActive = true
        nutrientTitleLabel.leadingAnchor.constraint(equalTo: nutrientContainerView.leadingAnchor).isActive = true
        
        nutrientContainerView.addSubview(nutrientLabel)
        nutrientLabel.topAnchor.constraint(equalTo: nutrientTitleLabel.bottomAnchor, constant: SPACE).isActive = true
        nutrientLabel.leadingAnchor.constraint(equalTo: nutrientContainerView.leadingAnchor).isActive = true
        nutrientLabel.trailingAnchor.constraint(equalTo: nutrientContainerView.trailingAnchor).isActive = true
        nutrientLabel.bottomAnchor.constraint(equalTo: nutrientContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Disease
        stackView.addArrangedSubview(diseaseContainerView)
        diseaseContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        diseaseContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        diseaseContainerView.addSubview(diseaseTitleLabel)
        diseaseTitleLabel.topAnchor.constraint(equalTo: diseaseContainerView.topAnchor).isActive = true
        diseaseTitleLabel.leadingAnchor.constraint(equalTo: diseaseContainerView.leadingAnchor).isActive = true
        
        diseaseContainerView.addSubview(diseaseLabel)
        diseaseLabel.topAnchor.constraint(equalTo: diseaseTitleLabel.bottomAnchor, constant: SPACE).isActive = true
        diseaseLabel.leadingAnchor.constraint(equalTo: diseaseContainerView.leadingAnchor).isActive = true
        diseaseLabel.trailingAnchor.constraint(equalTo: diseaseContainerView.trailingAnchor).isActive = true
        diseaseLabel.bottomAnchor.constraint(equalTo: diseaseContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Symptom
        stackView.addArrangedSubview(symptomContainerView)
        symptomContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        symptomContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        symptomContainerView.addSubview(symptomTitleLabel)
        symptomTitleLabel.topAnchor.constraint(equalTo: symptomContainerView.topAnchor).isActive = true
        symptomTitleLabel.leadingAnchor.constraint(equalTo: symptomContainerView.leadingAnchor).isActive = true
        
        symptomContainerView.addSubview(symptomLabel)
        symptomLabel.topAnchor.constraint(equalTo: symptomTitleLabel.bottomAnchor, constant: SPACE).isActive = true
        symptomLabel.leadingAnchor.constraint(equalTo: symptomContainerView.leadingAnchor).isActive = true
        symptomLabel.trailingAnchor.constraint(equalTo: symptomContainerView.trailingAnchor).isActive = true
        symptomLabel.bottomAnchor.constraint(equalTo: symptomContainerView.bottomAnchor).isActive = true
    }
}


// MARK: HTTP - GetFoodDetail
extension FoodViewController: GetFoodDetailRequestProtocol {
    func response(food: Food?, nutrientList: [Nutrient]?, diseaseList: [Disease]?, symptomList: [Symptom]?, getFoodDetail status: String) {
        print("[HTTP RES]", getFoodDetailRequest.apiUrl, status)
        
        if status == "OK" {
//            guard let food = food else { return }
            guard let nutrientList = nutrientList else { return }
            guard let diseaseList = diseaseList else { return }
            guard let symptomList = symptomList else { return }
            
            var nutrientString = ""
            for (i, nutrient) in nutrientList.enumerated() {
                if i > 0 { nutrientString += "  " }
                nutrientString += "#\(nutrient.name)"
            }
            nutrientLabel.text = nutrientString
            
//            let diseaseList: [Disease] = [
//                Disease(id: 1, bpId: 1, name: "감기", reason: "원인", management: "관리법", operation: "N", cnt: 10),
//                Disease(id: 2, bpId: 2, name: "당뇨", reason: "원인", management: "관리법", operation: "N", cnt: 8),
//                Disease(id: 3, bpId: 3, name: "심장질환", reason: "원인", management: "관리법", operation: "N", cnt: 5),
//                Disease(id: 4, bpId: 4, name: "탈골", reason: "원인", management: "관리법", operation: "N", cnt: 3),
//                Disease(id: 5, bpId: 5, name: "슬개골탈구", reason: "원인", management: "관리법", operation: "N", cnt: 2)
//            ]
            var diseaseString = ""
            for (i, disease) in diseaseList.enumerated() {
                if i > 0 { diseaseString += "  " }
                diseaseString += "#\(disease.name)"
            }
            diseaseLabel.text = diseaseString
            
//            let symptomList: [Symptom] = [
//                Symptom(id: 1, bpId: 1, name: "발작"),
//                Symptom(id: 2, bpId: 1, name: "역류"),
//                Symptom(id: 3, bpId: 1, name: "비틀거림"),
//                Symptom(id: 4, bpId: 1, name: "탈수"),
//                Symptom(id: 5, bpId: 1, name: "재채기를 해요.")
//            ]
            var symptomString = ""
            for (i, symptom) in symptomList.enumerated() {
                if i > 0 { symptomString += "  " }
                symptomString += "#\(symptom.name)"
            }
            symptomLabel.text = symptomString
        }
    }
}
