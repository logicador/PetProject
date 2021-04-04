//
//  PetHealthViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit
import AlignedCollectionViewFlowLayout


protocol PetHealthViewControllerProtocol {
    func savePet()
}


class PetHealthViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var delegate: PetHealthViewControllerProtocol?
    var inoculationKindCollectionViewHeightCons: NSLayoutConstraint?
    var inoculationList: [Inoculation] = []
    let getInoculationsRequest = GetInoculationsRequest()
    let selectBcsVC = SelectBcsViewController()
    var selectedBcs: Bcs?
    let petEtcVC = PetEtcViewController()
    let getPetInoculationsRequest = GetPetInoculationsRequest()
    var selectedInoculationList: [Inoculation] = []
    var isEditMode: Bool = false {
        didSet {
            if isEditMode {
                let pet = app.getPet()
                weightPetInputView.textField.text = String(pet.weight)
                selectedBcs = Bcs(step: pet.bcsStep, visually: "", touch: "")
                bcsPetInputView.textField.text = "\(pet.bcsStep)단계"
                
                if pet.neuter == "Y" {
                    neuterYButton.setSelect(isSelected: true)
                } else if pet.neuter == "N" {
                    neuterNButton.setSelect(isSelected: true)
                } else {
                    neuterDButton.setSelect(isSelected: true)
                }
                
                if pet.inoculation == "Y" {
                    inoculationKindContainerView.isHidden = false
                    inoculationYButton.setSelect(isSelected: true)
                    
                    if let inoculationText = pet.inoculationText {
                        inoculationKindEtcCheckView.backgroundColor = .mainColor
                        inoculationKindEtcTextField.text = inoculationText
                    }
                    
                } else if pet.inoculation == "N" {
                    inoculationNButton.setSelect(isSelected: true)
                } else {
                    inoculationDButton.setSelect(isSelected: true)
                }
                
                nextButton.setActive(isActive: true)
            }
        }
    }
    
    
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
    
    lazy var weightPetInputView: PetInputView = {
        let piv = PetInputView(labelText: "체중(kg/선택)", placeholder: "체중 입력")
        piv.textField.keyboardType = .decimalPad
        piv.delegate = self
        return piv
    }()
    lazy var bcsPetInputView: PetInputView = {
        let piv = PetInputView(labelText: "신체지수", placeholder: "선택", isSelectMode: true, actionMode: "SELECT_BCS")
        piv.delegate = self
        return piv
    }()
    
    // MARK: View - Neuter
    lazy var neuterContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var neuterLabel: UILabel = {
        let label = UILabel()
        label.text = "중성화수술 여부"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var neuterButtonContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.cornerRadius = SPACE_XXS
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var neuterYButton: ToggleButton = {
        let button = ToggleButton(type: .system)
        button.setTitle("예", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tag = 1
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(neuterTapped), for: .touchUpInside)
        return button
    }()
    lazy var neuterNButton: ToggleButton = {
        let button = ToggleButton(type: .system)
        button.setTitle("아니오", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tag = 2
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(neuterTapped), for: .touchUpInside)
        return button
    }()
    lazy var neuterDButton: ToggleButton = {
        let button = ToggleButton(type: .system)
        button.setTitle("모름", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tag = 3
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(neuterTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: View - Inoculation
    lazy var inoculationContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var inoculationLabel: UILabel = {
        let label = UILabel()
        label.text = "기초접종 여부"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var inoculationButtonContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.cornerRadius = SPACE_XXS
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var inoculationYButton: ToggleButton = {
        let button = ToggleButton(type: .system)
        button.setTitle("예", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tag = 1
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(inoculationTapped), for: .touchUpInside)
        return button
    }()
    lazy var inoculationNButton: ToggleButton = {
        let button = ToggleButton(type: .system)
        button.setTitle("아니오", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tag = 2
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(inoculationTapped), for: .touchUpInside)
        return button
    }()
    lazy var inoculationDButton: ToggleButton = {
        let button = ToggleButton(type: .system)
        button.setTitle("모름", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tag = 3
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(inoculationTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var inoculationKindContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var inoculationKindLabel: UILabel = {
        let label = UILabel()
        label.text = "기초접종 종류"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var inoculationKindSubLabel: UILabel = {
        let label = UILabel()
        label.text = "(중복 선택 가능)"
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var inoculationKindCollectionView: UICollectionView = {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        layout.minimumInteritemSpacing = SPACE_XXL
        layout.minimumLineSpacing = SPACE_S
        layout.estimatedItemSize = CGSize(width: 100, height: 40)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(InoculationCVCell.self, forCellWithReuseIdentifier: "InoculationCVCell")
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    lazy var inoculationKindEtcContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var inoculationKindEtcCheckView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = SPACE_XXXS
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var inoculationKindEtcLabel: UILabel = {
        let label = UILabel()
        label.text = "직접 입력"
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var inoculationKindEtcTextContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var inoculationKindEtcTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 18)
        tf.addTarget(self, action: #selector(inoculationKindEtcChanged), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var inoculationKindEtcBottomLine: LineView = {
        let lv = LineView(width: 1, color: .black)
        return lv
    }()
    
    lazy var nextButton: ConfirmButton = {
        let cb = ConfirmButton(type: .system)
        cb.setTitle("입력 완료", for: .normal)
        cb.titleLabel?.font = .boldSystemFont(ofSize: 24)
        cb.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return cb
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        title = "반려동물 건강 정보"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureView()
        
        hideKeyboardWhenTappedAround()
        
        getInoculationsRequest.delegate = self
        selectBcsVC.delegate = self
        petEtcVC.delegate = self
        getPetInoculationsRequest.delegate = self
        
        petEtcVC.isEditMode = isEditMode
        
        getInoculationsRequest.fetch(vc: self, paramDict: [:])
        
        // MARK: For DEV_DEBUG
//        weightPetInputView.textField.text = "6.24"
//        bcsPetInputView.textField.text = "1단계"
//        selectedBcs = Bcs(step: 1, visually: "갈비뼈, 요추, 골반뼈가 모두 겉으로 드러나고, 지방과 근육이 없는 게 보임", touch: "갈비뼈, 요추, 골반뼈가 모두 겉으로 드러나고, 지방과 근육이 없는 게 보임")
//        neuterYButton.setSelect(isSelected: true)
//        inoculationNButton.setSelect(isSelected: true)
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
        
        containerStackView.addArrangedSubview(weightPetInputView)
        weightPetInputView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        weightPetInputView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        containerStackView.addArrangedSubview(bcsPetInputView)
        bcsPetInputView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        bcsPetInputView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Neuter
        containerStackView.addArrangedSubview(neuterContainerView)
        neuterContainerView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        neuterContainerView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        neuterContainerView.addSubview(neuterLabel)
        neuterLabel.topAnchor.constraint(equalTo: neuterContainerView.topAnchor).isActive = true
        neuterLabel.leadingAnchor.constraint(equalTo: neuterContainerView.leadingAnchor).isActive = true
        
        neuterContainerView.addSubview(neuterButtonContainerView)
        neuterButtonContainerView.topAnchor.constraint(equalTo: neuterLabel.bottomAnchor, constant: SPACE_S).isActive = true
        neuterButtonContainerView.leadingAnchor.constraint(equalTo: neuterContainerView.leadingAnchor).isActive = true
        neuterButtonContainerView.trailingAnchor.constraint(equalTo: neuterContainerView.trailingAnchor).isActive = true
        neuterButtonContainerView.bottomAnchor.constraint(equalTo: neuterContainerView.bottomAnchor).isActive = true
        
        neuterButtonContainerView.addSubview(neuterYButton)
        neuterYButton.topAnchor.constraint(equalTo: neuterButtonContainerView.topAnchor).isActive = true
        neuterYButton.leadingAnchor.constraint(equalTo: neuterButtonContainerView.leadingAnchor).isActive = true
        neuterYButton.widthAnchor.constraint(equalTo: neuterButtonContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        neuterYButton.bottomAnchor.constraint(equalTo: neuterButtonContainerView.bottomAnchor).isActive = true
        
        neuterButtonContainerView.addSubview(neuterNButton)
        neuterNButton.topAnchor.constraint(equalTo: neuterButtonContainerView.topAnchor).isActive = true
        neuterNButton.centerXAnchor.constraint(equalTo: neuterButtonContainerView.centerXAnchor).isActive = true
        neuterNButton.widthAnchor.constraint(equalTo: neuterButtonContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        neuterNButton.bottomAnchor.constraint(equalTo: neuterButtonContainerView.bottomAnchor).isActive = true
        
        neuterButtonContainerView.addSubview(neuterDButton)
        neuterDButton.topAnchor.constraint(equalTo: neuterButtonContainerView.topAnchor).isActive = true
        neuterDButton.trailingAnchor.constraint(equalTo: neuterButtonContainerView.trailingAnchor).isActive = true
        neuterDButton.widthAnchor.constraint(equalTo: neuterButtonContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        neuterDButton.bottomAnchor.constraint(equalTo: neuterButtonContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Inoculation
        containerStackView.addArrangedSubview(inoculationContainerView)
        inoculationContainerView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        inoculationContainerView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        inoculationContainerView.addSubview(inoculationLabel)
        inoculationLabel.topAnchor.constraint(equalTo: inoculationContainerView.topAnchor).isActive = true
        inoculationLabel.leadingAnchor.constraint(equalTo: inoculationContainerView.leadingAnchor).isActive = true
        
        inoculationContainerView.addSubview(inoculationButtonContainerView)
        inoculationButtonContainerView.topAnchor.constraint(equalTo: inoculationLabel.bottomAnchor, constant: SPACE_S).isActive = true
        inoculationButtonContainerView.leadingAnchor.constraint(equalTo: inoculationContainerView.leadingAnchor).isActive = true
        inoculationButtonContainerView.trailingAnchor.constraint(equalTo: inoculationContainerView.trailingAnchor).isActive = true
        inoculationButtonContainerView.bottomAnchor.constraint(equalTo: inoculationContainerView.bottomAnchor).isActive = true
        
        inoculationButtonContainerView.addSubview(inoculationYButton)
        inoculationYButton.topAnchor.constraint(equalTo: inoculationButtonContainerView.topAnchor).isActive = true
        inoculationYButton.leadingAnchor.constraint(equalTo: inoculationButtonContainerView.leadingAnchor).isActive = true
        inoculationYButton.widthAnchor.constraint(equalTo: inoculationButtonContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        inoculationYButton.bottomAnchor.constraint(equalTo: inoculationButtonContainerView.bottomAnchor).isActive = true
        
        inoculationButtonContainerView.addSubview(inoculationNButton)
        inoculationNButton.topAnchor.constraint(equalTo: inoculationButtonContainerView.topAnchor).isActive = true
        inoculationNButton.centerXAnchor.constraint(equalTo: inoculationButtonContainerView.centerXAnchor).isActive = true
        inoculationNButton.widthAnchor.constraint(equalTo: inoculationButtonContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        inoculationNButton.bottomAnchor.constraint(equalTo: inoculationButtonContainerView.bottomAnchor).isActive = true
        
        inoculationButtonContainerView.addSubview(inoculationDButton)
        inoculationDButton.topAnchor.constraint(equalTo: inoculationButtonContainerView.topAnchor).isActive = true
        inoculationDButton.trailingAnchor.constraint(equalTo: inoculationButtonContainerView.trailingAnchor).isActive = true
        inoculationDButton.widthAnchor.constraint(equalTo: inoculationButtonContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        inoculationDButton.bottomAnchor.constraint(equalTo: inoculationButtonContainerView.bottomAnchor).isActive = true
        
        containerStackView.addArrangedSubview(inoculationKindContainerView)
        inoculationKindContainerView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        inoculationKindContainerView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        inoculationKindContainerView.addSubview(inoculationKindLabel)
        inoculationKindLabel.topAnchor.constraint(equalTo: inoculationKindContainerView.topAnchor).isActive = true
        inoculationKindLabel.leadingAnchor.constraint(equalTo: inoculationKindContainerView.leadingAnchor).isActive = true
        
        inoculationKindContainerView.addSubview(inoculationKindSubLabel)
        inoculationKindSubLabel.leadingAnchor.constraint(equalTo: inoculationKindLabel.trailingAnchor, constant: SPACE_XS).isActive = true
        inoculationKindSubLabel.centerYAnchor.constraint(equalTo: inoculationKindLabel.centerYAnchor).isActive = true
        
        inoculationKindContainerView.addSubview(inoculationKindCollectionView)
        inoculationKindCollectionView.topAnchor.constraint(equalTo: inoculationKindLabel.bottomAnchor, constant: SPACE_S).isActive = true
        inoculationKindCollectionView.leadingAnchor.constraint(equalTo: inoculationKindContainerView.leadingAnchor).isActive = true
        inoculationKindCollectionView.trailingAnchor.constraint(equalTo: inoculationKindContainerView.trailingAnchor).isActive = true
        inoculationKindCollectionViewHeightCons = inoculationKindCollectionView.heightAnchor.constraint(equalToConstant: 1000)
        inoculationKindCollectionViewHeightCons?.isActive = true
        
        inoculationKindContainerView.addSubview(inoculationKindEtcContainerView)
        inoculationKindEtcContainerView.topAnchor.constraint(equalTo: inoculationKindCollectionView.bottomAnchor, constant: SPACE_S).isActive = true
        inoculationKindEtcContainerView.leadingAnchor.constraint(equalTo: inoculationKindContainerView.leadingAnchor).isActive = true
        inoculationKindEtcContainerView.trailingAnchor.constraint(equalTo: inoculationKindContainerView.trailingAnchor).isActive = true
        inoculationKindEtcContainerView.bottomAnchor.constraint(equalTo: inoculationKindContainerView.bottomAnchor).isActive = true
        
        inoculationKindEtcContainerView.addSubview(inoculationKindEtcCheckView)
        inoculationKindEtcCheckView.topAnchor.constraint(equalTo: inoculationKindEtcContainerView.topAnchor).isActive = true
        inoculationKindEtcCheckView.leadingAnchor.constraint(equalTo: inoculationKindEtcContainerView.leadingAnchor).isActive = true
        inoculationKindEtcCheckView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        inoculationKindEtcCheckView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        inoculationKindEtcCheckView.bottomAnchor.constraint(equalTo: inoculationKindEtcContainerView.bottomAnchor).isActive = true
        
        inoculationKindEtcContainerView.addSubview(inoculationKindEtcLabel)
        inoculationKindEtcLabel.centerYAnchor.constraint(equalTo: inoculationKindEtcCheckView.centerYAnchor).isActive = true
        inoculationKindEtcLabel.leadingAnchor.constraint(equalTo: inoculationKindEtcCheckView.trailingAnchor, constant: SPACE_S).isActive = true
        
        inoculationKindEtcContainerView.addSubview(inoculationKindEtcTextContainerView)
        inoculationKindEtcTextContainerView.topAnchor.constraint(equalTo: inoculationKindEtcContainerView.topAnchor).isActive = true
        inoculationKindEtcTextContainerView.trailingAnchor.constraint(equalTo: inoculationKindEtcContainerView.trailingAnchor).isActive = true
        inoculationKindEtcTextContainerView.bottomAnchor.constraint(equalTo: inoculationKindEtcContainerView.bottomAnchor).isActive = true
        
        inoculationKindEtcTextContainerView.addSubview(inoculationKindEtcTextField)
        inoculationKindEtcTextField.topAnchor.constraint(equalTo: inoculationKindEtcTextContainerView.topAnchor).isActive = true
        inoculationKindEtcTextField.leadingAnchor.constraint(equalTo: inoculationKindEtcTextContainerView.leadingAnchor).isActive = true
        inoculationKindEtcTextField.trailingAnchor.constraint(equalTo: inoculationKindEtcTextContainerView.trailingAnchor).isActive = true
        inoculationKindEtcTextField.bottomAnchor.constraint(equalTo: inoculationKindEtcTextContainerView.bottomAnchor).isActive = true
        
        inoculationKindEtcTextContainerView.addSubview(inoculationKindEtcBottomLine)
        inoculationKindEtcBottomLine.bottomAnchor.constraint(equalTo: inoculationKindEtcTextContainerView.bottomAnchor).isActive = true
        inoculationKindEtcBottomLine.leadingAnchor.constraint(equalTo: inoculationKindEtcTextContainerView.leadingAnchor).isActive = true
        inoculationKindEtcBottomLine.trailingAnchor.constraint(equalTo: inoculationKindEtcTextContainerView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(nextButton)
        nextButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: CONFIRM_BUTTON_HEIGHT).isActive = true
    }
    
    // MARK: Function - checkIsValid
    func checkIsValid() {
        guard let weight = weightPetInputView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            nextButton.setActive(isActive: false)
            return
        }
        guard let bcs = bcsPetInputView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            nextButton.setActive(isActive: false)
            return
        }
        guard let inoculationKindEtcText = inoculationKindEtcTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            nextButton.setActive(isActive: false)
            return
        }
        
        // 체중을 입력했을때 유효성 검사
        let weightRegEx = "(^[0-9]+$)|(^[0-9]{1,}.[0-9]+$)"
        let weightTest = NSPredicate(format: "SELF MATCHES %@", weightRegEx)
        if !weight.isEmpty {
            if !weightTest.evaluate(with: weight) {
                nextButton.setActive(isActive: false)
                return
            }
            if let weightDouble = Double(weight) {
                if weightDouble > 999 { // 최대 999까지
                    nextButton.setActive(isActive: false)
                    return
                }
            } else {
                nextButton.setActive(isActive: false)
                return
            }
        }
        
        // 신체지수 선택 체크
        if selectedBcs == nil || bcs.isEmpty {
            nextButton.setActive(isActive: false)
            return
        }
        
        // 중성화수술 체크
        if neuterYButton.backgroundColor == .white && neuterNButton.backgroundColor == .white && neuterDButton.backgroundColor == .white {
            nextButton.setActive(isActive: false)
            return
        }
        
        // 기초접종 체크
        if inoculationYButton.backgroundColor == .white && inoculationNButton.backgroundColor == .white && inoculationDButton.backgroundColor == .white {
            nextButton.setActive(isActive: false)
            return
        }
        
        // 기초접종 직접입력 1-30(1-50)
        if !inoculationKindEtcText.isEmpty && !isValidString(min: 1, utf8Min: 1, max: 30, utf8Max: 50, value: inoculationKindEtcText) {
            nextButton.setActive(isActive: false)
            return
        }
        
        nextButton.setActive(isActive: true)
    }
    
    func addPet(thumb: UIImage?, name: String, birth: String, breed: Breed, gender: String, isThumbnailChanged: Bool) {
        var weight: Double?
        guard let _weight = weightPetInputView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if !_weight.isEmpty { weight = Double(_weight) }
        guard let bcs = selectedBcs else { return }
        let neuter = (neuterYButton.backgroundColor == .mainColor) ? "Y" : ((neuterNButton.backgroundColor == .mainColor) ? "N" : "D")
        let inoculation = (inoculationYButton.backgroundColor == .mainColor) ? "Y" : ((inoculationNButton.backgroundColor == .mainColor) ? "N" : "D")
        guard let inoculationKindEtcText = inoculationKindEtcTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
    
        petEtcVC.addPet(thumb: thumb, name: name, birth: birth, breed: breed, gender: gender, weight: weight, bcs: bcs, neuter: neuter, inoculation: inoculation, inoculationList: selectedInoculationList, inoculationKindEtcText: inoculationKindEtcText, isThumbnailChanged: isThumbnailChanged)
    }
    
//    override func viewDidLayoutSubviews() {
//        inoculationKindCollectionViewHeightCons?.isActive = false
//        inoculationKindCollectionViewHeightCons = inoculationKindCollectionView.heightAnchor.constraint(equalToConstant: inoculationKindCollectionView.contentSize.height)
//        inoculationKindCollectionViewHeightCons?.isActive = true
//    }
    
    // MARK: Function - @OBJC
    @objc func keyboardWillShow(notification: NSNotification) {
        if inoculationKindEtcTextField.isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height - (SCREEN_WIDTH * 0.12)
                }
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func inoculationKindEtcChanged() {
        guard let text = inoculationKindEtcTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if text.count > 0 {
            inoculationKindEtcCheckView.backgroundColor = .mainColor
        } else {
            inoculationKindEtcCheckView.backgroundColor = .white
        }
    }
    
    @objc func neuterTapped(sender: UIButton) {
        dismissKeyboard()
        
        if sender.tag == 1 {
            neuterYButton.setSelect(isSelected: true)
            neuterNButton.setSelect(isSelected: false)
            neuterDButton.setSelect(isSelected: false)
        } else if sender.tag == 2 {
            neuterYButton.setSelect(isSelected: false)
            neuterNButton.setSelect(isSelected: true)
            neuterDButton.setSelect(isSelected: false)
        } else {
            neuterYButton.setSelect(isSelected: false)
            neuterNButton.setSelect(isSelected: false)
            neuterDButton.setSelect(isSelected: true)
        }
        
        checkIsValid()
    }
    
    @objc func inoculationTapped(sender: UIButton) {
        dismissKeyboard()
        
        if sender.tag == 1 {
            if inoculationYButton.backgroundColor == .mainColor { return }
            inoculationKindContainerView.isHidden = false
            
            inoculationYButton.setSelect(isSelected: true)
            inoculationNButton.setSelect(isSelected: false)
            inoculationDButton.setSelect(isSelected: false)
            
        } else if sender.tag == 2 {
            if inoculationNButton.backgroundColor == .mainColor { return }
            if inoculationYButton.backgroundColor == .mainColor { inoculationKindContainerView.isHidden = true }
            
            inoculationYButton.setSelect(isSelected: false)
            inoculationNButton.setSelect(isSelected: true)
            inoculationDButton.setSelect(isSelected: false)
            
        } else {
            if inoculationDButton.backgroundColor == .mainColor { return }
            if inoculationYButton.backgroundColor == .mainColor { inoculationKindContainerView.isHidden = true }
            
            inoculationYButton.setSelect(isSelected: false)
            inoculationNButton.setSelect(isSelected: false)
            inoculationDButton.setSelect(isSelected: true)
        }
        
        checkIsValid()
    }
    
    @objc func nextTapped() {
        dismissKeyboard()
        
        if !nextButton.isActive { return }
        
        navigationController?.pushViewController(petEtcVC, animated: true)
    }
}

// MARK: PetInputView
extension PetHealthViewController: PetInputViewProtocol {
    func action(actionMode: String) {
        dismissKeyboard()
        if actionMode == "SELECT_BCS" {
            navigationController?.pushViewController(selectBcsVC, animated: true)
        }
    }
    
    func textChanged() {
        checkIsValid()
    }
}

// MARK: CollectionView
extension PetHealthViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inoculationList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InoculationCVCell", for: indexPath) as! InoculationCVCell
        cell.delegate = self
        cell.inoculation = inoculationList[indexPath.row]
        return cell
    }
}

// MARK: HTTP - GetInoculations
extension PetHealthViewController: GetInoculationsRequestProtocol {
    func response(inoculationList: [Inoculation]?, getInoculations status: String) {
        print("[HTTP RES]", getInoculationsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let inoculationList = inoculationList else { return }
            self.inoculationList = inoculationList
            inoculationKindCollectionView.reloadData()
            
            inoculationKindEtcTextContainerView.leadingAnchor.constraint(equalTo: inoculationKindEtcContainerView.leadingAnchor, constant: inoculationKindEtcLabel.frame.size.width + (SPACE_S * 2) + 28).isActive = true
            
            inoculationKindCollectionView.performBatchUpdates(nil, completion: { (_) in
                self.inoculationKindCollectionViewHeightCons?.isActive = false
                self.inoculationKindCollectionViewHeightCons = self.inoculationKindCollectionView.heightAnchor.constraint(equalToConstant: self.inoculationKindCollectionView.contentSize.height)
                self.inoculationKindCollectionViewHeightCons?.isActive = true
                
                if self.isEditMode {
                    let pet = self.app.getPet()
                    if pet.inoculation == "Y" {
                        self.getPetInoculationsRequest.fetch(vc: self, paramDict: ["peId": String(pet.id)])
                    }
                }
            })
        }
    }
}

// MARK: SelectBcsVC
extension PetHealthViewController: SelectBcsViewControllerProtocol {
    func selectBcs(isSelected: Bool, bcs: Bcs) {
        if isSelected {
            selectedBcs = bcs
            bcsPetInputView.textField.text = "\(bcs.step)단계"
        } else {
            selectedBcs = nil
            bcsPetInputView.textField.text = ""
        }
        
        checkIsValid()
    }
}

// MARK: PetEtcVC
extension PetHealthViewController: PetEtcViewControllerProtocol {
    func savePet() {
        delegate?.savePet()
    }
}

// MARK: InoculationCVCell
extension PetHealthViewController: InoculationCVCellProtocol {
    func check(isChecked: Bool, inoculation: Inoculation) {
        if isChecked {
            selectedInoculationList.append(inoculation)
        } else {
            for (i, selectedInoculation) in selectedInoculationList.enumerated() {
                if selectedInoculation.id == inoculation.id {
                    selectedInoculationList.remove(at: i)
                    break
                }
            }
        }
    }
}

// MARK: HTTP - GetPetInoculations
extension PetHealthViewController: GetPetInoculationsRequestProtocol {
    func response(inoculationList: [Inoculation]?, getPetInoculations status: String) {
        print("[HTTP RES]", getPetInoculationsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let inoculationList = inoculationList else { return }
            selectedInoculationList = inoculationList
            
            for (i, inoculation) in self.inoculationList.enumerated() {
                for selectedInoculation in selectedInoculationList {
                    if inoculation.id == selectedInoculation.id {
                        let cell = inoculationKindCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! InoculationCVCell
                        cell.check(isChecked: true)
                    }
                }
            }
        }
    }
}
