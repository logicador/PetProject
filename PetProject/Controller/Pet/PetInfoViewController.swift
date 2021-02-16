//
//  PetInfoViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


class PetInfoViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var user: User?
    let logoutRequest = LogoutRequest()
    var selectedBreed: Breed?
    let petHealthVC = PetHealthViewController()
    let searchBreedVC = SearchBreedViewController()
    
    
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
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View - Thumb
    lazy var thumbImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray4
        iv.layer.cornerRadius = 60
        iv.layer.borderWidth = 6
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.zPosition = 1
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var thumbAddImageView: UIImageView = {
        let img = UIImage(systemName: "plus.circle.fill")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .mainColor
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 16
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.zPosition = 1
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = SPACE_XXS
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var thumbButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("프로필 사진 바꾸기", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.tintColor = .mainColor
        button.addTarget(self, action: #selector(thumbTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    lazy var namePetInputView: PetInputView = {
        let piv = PetInputView(labelText: "아이이름", placeholder: "댕댕이")
        piv.delegate = self
        return piv
    }()
    lazy var birthPetInputView: PetInputView = {
        let piv = PetInputView(labelText: "생년월일", placeholder: "20210101")
        piv.textField.keyboardType = .numberPad
        piv.delegate = self
        return piv
    }()
    lazy var breedPetInputView: PetInputView = {
        let piv = PetInputView(labelText: "견종", placeholder: "선택", isSelectMode: true, actionMode: "SELECT_BREED")
        piv.delegate = self
        return piv
    }()
    
    // MARK: View - Gender
    lazy var genderContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.text = "성별"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var genderButtonContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.cornerRadius = SPACE_XXS
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var maleButton: ToggleButton = {
        let button = ToggleButton(type: .system)
        button.setTitle("남아", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tag = 1
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(genderTapped), for: .touchUpInside)
        return button
    }()
    lazy var femaleButton: ToggleButton = {
        let button = ToggleButton(type: .system)
        button.setTitle("여아", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tag = 2
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(genderTapped), for: .touchUpInside)
        return button
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
        
        title = "반려동물 기본 정보"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        user = app.getUser()
        guard let user = self.user else { return }
        
        if user.petCnt > 0 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backTapped))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backTapped))
        }
        
        navigationController?.navigationBar.tintColor = .mainColor
        
        configureView()
        
        hideKeyboardWhenTappedAround()
        
        logoutRequest.delegate = self
        petHealthVC.delegate = self
        searchBreedVC.delegate = self
        
        // MARK: For DEV_DEBUG
        namePetInputView.textField.text = "찹찹이"
        birthPetInputView.textField.text = "20190101"
        breedPetInputView.textField.text = "말티즈"
        selectedBreed = Breed(id: 4, name: "말티즈_TEST", type: "S")
        maleButton.setSelect(isSelected: true)
        nextButton.setActive(isActive: true)
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
        
        stackView.addArrangedSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        
        // MARK: ConfigureView - Thumb
        contentView.addSubview(thumbImageView)
        thumbImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        thumbImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        thumbImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        thumbImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        contentView.addSubview(thumbAddImageView)
        thumbAddImageView.trailingAnchor.constraint(equalTo: thumbImageView.trailingAnchor).isActive = true
        thumbAddImageView.bottomAnchor.constraint(equalTo: thumbImageView.bottomAnchor, constant: -SPACE_S).isActive = true
        thumbAddImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        thumbAddImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        contentView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: thumbImageView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        containerView.addSubview(thumbButton)
        thumbButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 60 + SPACE_XXXXXS).isActive = true
        thumbButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        containerView.addSubview(containerStackView)
        containerStackView.topAnchor.constraint(equalTo: thumbButton.bottomAnchor, constant: SPACE_XXL).isActive = true
        containerStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        containerStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -SPACE_XXL).isActive = true
        
        containerStackView.addArrangedSubview(namePetInputView)
        namePetInputView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        namePetInputView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        containerStackView.addArrangedSubview(birthPetInputView)
        birthPetInputView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        birthPetInputView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        containerStackView.addArrangedSubview(breedPetInputView)
        breedPetInputView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        breedPetInputView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Gender
        containerStackView.addArrangedSubview(genderContainerView)
        genderContainerView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        genderContainerView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        genderContainerView.addSubview(genderButtonContainerView)
        genderButtonContainerView.topAnchor.constraint(equalTo: genderContainerView.topAnchor).isActive = true
        genderButtonContainerView.trailingAnchor.constraint(equalTo: genderContainerView.trailingAnchor).isActive = true
        genderButtonContainerView.widthAnchor.constraint(equalTo: genderContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XXXXXS).isActive = true
        genderButtonContainerView.bottomAnchor.constraint(equalTo: genderContainerView.bottomAnchor).isActive = true
        
        genderButtonContainerView.addSubview(femaleButton)
        femaleButton.topAnchor.constraint(equalTo: genderButtonContainerView.topAnchor).isActive = true
        femaleButton.trailingAnchor.constraint(equalTo: genderButtonContainerView.trailingAnchor).isActive = true
        femaleButton.widthAnchor.constraint(equalTo: genderButtonContainerView.widthAnchor, multiplier: 0.5).isActive = true
        femaleButton.bottomAnchor.constraint(equalTo: genderButtonContainerView.bottomAnchor).isActive = true
        
        genderButtonContainerView.addSubview(maleButton)
        maleButton.topAnchor.constraint(equalTo: genderButtonContainerView.topAnchor).isActive = true
        maleButton.leadingAnchor.constraint(equalTo: genderButtonContainerView.leadingAnchor).isActive = true
        maleButton.widthAnchor.constraint(equalTo: genderButtonContainerView.widthAnchor, multiplier: 0.5).isActive = true
        maleButton.bottomAnchor.constraint(equalTo: genderButtonContainerView.bottomAnchor).isActive = true
        
        genderContainerView.addSubview(genderLabel)
        genderLabel.leadingAnchor.constraint(equalTo: genderContainerView.leadingAnchor).isActive = true
        genderLabel.centerYAnchor.constraint(equalTo: genderButtonContainerView.centerYAnchor).isActive = true
        
        stackView.addArrangedSubview(nextButton)
        nextButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: CONFIRM_BUTTON_HEIGHT).isActive = true
    }
    
    // MARK: Function - checkIsValid
    func checkIsValid() {
        guard let name = namePetInputView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            nextButton.setActive(isActive: false)
            return
        }
        guard let birth = birthPetInputView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            nextButton.setActive(isActive: false)
            return
        }
        guard let breed = breedPetInputView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            nextButton.setActive(isActive: false)
            return
        }
        
        // 이름 1-8 (1-12)
        if !isValidString(min: 1, utf8Min: 1, max: 8, utf8Max: 12, value: name) {
            nextButton.setActive(isActive: false)
            return
        }
        
        // 견종 입력 체크
        if breed.isEmpty {
            nextButton.setActive(isActive: false)
            return
        }
        guard let _ = selectedBreed else {
            nextButton.setActive(isActive: false)
            return
        }
        
        // 성별 선택 체크
        if maleButton.backgroundColor == .white && femaleButton.backgroundColor == .white {
            nextButton.setActive(isActive: false)
            return
        }
        
        // 생일 정규식 / 숫자 8자리
        let birthRegEx = "[0-9]{8}"
        let birthTest = NSPredicate(format: "SELF MATCHES %@", birthRegEx)
        if !birthTest.evaluate(with: birth) {
            nextButton.setActive(isActive: false)
            return
        }
        
        // 현재 날짜, 입력 날짜 가져오기
        let now = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)
        let yearStartIndex = birth.index(birth.startIndex, offsetBy: 0)
        let yearEndIndex = birth.index(birth.startIndex, offsetBy: 4)
        let monthStartIndex = birth.index(birth.startIndex, offsetBy: 4)
        let monthEndIndex = birth.index(birth.endIndex, offsetBy: -2)
        let dayStartIndex = birth.index(birth.endIndex, offsetBy: -2)
        let dayEndIndex = birth.index(birth.endIndex, offsetBy: 0)
        let splitBirthYear = birth[yearStartIndex..<yearEndIndex]
        let splitBirthMonth = birth[monthStartIndex..<monthEndIndex]
        let splitBirthDay = birth[dayStartIndex..<dayEndIndex]
        
        // 입력된 날짜가 유효한지 (Date로 변경)
        guard let _ = birth.toDate(dateFormat: "YYYYMMdd") else {
            nextButton.setActive(isActive: false)
            return
        }
        
        // 입력된 날짜가 숫자로 변환 가능한지 (오늘날짜기준 미래인지 비교 위함)
        guard let birthYear = Int(splitBirthYear) else {
            nextButton.setActive(isActive: false)
            return
        }
        guard let birthMonth = Int(splitBirthMonth) else {
            nextButton.setActive(isActive: false)
            return
        }
        guard let birthDay = Int(splitBirthDay) else {
            nextButton.setActive(isActive: false)
            return
        }
        
        // 오늘 날짜 이후인지 체크
        if year < birthYear {
            nextButton.setActive(isActive: false)
            return
        }
        if year == birthYear && month < birthMonth {
            nextButton.setActive(isActive: false)
            return
        }
        if year == birthYear && month == birthMonth && day < birthDay {
            nextButton.setActive(isActive: false)
            return
        }
        
        nextButton.setActive(isActive: true)
    }
    
    // MARK: Function - @OBJC
    @objc func backTapped() {
        dismissKeyboard()
        
        guard let user = self.user else { return }
        
        if user.petCnt > 0 {
            
        } else {
            logoutRequest.fetch(vc: self, paramDict: [:])
        }
    }
    
    @objc func thumbTapped() {
        dismissKeyboard()
        
        checkPhotoGallaryAvailable(allow: {
            let ipc = UIImagePickerController()
            ipc.sourceType = .photoLibrary
            ipc.allowsEditing = false
            ipc.delegate = self
            self.present(ipc, animated: true, completion: nil)
        })
    }
    
    @objc func genderTapped(sender: UIButton) {
        dismissKeyboard()
        
        if sender.tag == 1 {
            maleButton.setSelect(isSelected: true)
            femaleButton.setSelect(isSelected: false)
        } else {
            femaleButton.setSelect(isSelected: true)
            maleButton.setSelect(isSelected: false)
        }
        
        checkIsValid()
    }
    
    @objc func nextTapped() {
        dismissKeyboard()
        
        if !nextButton.isActive { return }
        
        navigationController?.pushViewController(petHealthVC, animated: true)
    }
}


