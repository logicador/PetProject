//
//  SymptomViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/17.
//

import UIKit


class SymptomViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var symptom: Symptom? {
        didSet {
            guard let symptom = self.symptom else { return }
            
            navigationItem.title = symptom.name
            
            let titleMabs = NSMutableAttributedString()
                .thin("\(app.getPetName())와(과) 유사한 조건의\n반려동물을 분석한 결과,\n", fontSize: 24)
                .bold("[\(symptom.name)]", fontSize: 24)
                .thin(" 증상으로 가장 의심되는\n질병 리스트입니다.", fontSize: 24)
            titleLabel.attributedText = titleMabs
            
            getSymptomDetailRequest.fetch(vc: self, paramDict: ["sId": String(symptom.id), "peId": String(app.getPetId())])
        }
    }
    let getSymptomDetailRequest = GetSymptomDetailRequest()
    
    
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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Graph
    lazy var graphContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "통계"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Disease
    lazy var diseaseContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var diseaseTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "질병 검색결과"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var diseaseStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
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
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
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
        
        getSymptomDetailRequest.delegate = self
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SPACE_XXXL).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SPACE_XXXL).isActive = true
        
        stackView.addArrangedSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        // MARK: ConfigureView - Graph
        stackView.addArrangedSubview(graphContainerView)
        graphContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        graphContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        graphContainerView.addSubview(graphTitleLabel)
        graphTitleLabel.topAnchor.constraint(equalTo: graphContainerView.topAnchor).isActive = true
        graphTitleLabel.leadingAnchor.constraint(equalTo: graphContainerView.leadingAnchor).isActive = true
        
        graphContainerView.addSubview(graphStackView)
        graphStackView.topAnchor.constraint(equalTo: graphTitleLabel.bottomAnchor, constant: SPACE).isActive = true
        graphStackView.leadingAnchor.constraint(equalTo: graphContainerView.leadingAnchor).isActive = true
        graphStackView.trailingAnchor.constraint(equalTo: graphContainerView.trailingAnchor).isActive = true
        graphStackView.bottomAnchor.constraint(equalTo: graphContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Disease
        stackView.addArrangedSubview(diseaseContainerView)
        diseaseContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        diseaseContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        diseaseContainerView.addSubview(diseaseTitleLabel)
        diseaseTitleLabel.topAnchor.constraint(equalTo: diseaseContainerView.topAnchor).isActive = true
        diseaseTitleLabel.leadingAnchor.constraint(equalTo: diseaseContainerView.leadingAnchor).isActive = true
        
        diseaseContainerView.addSubview(diseaseStackView)
        diseaseStackView.topAnchor.constraint(equalTo: diseaseTitleLabel.bottomAnchor, constant: SPACE).isActive = true
        diseaseStackView.leadingAnchor.constraint(equalTo: diseaseContainerView.leadingAnchor).isActive = true
        diseaseStackView.trailingAnchor.constraint(equalTo: diseaseContainerView.trailingAnchor).isActive = true
        diseaseStackView.bottomAnchor.constraint(equalTo: diseaseContainerView.bottomAnchor).isActive = true
        
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
extension SymptomViewController: GetSymptomDetailRequestProtocol {
    func response(similarCnt: Int?, symptom: Symptom?, foodList: [Food]?, diseaseList: [Disease]?, getSymptomDetail status: String) {
        print("[HTTP RES]", getSymptomDetailRequest.apiUrl, status)
        
        if status == "OK" {
//                guard let symptom = symptom else { return }
            guard let similarCnt = similarCnt else { return }
            guard let foodList = foodList else { return }
            guard let diseaseList = diseaseList else { return }
            
//            let diseaseList: [Disease] = [
//                Disease(id: 1, bpId: 1, name: "감기",  reason: "원인", management: "관리법", operation: "N", cnt: 10),
//                Disease(id: 2, bpId: 2, name: "당뇨", reason: "원인", management: "관리법", operation: "N", cnt: 8),
//                Disease(id: 3, bpId: 3, name: "심장질환", reason: "원인", management: "관리법", operation: "N", cnt: 5),
//                Disease(id: 4, bpId: 4, name: "탈골", reason: "원인", management: "관리법", operation: "N", cnt: 3),
//                Disease(id: 5, bpId: 5, name: "슬개골탈구", reason: "원인", management: "관리법", operation: "N", cnt: 2)
//            ]
            for disease in diseaseList {
                let dgv = DiseaseGraphView(similarCnt: similarCnt, disease: disease)
                graphStackView.addArrangedSubview(dgv)
                dgv.leadingAnchor.constraint(equalTo: graphStackView.leadingAnchor).isActive = true
                dgv.trailingAnchor.constraint(equalTo: graphStackView.trailingAnchor).isActive = true
                
                let dv = DiseaseView()
                dv.disease = disease
                diseaseStackView.addArrangedSubview(dv)
                dv.leadingAnchor.constraint(equalTo: diseaseStackView.leadingAnchor).isActive = true
                dv.trailingAnchor.constraint(equalTo: diseaseStackView.trailingAnchor).isActive = true
            }
            
//            let foodList: [Food] = [
//                Food(id: 1, fc1Id: 1, fc2Id: 1, name: "시금치", edible: "Y"),
//                Food(id: 2, fc1Id: 1, fc2Id: 1, name: "연어", edible: "Y"),
//                Food(id: 3, fc1Id: 1, fc2Id: 1, name: "두부", edible: "Y"),
//                Food(id: 4, fc1Id: 1, fc2Id: 1, name: "검은콩", edible: "Y"),
//                Food(id: 5, fc1Id: 1, fc2Id: 1, name: "장어", edible: "Y")
//            ]
            var foodString = ""
            for (i, food) in foodList.enumerated() {
                if i > 0 { foodString += "  " }
                foodString += "#\(food.name)"
            }
            foodLabel.text = foodString
        }
    }
}
