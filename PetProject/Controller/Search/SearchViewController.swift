//
//  SearchViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/11.
//

import UIKit


class SearchViewController: UIViewController {
    
    // MARK: Property
    var selectedTab: String = "FOOD" {
        didSet {
            if selectedTab == "FOOD" {
                tabSpaceBottomLine.layer.borderColor = UIColor.separator.cgColor
                
                if searchTextContainerView.isHidden {
                    searchTextContainerView.isHidden = false
                    searchSymptomLabel.isHidden = true
                    searchSymptomLabel.alpha = 0
                    UIView.animate(withDuration: 0.2, animations: { self.searchTextContainerView.alpha = 1 })
                }
                
                if foodScrollView.isHidden {
                    foodScrollView.isHidden = false
                    diseaseScrollView.isHidden = true
                    diseaseScrollView.alpha = 0
                    symptomScrollView.isHidden = true
                    symptomScrollView.alpha = 0
                    UIView.animate(withDuration: 0.2, animations: { self.foodScrollView.alpha = 1 })
                }
                
                tabFoodButton.tintColor = .mainColor
                tabDiseaseButton.tintColor = .systemGray2
                tabSymptomButton.tintColor = .systemGray2
                search()
                
            } else if selectedTab == "DISEASE" {
                tabSpaceBottomLine.layer.borderColor = UIColor.separator.cgColor
                
                if searchTextContainerView.isHidden {
                    searchTextContainerView.isHidden = false
                    searchSymptomLabel.isHidden = true
                    searchSymptomLabel.alpha = 0
                    UIView.animate(withDuration: 0.2, animations: { self.searchTextContainerView.alpha = 1 })
                }
                
                if diseaseScrollView.isHidden {
                    foodScrollView.isHidden = true
                    foodScrollView.alpha = 0
                    diseaseScrollView.isHidden = false
                    symptomScrollView.isHidden = true
                    symptomScrollView.alpha = 0
                    UIView.animate(withDuration: 0.2, animations: { self.diseaseScrollView.alpha = 1 })
                }
                
                // MARK: For DEV_DEBUG
//                searchTextField.text = "감기"
                
                tabFoodButton.tintColor = .systemGray2
                tabDiseaseButton.tintColor = .mainColor
                tabSymptomButton.tintColor = .systemGray2
                search()
                
            } else {
                tabSpaceBottomLine.layer.borderColor = UIColor.tertiarySystemGroupedBackground.cgColor
                
                if searchSymptomLabel.isHidden {
                    searchSymptomLabel.isHidden = false
                    searchTextContainerView.isHidden = true
                    searchTextContainerView.alpha = 0
                    UIView.animate(withDuration: 0.2, animations: { self.searchSymptomLabel.alpha = 1 })
                }
                
                if symptomScrollView.isHidden {
                    foodScrollView.isHidden = true
                    foodScrollView.alpha = 0
                    diseaseScrollView.isHidden = true
                    diseaseScrollView.alpha = 0
                    symptomScrollView.isHidden = false
                    UIView.animate(withDuration: 0.2, animations: { self.symptomScrollView.alpha = 1 })
                }
                
                tabFoodButton.tintColor = .systemGray2
                tabDiseaseButton.tintColor = .systemGray2
                tabSymptomButton.tintColor = .mainColor
            }
        }
    }
    var bodyPartList = BODYPARTS
    let getSymptomsRequest = GetSymptomsRequest()
    let getDiseasesRequest = GetDiseasesRequest()
    let getFoodsRequest = GetFoodsRequest()
    
    
    // MARK: View
    lazy var headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var searchTextContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XXXS
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이곳에 검색어를 입력해주세요."
        tf.font = .systemFont(ofSize: 16)
        tf.addTarget(self, action: #selector(searchChanged), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var searchImageView: UIImageView = {
        let img = UIImage(systemName: "magnifyingglass")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .mainColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var searchSymptomLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.isHidden = true
        label.text = "아래 항목에서 관련 질환을 선택하세요."
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Tab
    lazy var tabContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var tabFoodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("음식", for: .normal)
        button.tintColor = .mainColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tag = 1
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(tabTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var tabDiseaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("질병", for: .normal)
        button.tintColor = .systemGray2
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.tag = 2
        button.addTarget(self, action: #selector(tabTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var tabSymptomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("증상", for: .normal)
        button.tintColor = .systemGray2
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.tag = 3
        button.addTarget(self, action: #selector(tabTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var tabLeftLine: LineView = {
        let lv = LineView(orientation: .vertical, width: 2)
        return lv
    }()
    lazy var tabRightLine: LineView = {
        let lv = LineView(orientation: .vertical, width: 2)
        return lv
    }()
    lazy var tabBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var tabSpaceView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var tabSpaceBottomLine: LineView = {
        let lv = LineView()
        return lv
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
    
    // MARK: View - Food
    lazy var foodScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.isHidden = true
        sv.alpha = 0
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var foodStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Disease
    lazy var diseaseScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.isHidden = true
        sv.alpha = 0
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
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
    
    // MARK: View - Symptom
    lazy var symptomScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.isHidden = true
        sv.alpha = 0
        sv.backgroundColor = .tertiarySystemGroupedBackground
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var symptomStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Indicator
    lazy var indicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.style = .large
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    lazy var blurOverlayView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let vev = UIVisualEffectView(effect: blurEffect)
        vev.alpha = 0.3
        vev.translatesAutoresizingMaskIntoConstraints = false
        return vev
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "검색"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        hideKeyboardWhenTappedAround()
        
        getSymptomsRequest.delegate = self
        getDiseasesRequest.delegate = self
        getFoodsRequest.delegate = self
        
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        getSymptomsRequest.fetch(vc: self, paramDict: [:])
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(headerContainerView)
        headerContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        headerContainerView.addSubview(searchContainerView)
        searchContainerView.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        searchContainerView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        searchContainerView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        
        searchContainerView.addSubview(searchTextContainerView)
        searchTextContainerView.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: SPACE).isActive = true
        searchTextContainerView.centerXAnchor.constraint(equalTo: searchContainerView.centerXAnchor).isActive = true
        searchTextContainerView.widthAnchor.constraint(equalTo: searchContainerView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        searchTextContainerView.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -SPACE).isActive = true
        
        searchTextContainerView.addSubview(searchTextField)
        searchTextField.topAnchor.constraint(equalTo: searchTextContainerView.topAnchor, constant: 8).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: searchTextContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: searchTextContainerView.trailingAnchor, constant: -(SPACE_S + 18 + SPACE_S)).isActive = true
        searchTextField.bottomAnchor.constraint(equalTo: searchTextContainerView.bottomAnchor, constant: -8).isActive = true
        
        searchTextContainerView.addSubview(searchImageView)
        searchImageView.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor).isActive = true
        searchImageView.trailingAnchor.constraint(equalTo: searchTextContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        searchImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        searchImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        searchContainerView.addSubview(searchSymptomLabel)
        searchSymptomLabel.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: SPACE).isActive = true
        searchSymptomLabel.centerXAnchor.constraint(equalTo: searchContainerView.centerXAnchor).isActive = true
        searchSymptomLabel.widthAnchor.constraint(equalTo: searchContainerView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        searchSymptomLabel.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -SPACE).isActive = true
        
        // MARK: ConfigureView - Tab
        headerContainerView.addSubview(tabContainerView)
        tabContainerView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor).isActive = true
        tabContainerView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        tabContainerView.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor).isActive = true
        
        tabContainerView.addSubview(tabFoodButton)
        tabFoodButton.topAnchor.constraint(equalTo: tabContainerView.topAnchor).isActive = true
        tabFoodButton.leadingAnchor.constraint(equalTo: tabContainerView.leadingAnchor).isActive = true
        tabFoodButton.widthAnchor.constraint(equalTo: tabContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        tabFoodButton.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        
        tabContainerView.addSubview(tabDiseaseButton)
        tabDiseaseButton.topAnchor.constraint(equalTo: tabContainerView.topAnchor).isActive = true
        tabDiseaseButton.centerXAnchor.constraint(equalTo: tabContainerView.centerXAnchor).isActive = true
        tabDiseaseButton.widthAnchor.constraint(equalTo: tabContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        tabDiseaseButton.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        
        tabContainerView.addSubview(tabSymptomButton)
        tabSymptomButton.topAnchor.constraint(equalTo: tabContainerView.topAnchor).isActive = true
        tabSymptomButton.trailingAnchor.constraint(equalTo: tabContainerView.trailingAnchor).isActive = true
        tabSymptomButton.widthAnchor.constraint(equalTo: tabContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        tabSymptomButton.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        
        tabContainerView.addSubview(tabLeftLine)
        tabLeftLine.leadingAnchor.constraint(equalTo: tabDiseaseButton.leadingAnchor).isActive = true
        tabLeftLine.topAnchor.constraint(equalTo: tabContainerView.topAnchor, constant: SPACE_XS + SPACE_XXXXS).isActive = true
        tabLeftLine.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor, constant: -(SPACE_XS + SPACE_XXXXS)).isActive = true
        
        tabContainerView.addSubview(tabRightLine)
        tabRightLine.trailingAnchor.constraint(equalTo: tabDiseaseButton.trailingAnchor).isActive = true
        tabRightLine.topAnchor.constraint(equalTo: tabContainerView.topAnchor, constant: SPACE_XS + SPACE_XXXXS).isActive = true
        tabRightLine.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor, constant: -(SPACE_XS + SPACE_XXXXS)).isActive = true
        
        headerContainerView.addSubview(tabBottomLine)
        tabBottomLine.topAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        tabBottomLine.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        tabBottomLine.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        
        headerContainerView.addSubview(tabSpaceView)
        tabSpaceView.topAnchor.constraint(equalTo: tabBottomLine.bottomAnchor).isActive = true
        tabSpaceView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        tabSpaceView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        tabSpaceView.heightAnchor.constraint(equalToConstant: SPACE_XS).isActive = true
        
        headerContainerView.addSubview(tabSpaceBottomLine)
        tabSpaceBottomLine.topAnchor.constraint(equalTo: tabSpaceView.bottomAnchor).isActive = true
        tabSpaceBottomLine.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        tabSpaceBottomLine.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        tabSpaceBottomLine.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true
        
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Food
        stackView.addArrangedSubview(foodScrollView)
        foodScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        foodScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        foodScrollView.addSubview(foodStackView)
        foodStackView.topAnchor.constraint(equalTo: foodScrollView.topAnchor, constant: (SCREEN_WIDTH * 0.06)).isActive = true
        foodStackView.leadingAnchor.constraint(equalTo: foodScrollView.leadingAnchor).isActive = true
        foodStackView.trailingAnchor.constraint(equalTo: foodScrollView.trailingAnchor).isActive = true
        foodStackView.widthAnchor.constraint(equalTo: foodScrollView.widthAnchor).isActive = true
        foodStackView.bottomAnchor.constraint(equalTo: foodScrollView.bottomAnchor, constant: -(SCREEN_WIDTH * 0.12)).isActive = true
        
        // MARK: ConfigureView - Disease
        stackView.addArrangedSubview(diseaseScrollView)
        diseaseScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        diseaseScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        diseaseScrollView.addSubview(diseaseStackView)
        diseaseStackView.topAnchor.constraint(equalTo: diseaseScrollView.topAnchor, constant: (SCREEN_WIDTH * 0.06)).isActive = true
        diseaseStackView.leadingAnchor.constraint(equalTo: diseaseScrollView.leadingAnchor).isActive = true
        diseaseStackView.trailingAnchor.constraint(equalTo: diseaseScrollView.trailingAnchor).isActive = true
        diseaseStackView.widthAnchor.constraint(equalTo: diseaseScrollView.widthAnchor).isActive = true
        diseaseStackView.bottomAnchor.constraint(equalTo: diseaseScrollView.bottomAnchor, constant: -(SCREEN_WIDTH * 0.12)).isActive = true
        
        // MARK: ConfigureView - Symptom
        stackView.addArrangedSubview(symptomScrollView)
        symptomScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        symptomScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        symptomScrollView.addSubview(symptomStackView)
        symptomStackView.topAnchor.constraint(equalTo: symptomScrollView.topAnchor, constant: (SCREEN_WIDTH * 0.06)).isActive = true
        symptomStackView.leadingAnchor.constraint(equalTo: symptomScrollView.leadingAnchor).isActive = true
        symptomStackView.trailingAnchor.constraint(equalTo: symptomScrollView.trailingAnchor).isActive = true
        symptomStackView.widthAnchor.constraint(equalTo: symptomScrollView.widthAnchor).isActive = true
        symptomStackView.bottomAnchor.constraint(equalTo: symptomScrollView.bottomAnchor, constant: -(SCREEN_WIDTH * 0.12)).isActive = true
    }
    
    func search() {
        guard let keyword = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if keyword.count < 1 { return }
        let wordList = Array(keyword)
        for word in wordList {
            if KOR_CHAR_LIST.contains(word) { return }
        }
        
        if selectedTab == "FOOD" {
            getFoodsRequest.fetch(vc: self, paramDict: ["keyword": keyword])
        } else if selectedTab == "DISEASE" {
            getDiseasesRequest.fetch(vc: self, paramDict: ["keyword": keyword])
        }
    }
    
    // MARK: Function - @OBJC
    @objc func tabTapped(sender: UIButton) {
        dismissKeyboard()
        
        if sender.tag == 1 { selectedTab = "FOOD" }
        else if sender.tag == 2 { selectedTab = "DISEASE" }
        else { selectedTab = "SYMPTOM" }
    }
    
    @objc func searchChanged() {
        search()
    }
}


