//
//  PetEtcViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import UIKit


protocol PetEtcViewControllerProtocol {
    func savePet()
}


class PetEtcViewController: UIViewController {
    
    // MARK: Property
    var delegate: PetEtcViewControllerProtocol?
    let app = App()
    var selectedFeed: Product?
    var selectedSnack: Product?
    var selectedDiseaseList: [Disease] = []
    var selectedAllergyList: [FoodCategory2] = []
    let selectDiseaseVC = SelectDiseaseViewController()
    let selectAllergyVC = SelectAllergyViewController()
    let uploadImageRequest = UploadImageRequest()
    let savePetRequest = SavePetRequest()
    
    var peId: Int?
    var thumbnail = ""
    var thumb: UIImage?
    var name: String?
    var birth: Int?
    var bId: Int?
    var gender: String?
    var weight: Double?
    var bcs: Int?
    var neuter: String?
    var inoculation: String?
    var inoculationText: String?
    var serial: String?
    var serialNo: String?
    var inoculationIdList: [Int] = []
    var feedPId: Int?
    var snackPId: Int?
    var diseaseIdList: [Int] = []
    var allergyIdList: [Int] = []
    
    
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
        sv.spacing = SPACE
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = SPACE_XXS
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var containerStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XXL
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Serial
    lazy var serialContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var serialLabel: UILabel = {
        let label = UILabel()
        label.text = "동물등록번호"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var serialButtonContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.cornerRadius = SPACE_XXS
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var serialNButton: ToggleButton = {
        let button = ToggleButton(type: .system)
        button.setTitle("없음", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tag = 1
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(serialTapped), for: .touchUpInside)
        return button
    }()
    lazy var serialDButton: ToggleButton = {
        let button = ToggleButton(type: .system)
        button.setTitle("모름", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tag = 2
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(serialTapped), for: .touchUpInside)
        return button
    }()
    lazy var serialNoPetInputView: PetInputView = {
        let piv = PetInputView(labelText: "", placeholder: "번호를 입력해주세요.")
        piv.delegate = self
        return piv
    }()
    
    lazy var feedPetInputView: PetInputView = {
        let piv = PetInputView(labelText: "급여중인 사료", placeholder: "선택", isSelectMode: true, actionMode: "SELECT_FEED")
        piv.delegate = self
        return piv
    }()
    
    lazy var snackPetInputView: PetInputView = {
        let piv = PetInputView(labelText: "급여중인 간식", placeholder: "선택", isSelectMode: true, actionMode: "SELECT_SNACK")
        piv.delegate = self
        return piv
    }()
    
    lazy var diseasePetInputView: PetInputView = {
        let piv = PetInputView(labelText: "병력", placeholder: "선택", isSelectMode: true, actionMode: "SELECT_DISEASE")
        piv.delegate = self
        return piv
    }()
    
    lazy var allergyPetInputView: PetInputView = {
        let piv = PetInputView(labelText: "알레르기", placeholder: "선택", isSelectMode: true, actionMode: "SELECT_ALLERGY")
        piv.delegate = self
        return piv
    }()
    
    lazy var nextButton: ConfirmButton = {
        let cb = ConfirmButton(type: .system)
        cb.setTitle("입력 완료", for: .normal)
        cb.titleLabel?.font = .boldSystemFont(ofSize: 24)
        cb.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return cb
    }()
    
    // MARK: view - Indicator
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
        
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        title = "반려동물 기타 정보"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        hideKeyboardWhenTappedAround()
        
        selectDiseaseVC.delegate = self
        selectAllergyVC.delegate = self
        uploadImageRequest.delegate = self
        savePetRequest.delegate = self
        
        // MARK: For DEV_DEBUG
//        serialNoPetInputView.textField.text = "123456789"
//        selectedFeed = Product(id: 6, pcId: 1, pbId: 1, name: "TEST_6", price: 50000, thumbnail: "", origin: "", manufacturer: "", packingVolume: "", recommend: "", totalScore: 0, createdDate: "", updatedDate: "", fnProt: 1, fnFat: 5, fnFibe: 2, fnAsh: 3, fnCalc: 5, fnPhos: 2, fnMois: 10)
//        selectedSnack = Product(id: 8, pcId: 2, pbId: 1, name: "TEST_9", price: 1234, thumbnail: "", origin: "", manufacturer: "", packingVolume: "", recommend: "", totalScore: 0, createdDate: "", updatedDate: "")
//        selectedDiseaseList = [
//            Disease(id: 1, bpId: 1, name: "", reason: "", management: "", operation: ""),
//            Disease(id: 3, bpId: 1, name: "", reason: "", management: "", operation: ""),
//            Disease(id: 4, bpId: 1, name: "", reason: "", management: "", operation: ""),
//            Disease(id: 13, bpId: 2, name: "", reason: "", management: "", operation: "")
//        ]
//        selectedAllergyList = [
//            FoodCategory2(id: 14, fc1Id: 7, name: ""),
//            FoodCategory2(id: 16, fc1Id: 9, name: ""),
//            FoodCategory2(id: 24, fc1Id: 10, name: "")
//        ]
//        nextButton.setActive(isActive: true)
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: (SCREEN_WIDTH * 0.06)).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -(SCREEN_WIDTH * 0.12)).isActive = true
        
        stackView.addArrangedSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        
        containerView.addSubview(containerStackView)
        containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: SPACE_XXL).isActive = true
        containerStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        containerStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -SPACE_XXL).isActive = true
        
        containerStackView.addArrangedSubview(serialContainerView)
        serialContainerView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        serialContainerView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        serialContainerView.addSubview(serialButtonContainerView)
        serialButtonContainerView.topAnchor.constraint(equalTo: serialContainerView.topAnchor).isActive = true
        serialButtonContainerView.trailingAnchor.constraint(equalTo: serialContainerView.trailingAnchor).isActive = true
        serialButtonContainerView.widthAnchor.constraint(equalTo: serialContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XXXXXXXXS).isActive = true
        
        serialButtonContainerView.addSubview(serialNButton)
        serialNButton.topAnchor.constraint(equalTo: serialButtonContainerView.topAnchor).isActive = true
        serialNButton.trailingAnchor.constraint(equalTo: serialButtonContainerView.trailingAnchor).isActive = true
        serialNButton.widthAnchor.constraint(equalTo: serialButtonContainerView.widthAnchor, multiplier: 0.5).isActive = true
        serialNButton.bottomAnchor.constraint(equalTo: serialButtonContainerView.bottomAnchor).isActive = true
        
        serialButtonContainerView.addSubview(serialDButton)
        serialDButton.topAnchor.constraint(equalTo: serialButtonContainerView.topAnchor).isActive = true
        serialDButton.leadingAnchor.constraint(equalTo: serialButtonContainerView.leadingAnchor).isActive = true
        serialDButton.widthAnchor.constraint(equalTo: serialButtonContainerView.widthAnchor, multiplier: 0.5).isActive = true
        serialDButton.bottomAnchor.constraint(equalTo: serialButtonContainerView.bottomAnchor).isActive = true
        
        serialContainerView.addSubview(serialLabel)
        serialLabel.leadingAnchor.constraint(equalTo: serialContainerView.leadingAnchor).isActive = true
        serialLabel.centerYAnchor.constraint(equalTo: serialButtonContainerView.centerYAnchor).isActive = true
        
        serialContainerView.addSubview(serialNoPetInputView)
        serialNoPetInputView.topAnchor.constraint(equalTo: serialButtonContainerView.bottomAnchor, constant: SPACE).isActive = true
        serialNoPetInputView.leadingAnchor.constraint(equalTo: serialContainerView.leadingAnchor).isActive = true
        serialNoPetInputView.trailingAnchor.constraint(equalTo: serialContainerView.trailingAnchor).isActive = true
        serialNoPetInputView.bottomAnchor.constraint(equalTo: serialContainerView.bottomAnchor).isActive = true
        
        containerStackView.addArrangedSubview(feedPetInputView)
        feedPetInputView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        feedPetInputView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        containerStackView.addArrangedSubview(snackPetInputView)
        snackPetInputView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        snackPetInputView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        containerStackView.addArrangedSubview(diseasePetInputView)
        diseasePetInputView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        diseasePetInputView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        containerStackView.addArrangedSubview(allergyPetInputView)
        allergyPetInputView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        allergyPetInputView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(nextButton)
        nextButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: CONFIRM_BUTTON_HEIGHT).isActive = true
    }
    
    // MARK: Function - CheckIsValid
    func checkIsValid() {
        guard let serialNo = serialNoPetInputView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            nextButton.setActive(isActive: false)
            return
        }
        
        if serialNButton.backgroundColor == .white && serialDButton.backgroundColor == .white && serialNo.isEmpty {
            nextButton.setActive(isActive: false)
            return
        }
        
        // 동물등록번호 1-20(1-30)
        if !serialNo.isEmpty && !isValidString(min: 1, utf8Min: 1, max: 20, utf8Max: 30, value: serialNo) {
            nextButton.setActive(isActive: false)
            return
        }
        
        nextButton.setActive(isActive: true)
    }
    
    // MARK: Function - AddPet
    func addPet(thumb: UIImage?, name: String, birth: String, breed: Breed, gender: String, weight: Double?, bcs: Bcs, neuter: String, inoculation: String, inoculationList: [Inoculation], inoculationKindEtcText: String) {
        let serial = (serialNButton.backgroundColor == .mainColor) ? "N" : ((serialDButton.backgroundColor == .mainColor) ? "D" : "Y")
        guard let serialNo = serialNoPetInputView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        inoculationIdList.removeAll()
        diseaseIdList.removeAll()
        allergyIdList.removeAll()
        
        self.name = name
        self.birth = Int(birth)
        self.bId = breed.id
        self.gender = gender
        self.weight = weight
        self.bcs = bcs.step
        self.neuter = neuter
        self.inoculation = inoculation
        self.inoculationText = inoculationKindEtcText
        self.serial = serial
        self.serialNo = serialNo
        if let selectedFeed = self.selectedFeed { self.feedPId = selectedFeed.id }
        if let selectedSnack = self.selectedSnack { self.snackPId = selectedSnack.id }
        
        for inoculation in inoculationList { inoculationIdList.append(inoculation.id) }
        for disease in selectedDiseaseList { diseaseIdList.append(disease.id) }
        for allergy in selectedAllergyList { allergyIdList.append(allergy.id) }
        
        if thumb == nil {
            savePetRequest.fetch(vc: self, paramDict: getPetParamDict())
        } else {
            uploadImageRequest.fetch(vc: self, image: thumb)
        }
    }
    
    // MARK: Function - GetPetParamDict
    func getPetParamDict() -> [String: String] {
        var paramDict: [String: String] = [:]
        
        paramDict["thumbnail"] = thumbnail
        paramDict["name"] = name
        if let birth = self.birth { paramDict["birth"] = String(birth) }
        if let bId = self.bId { paramDict["bId"] = String(bId) }
        paramDict["gender"] = gender
        if let weight = self.weight { paramDict["weight"] = String(weight) }
        if let bcs = self.bcs { paramDict["bcs"] = String(bcs) }
        paramDict["neuter"] = neuter
        paramDict["inoculation"] = inoculation
        paramDict["inoculationText"] = inoculationText
        paramDict["serial"] = serial
        paramDict["serialNo"] = serialNo
        if let feedPId = self.feedPId { paramDict["feedPId"] = String(feedPId) }
        if let snackPId = self.snackPId { paramDict["snackPId"] = String(snackPId) }
        paramDict["inoculationIdList"] = inoculationIdList.description
        paramDict["diseaseIdList"] = diseaseIdList.description
        paramDict["allergyIdList"] = allergyIdList.description
        if let peId = self.peId { paramDict["peId"] = String(peId) }
        
        return paramDict
    }
    
    // MARK: Function - @OBJC
    @objc func serialTapped(sender: UIButton) {
        dismissKeyboard()
        
        if sender.tag == 1 {
            if serialNButton.backgroundColor == .mainColor { serialNButton.setSelect(isSelected: false) }
            else { serialNButton.setSelect(isSelected: true) }
            serialDButton.setSelect(isSelected: false)
            
        } else {
            if serialDButton.backgroundColor == .mainColor { serialDButton.setSelect(isSelected: false) }
            else { serialDButton.setSelect(isSelected: true) }
            serialNButton.setSelect(isSelected: false)
        }
        
        serialNoPetInputView.textField.text = ""
        checkIsValid()
    }
    
    @objc func nextTapped() {
        dismissKeyboard()
        
        if !nextButton.isActive { return }
        
        let alert = UIAlertController(title: "펫 저장하기", message: "모든 입력이 완료되었습니다. 펫을 저장하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel))
        alert.addAction(UIAlertAction(title: "예", style: UIAlertAction.Style.default, handler: { (_) in
            self.showIndicator(idv: self.indicatorView, bov: self.blurOverlayView)
            self.delegate?.savePet()
        }))
        present(alert, animated: true)
    }
}