// MARK: HTTP - Logout
extension PetInfoViewController: LogoutRequestProtocol {
    func response(logout status: String) {
        print("[HTTP RES]", logoutRequest.apiUrl, status)
        
        if status == "OK" {
            app.logout()
            changeRootViewController(rootViewController: LoginViewController())
        }
    }
}

// MARK: PetInputView
extension PetInfoViewController: PetInputViewProtocol {
    func action(actionMode: String) {
        dismissKeyboard()
        
        if actionMode == "SELECT_BREED" {
            navigationController?.pushViewController(searchBreedVC, animated: true)
        }
    }
    
    func textChanged() {
        checkIsValid()
    }
}


// MARK: ImagePicker
extension PetInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
        }
        if let _selectedImage = selectedImage {
            thumbImageView.image = _selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: SearchBreedVC
extension PetInfoViewController: SearchBreedViewControllerProtocol {
    func selectBreed(breed: Breed) {
        selectedBreed = breed
        
        breedPetInputView.textField.text = breed.name
        checkIsValid()
    }
}

// MARK: PetHealthVC
extension PetInfoViewController: PetHealthViewControllerProtocol {
    func savePet() {
        let thumb: UIImage? = thumbImageView.image
        guard let name = namePetInputView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let birth = birthPetInputView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let breed = selectedBreed else { return }
        let gender = (maleButton.backgroundColor == .mainColor) ? "M" : "F"
        petHealthVC.addPet(thumb: thumb, name: name, birth: birth, breed: breed, gender: gender)
    }
}
