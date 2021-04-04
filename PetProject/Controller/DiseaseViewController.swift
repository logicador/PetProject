//
//  DiseaseViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/17.
//

import UIKit


class DiseaseViewController: UIViewController {
    
    // MARK: Property
    var disease: Disease? {
        didSet {
            guard let disease = self.disease else { return }
            
            navigationItem.title = disease.name
            
            if let reason = disease.reason { reasonLabel.text = reason }
            if let management = disease.management { managementLabel.text = management }
            
            getDiseaseDetailRequest.fetch(vc: self, paramDict: ["dId": String(disease.id)])
        }
    }
    let getDiseaseDetailRequest = GetDiseaseDetailRequest()
    
    
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
    
    // MARK: View - Reason
    lazy var reasonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var reasonTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "발병 원인"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var reasonLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Management
    lazy var managementContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var managementTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "관리법"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var managementLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
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
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Food
    lazy var foodContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var foodTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "관련 음식"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var foodLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var consultingButton: ConfirmButton = {
        let cb = ConfirmButton(type: .system)
        cb.setActive(isActive: true)
        cb.setTitle("1:1 상담받기", for: .normal)
        cb.titleLabel?.font = .boldSystemFont(ofSize: 24)
        cb.addTarget(self, action: #selector(consultingTapped), for: .touchUpInside)
        return cb
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        getDiseaseDetailRequest.delegate = self
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
        
        // MARK: ConfigureView - Desc
        stackView.addArrangedSubview(reasonContainerView)
        reasonContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        reasonContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        reasonContainerView.addSubview(reasonTitleLabel)
        reasonTitleLabel.topAnchor.constraint(equalTo: reasonContainerView.topAnchor).isActive = true
        reasonTitleLabel.leadingAnchor.constraint(equalTo: reasonContainerView.leadingAnchor).isActive = true
        
        reasonContainerView.addSubview(reasonLabel)
        reasonLabel.topAnchor.constraint(equalTo: reasonTitleLabel.bottomAnchor, constant: SPACE).isActive = true
        reasonLabel.leadingAnchor.constraint(equalTo: reasonContainerView.leadingAnchor).isActive = true
        reasonLabel.trailingAnchor.constraint(equalTo: reasonContainerView.trailingAnchor).isActive = true
        reasonLabel.bottomAnchor.constraint(equalTo: reasonContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Management
        stackView.addArrangedSubview(managementContainerView)
        managementContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        managementContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        managementContainerView.addSubview(managementTitleLabel)
        managementTitleLabel.topAnchor.constraint(equalTo: managementContainerView.topAnchor).isActive = true
        managementTitleLabel.leadingAnchor.constraint(equalTo: managementContainerView.leadingAnchor).isActive = true
        
        managementContainerView.addSubview(managementLabel)
        managementLabel.topAnchor.constraint(equalTo: managementTitleLabel.bottomAnchor, constant: SPACE).isActive = true
        managementLabel.leadingAnchor.constraint(equalTo: managementContainerView.leadingAnchor).isActive = true
        managementLabel.trailingAnchor.constraint(equalTo: managementContainerView.trailingAnchor).isActive = true
        managementLabel.bottomAnchor.constraint(equalTo: managementContainerView.bottomAnchor).isActive = true
        
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
        
        // MARK: ConfigureView - Food
        stackView.addArrangedSubview(foodContainerView)
        foodContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        foodContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        foodContainerView.addSubview(foodTitleLabel)
        foodTitleLabel.topAnchor.constraint(equalTo: foodContainerView.topAnchor).isActive = true
        foodTitleLabel.leadingAnchor.constraint(equalTo: foodContainerView.leadingAnchor).isActive = true
        
        foodContainerView.addSubview(foodLabel)
        foodLabel.topAnchor.constraint(equalTo: foodTitleLabel.bottomAnchor, constant: SPACE).isActive = true
        foodLabel.leadingAnchor.constraint(equalTo: foodContainerView.leadingAnchor).isActive = true
        foodLabel.trailingAnchor.constraint(equalTo: foodContainerView.trailingAnchor).isActive = true
        foodLabel.bottomAnchor.constraint(equalTo: foodContainerView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(consultingButton)
        consultingButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        consultingButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        consultingButton.heightAnchor.constraint(equalToConstant: CONFIRM_BUTTON_HEIGHT).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func consultingTapped() {
        navigationController?.pushViewController(QuestionViewController(), animated: true)
    }
}


// MARK: HTTP - GetDiseaseDetail
extension DiseaseViewController: GetDiseaseDetailRequestProtocol {
    func response(disease: Disease?, foodList: [Food]?, symptomList: [Symptom]?, getDiseaseDetail status: String) {
        print("[HTTP RES]", getDiseaseDetailRequest.apiUrl, status)
        
        if status == "OK" {
//            guard let disease = disease else { return }
            guard let foodList = foodList else { return }
            guard let symptomList = symptomList else { return }
            
//            let foodList: [Food] = [
//                Food(id: 1, fc1Id: 1, fc2Id: 1, name: "귤", desc: "설명", thumbnail: "썸네일", edible: "Y", nutrientList: []),
//                Food(id: 2, fc1Id: 1, fc2Id: 1, name: "굴", desc: "설명", thumbnail: "썸네일", edible: "Y", nutrientList: []),
//                Food(id: 3, fc1Id: 1, fc2Id: 1, name: "피자", desc: "설명", thumbnail: "썸네일", edible: "Y", nutrientList: []),
//                Food(id: 4, fc1Id: 1, fc2Id: 1, name: "치킨", desc: "설명", thumbnail: "썸네일", edible: "Y", nutrientList: []),
//                Food(id: 5, fc1Id: 1, fc2Id: 1, name: "탕수육", desc: "설명", thumbnail: "썸네일", edible: "Y", nutrientList: [])
//            ]
            var foodString = ""
            for (i, food) in foodList.enumerated() {
                if i > 0 { foodString += "  " }
                foodString += "#\(food.name)"
            }
            foodLabel.text = foodString
            
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