// MARK: PetInputView
extension PetEtcViewController: PetInputViewProtocol {
    func action(actionMode: String) {
        dismissKeyboard()
        
        if actionMode == "SELECT_FEED" {
            let searchProductVC = SearchProductViewController()
            searchProductVC.pcId = 1
            searchProductVC.delegate = self
            navigationController?.pushViewController(searchProductVC, animated: true)
            
        } else if actionMode == "SELECT_SNACK" {
            let searchProductVC = SearchProductViewController()
            searchProductVC.pcId = 2
            searchProductVC.delegate = self
            navigationController?.pushViewController(searchProductVC, animated: true)
            
        } else if actionMode == "SELECT_DISEASE" {
            navigationController?.pushViewController(selectDiseaseVC, animated: true)
            
        } else if actionMode == "SELECT_ALLERGY" {
            navigationController?.pushViewController(selectAllergyVC, animated: true)
        }
    }
    
    func textChanged() {
        serialNButton.setSelect(isSelected: false)
        serialDButton.setSelect(isSelected: false)
        checkIsValid()
    }
}

// MARK: SearchFeedVC
extension PetEtcViewController: SearchProductViewControllerProtocol {
    func selectProduct(product: Product) {
        if product.pcId == 1 {
            selectedFeed = product
            feedPetInputView.textField.text = product.name
            
        } else if product.pcId == 2 {
            selectedSnack = product
            snackPetInputView.textField.text = product.name
        }
        
        checkIsValid()
    }
}