// MARK: HTTP - GetSymptoms
extension SearchViewController: GetSymptomsRequestProtocol {
    func response(symptomList: [Symptom]?, getSymptoms status: String) {
        print("[HTTP RES]", getSymptomsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let symptomList = symptomList else { return }
            for symptom in symptomList {
                for (i, bodyPart) in bodyPartList.enumerated() {
                    if symptom.bpId == bodyPart.id {
                        bodyPartList[i].symptomList.append(symptom)
                        break
                    }
                }
            }
            
            for (i, bodyPart) in bodyPartList.enumerated() {
                var indexItemList: [IndexItem] = []
                for (j, symptom) in bodyPart.symptomList.enumerated() {
                    let indexItem = IndexItem(index: j, name: symptom.name)
                    indexItemList.append(indexItem)
                }
                
                let ov = OpenView(index: i)
                ov.delegate = self
                ov.indexItemList = indexItemList
                ov.label.text = "\(bodyPart.name)(\(bodyPart.symptomList.count))"
                symptomStackView.addArrangedSubview(ov)
                ov.centerXAnchor.constraint(equalTo: symptomStackView.centerXAnchor).isActive = true
                ov.widthAnchor.constraint(equalTo: symptomStackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
            }
        }
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
    }
}

// MARK: HTTP - GetFoods
extension SearchViewController: GetFoodsRequestProtocol {
    func response(foodList: [Food]?, getFoods status: String) {
        print("[HTTP RES]", getFoodsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let foodList = foodList else { return }
            foodStackView.removeAllChildView()
            
            for food in foodList {
                let fv = FoodView()
                fv.food = food
                fv.delegate = self
                foodStackView.addArrangedSubview(fv)
                fv.centerXAnchor.constraint(equalTo: foodStackView.centerXAnchor).isActive = true
                fv.widthAnchor.constraint(equalTo: foodStackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
            }
        }
    }
}

// MARK: HTTP - GetDiseases
extension SearchViewController: GetDiseasesRequestProtocol {
    func response(diseaseList: [Disease]?, getDiseases status: String) {
        print("[HTTP RES]", getDiseasesRequest.apiUrl, status)
        
        if status == "OK" {
            guard let diseaseList = diseaseList else { return }
            diseaseStackView.removeAllChildView()
            
            for disease in diseaseList {
                let dv = DiseaseView()
                dv.disease = disease
                dv.delegate = self
                diseaseStackView.addArrangedSubview(dv)
                dv.centerXAnchor.constraint(equalTo: diseaseStackView.centerXAnchor).isActive = true
                dv.widthAnchor.constraint(equalTo: diseaseStackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
            }
        }
    }
}

// MARK: OpenView
extension SearchViewController: OpenViewProtocol {
    func apply(index: Int, isApplied: Bool, indexItem: IndexItem) {
        let symptom = bodyPartList[index].symptomList[indexItem.index]
        
        let ov = symptomStackView.subviews[index] as! OpenView
        let cell = ov.collectionView.cellForItem(at: IndexPath(row: indexItem.index, section: 0)) as! ToggleCVCell
        cell.isApplied = false
        
        let symptomVC = SymptomViewController()
        symptomVC.symptom = symptom
        navigationController?.pushViewController(symptomVC, animated: true)
    }
}

// MARK: FoodView
extension SearchViewController: FoodViewProtocol {
    func selectFood(food: Food) {
        dismissKeyboard()
        
        let foodVC = FoodViewController()
        foodVC.food = food
        navigationController?.pushViewController(foodVC, animated: true)
    }
}

// MARK: DiseaseView
extension SearchViewController: DiseaseViewProtocol {
    func selectDisease(disease: Disease) {
        dismissKeyboard()
        
        let diseaseVC = DiseaseViewController()
        diseaseVC.disease = disease
        navigationController?.pushViewController(diseaseVC, animated: true)
    }
}