// MARK: SelectDiseaseVC
extension PetEtcViewController: SelectDiseaseViewControllerProtocol {
    func selectDiseaseList(diseaseList: [Disease]) {
        selectedDiseaseList = diseaseList
        if diseaseList.count > 0 {
            diseasePetInputView.textField.text = diseaseList[0].name
            if diseaseList.count > 1 {
                diseasePetInputView.textField.text = rangeString(len: 16, value: "\(diseaseList[0].name), \(diseaseList[1].name)", isDot: true)
                if diseaseList.count > 2 {
                    diseasePetInputView.textField.text = "\(rangeString(len: 14, value: "\(diseaseList[0].name), \(diseaseList[1].name)"))...\(diseaseList.count)개"
                }
            }
        } else {
            diseasePetInputView.textField.text = ""
        }
    }
}

// MARK: SelectAllergyVC
extension PetEtcViewController: SelectAllergyViewControllerProtocol {
    func selectAllergyList(allergyList: [FoodCategory2]) {
        selectedAllergyList = allergyList
        if allergyList.count > 0 {
            allergyPetInputView.textField.text = allergyList[0].name
            if allergyList.count > 1 {
                allergyPetInputView.textField.text = rangeString(len: 16, value: "\(allergyList[0].name), \(allergyList[1].name)", isDot: true)
                if allergyList.count > 2 {
                    allergyPetInputView.textField.text = "\(rangeString(len: 14, value: "\(allergyList[0].name), \(allergyList[1].name)"))...\(allergyList.count)개"
                }
            }
        } else {
            allergyPetInputView.textField.text = ""
        }
    }
}

// MARK: HTTP - UploadImage
extension PetEtcViewController: UploadImageRequestProtocol {
    func response(imageName: Int?, uploadImage status: String) {
        print("[HTTP RES]", uploadImageRequest.apiUrl, status)
        
        if status == "OK" {
            guard let imageName = imageName else { return }
            thumbnail = "/images/users/\(app.getUserId())/\(imageName).jpg"
            savePetRequest.fetch(vc: self, paramDict: getPetParamDict())
            
        } else { hideIndicator(idv: indicatorView, bov: blurOverlayView) }
    }
}

// MARK: HTTP - SavePet
extension PetEtcViewController: SavePetRequestProtocol {
    func response(pet: Pet?, savePet status: String) {
        print("[HTTP RES]", savePetRequest.apiUrl, status)
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
        
        if status == "OK" {
            guard let pet = pet else { return }
            self.peId = pet.id
            
            let petFinishVC = PetFinishViewController()
            petFinishVC.modalPresentationStyle = .fullScreen
            present(petFinishVC, animated: true, completion: nil)
        }
    }
}
