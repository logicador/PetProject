//
//  MyPetViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/11.
//

import UIKit


class MyPetViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var mainVC: MainViewController?
    var changedImage: UIImage? {
        didSet {
            guard let changedImage = self.changedImage else { return }
            showIndicator(idv: indicatorView, bov: blurOverlayView)
            uploadImageRequest.fetch(vc: self, image: changedImage)
        }
    }
    var changedThumbnail: String?
    let uploadImageRequest = UploadImageRequest()
    let editPetRequest = EditPetRequest()
    
    
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
        sv.spacing = SPACE_XXXL
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Thumb
    lazy var thumbContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var thumbImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray4
        iv.layer.cornerRadius = 55
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(thumbTapped)))
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
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(thumbTapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Info
    lazy var infoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var infoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "기본 정보"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoTitleBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var infoAgeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "나이(사람나이): "
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoAgeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoBreedTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "견종: "
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoBreedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Weak
    lazy var weakContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var weakTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var weakHelpImageView: UIImageView = {
        let img = UIImage(systemName: "questionmark.circle.fill")
        let iv = UIImageView(image: img)
        iv.tintColor = .systemGray2
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(weakHelpTapped)))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var weakTitleBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    lazy var weakStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Character
    lazy var characterContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var characterTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "성격 알아보기"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var characterTitleBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var characterView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View - WeakDisease
    lazy var weakDiseaseContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var weakDiseaseTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var weakDiseaseTitleBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    lazy var weakDiseaseStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XL
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
        
        configureView()
        
        uploadImageRequest.delegate = self
        editPetRequest.delegate = self
        
        let pet = app.getPet()
        nameLabel.text = pet.name
        
        let age = Int(pet.monthAge / 12)
        infoAgeLabel.text = "\(age)세 (\(age * 8)세)"
        infoBreedLabel.text = pet.breed.name
        weakTitleLabel.text = "\(pet.name) 취약질병"
        
        guard let thumbnail = pet.thumbnail else { return }
        guard let url = URL(string: PROJECT_URL + thumbnail) else { return }
        thumbImageView.sd_setImage(with: url, completed: nil)
        
        let similarCnt = app.getSimilarCnt()
        let weakDiseaseList: [Disease] = app.getWeakDiseaseList()
        for disease in weakDiseaseList {
            let dgv = DiseaseGraphView(similarCnt: similarCnt, disease: disease)
            weakStackView.addArrangedSubview(dgv)
            dgv.leadingAnchor.constraint(equalTo: weakStackView.leadingAnchor).isActive = true
            dgv.trailingAnchor.constraint(equalTo: weakStackView.trailingAnchor).isActive = true
            
            let wdv = WeakDiseaseView(disease: disease)
            weakDiseaseStackView.addArrangedSubview(wdv)
            wdv.leadingAnchor.constraint(equalTo: weakDiseaseStackView.leadingAnchor).isActive = true
            wdv.trailingAnchor.constraint(equalTo: weakDiseaseStackView.trailingAnchor).isActive = true
        }
        
        weakDiseaseTitleLabel.text = "\(pet.name) 취약질병 증상과 원인 및 관리법"
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
        
        // MARK: ConfigureView - Thumb
        stackView.addArrangedSubview(thumbContainerView)
        thumbContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        thumbContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        thumbContainerView.addSubview(thumbImageView)
        thumbImageView.topAnchor.constraint(equalTo: thumbContainerView.topAnchor).isActive = true
        thumbImageView.centerXAnchor.constraint(equalTo: thumbContainerView.centerXAnchor).isActive = true
        thumbImageView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        thumbImageView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        thumbContainerView.addSubview(thumbAddImageView)
        thumbAddImageView.trailingAnchor.constraint(equalTo: thumbImageView.trailingAnchor).isActive = true
        thumbAddImageView.bottomAnchor.constraint(equalTo: thumbImageView.bottomAnchor, constant: -SPACE_XXS).isActive = true
        thumbAddImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        thumbAddImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        thumbContainerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: thumbImageView.bottomAnchor, constant: SPACE_S).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: thumbContainerView.centerXAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: thumbContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Info
        stackView.addArrangedSubview(infoContainerView)
        infoContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        infoContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        infoContainerView.addSubview(infoTitleLabel)
        infoTitleLabel.topAnchor.constraint(equalTo: infoContainerView.topAnchor).isActive = true
        infoTitleLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor).isActive = true
        
        infoContainerView.addSubview(infoTitleBottomLine)
        infoTitleBottomLine.topAnchor.constraint(equalTo: infoTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        infoTitleBottomLine.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor).isActive = true
        infoTitleBottomLine.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor).isActive = true
        
        infoContainerView.addSubview(infoAgeTitleLabel)
        infoAgeTitleLabel.topAnchor.constraint(equalTo: infoTitleBottomLine.bottomAnchor, constant: SPACE_L).isActive = true
        infoAgeTitleLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor).isActive = true
        
        infoContainerView.addSubview(infoAgeLabel)
        infoAgeLabel.centerYAnchor.constraint(equalTo: infoAgeTitleLabel.centerYAnchor).isActive = true
        infoAgeLabel.leadingAnchor.constraint(equalTo: infoAgeTitleLabel.trailingAnchor).isActive = true
        
        infoContainerView.addSubview(infoBreedTitleLabel)
        infoBreedTitleLabel.topAnchor.constraint(equalTo: infoAgeTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        infoBreedTitleLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor).isActive = true
        infoBreedTitleLabel.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor).isActive = true
        
        infoContainerView.addSubview(infoBreedLabel)
        infoBreedLabel.centerYAnchor.constraint(equalTo: infoBreedTitleLabel.centerYAnchor).isActive = true
        infoBreedLabel.leadingAnchor.constraint(equalTo: infoBreedTitleLabel.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Weak
        stackView.addArrangedSubview(weakContainerView)
        weakContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        weakContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        weakContainerView.addSubview(weakTitleLabel)
        weakTitleLabel.topAnchor.constraint(equalTo: weakContainerView.topAnchor).isActive = true
        weakTitleLabel.leadingAnchor.constraint(equalTo: weakContainerView.leadingAnchor).isActive = true
        
        weakContainerView.addSubview(weakHelpImageView)
        weakHelpImageView.centerYAnchor.constraint(equalTo: weakTitleLabel.centerYAnchor).isActive = true
        weakHelpImageView.trailingAnchor.constraint(equalTo: weakContainerView.trailingAnchor).isActive = true
        weakHelpImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        weakHelpImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        weakContainerView.addSubview(weakTitleBottomLine)
        weakTitleBottomLine.topAnchor.constraint(equalTo: weakTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        weakTitleBottomLine.leadingAnchor.constraint(equalTo: weakContainerView.leadingAnchor).isActive = true
        weakTitleBottomLine.trailingAnchor.constraint(equalTo: weakContainerView.trailingAnchor).isActive = true
        
        weakContainerView.addSubview(weakStackView)
        weakStackView.topAnchor.constraint(equalTo: weakTitleBottomLine.bottomAnchor, constant: SPACE_L).isActive = true
        weakStackView.leadingAnchor.constraint(equalTo: weakContainerView.leadingAnchor).isActive = true
        weakStackView.trailingAnchor.constraint(equalTo: weakContainerView.trailingAnchor).isActive = true
        weakStackView.bottomAnchor.constraint(equalTo: weakContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Character
        stackView.addArrangedSubview(characterContainerView)
        characterContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        characterContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        characterContainerView.addSubview(characterTitleLabel)
        characterTitleLabel.topAnchor.constraint(equalTo: characterContainerView.topAnchor).isActive = true
        characterTitleLabel.leadingAnchor.constraint(equalTo: characterContainerView.leadingAnchor).isActive = true
        
        characterContainerView.addSubview(characterTitleBottomLine)
        characterTitleBottomLine.topAnchor.constraint(equalTo: characterTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        characterTitleBottomLine.leadingAnchor.constraint(equalTo: characterContainerView.leadingAnchor).isActive = true
        characterTitleBottomLine.trailingAnchor.constraint(equalTo: characterContainerView.trailingAnchor).isActive = true
        
        characterContainerView.addSubview(characterView)
        characterView.topAnchor.constraint(equalTo: characterTitleBottomLine.bottomAnchor, constant: SPACE_L).isActive = true
        characterView.leadingAnchor.constraint(equalTo: characterContainerView.leadingAnchor).isActive = true
        characterView.trailingAnchor.constraint(equalTo: characterContainerView.trailingAnchor).isActive = true
        characterView.heightAnchor.constraint(equalTo: characterContainerView.widthAnchor, multiplier: 0.7).isActive = true
        characterView.bottomAnchor.constraint(equalTo: characterContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - WeakDisease
        stackView.addArrangedSubview(weakDiseaseContainerView)
        weakDiseaseContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        weakDiseaseContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        weakDiseaseContainerView.addSubview(weakDiseaseTitleLabel)
        weakDiseaseTitleLabel.topAnchor.constraint(equalTo: weakDiseaseContainerView.topAnchor).isActive = true
        weakDiseaseTitleLabel.leadingAnchor.constraint(equalTo: weakDiseaseContainerView.leadingAnchor).isActive = true
        weakDiseaseTitleLabel.trailingAnchor.constraint(equalTo: weakDiseaseContainerView.trailingAnchor).isActive = true
        
        weakDiseaseContainerView.addSubview(weakDiseaseTitleBottomLine)
        weakDiseaseTitleBottomLine.topAnchor.constraint(equalTo: weakDiseaseTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        weakDiseaseTitleBottomLine.leadingAnchor.constraint(equalTo: weakDiseaseContainerView.leadingAnchor).isActive = true
        weakDiseaseTitleBottomLine.trailingAnchor.constraint(equalTo: weakDiseaseContainerView.trailingAnchor).isActive = true
        
        weakDiseaseContainerView.addSubview(weakDiseaseStackView)
        weakDiseaseStackView.topAnchor.constraint(equalTo: weakDiseaseTitleBottomLine.bottomAnchor, constant: SPACE_L).isActive = true
        weakDiseaseStackView.leadingAnchor.constraint(equalTo: weakDiseaseContainerView.leadingAnchor).isActive = true
        weakDiseaseStackView.trailingAnchor.constraint(equalTo: weakDiseaseContainerView.trailingAnchor).isActive = true
        weakDiseaseStackView.bottomAnchor.constraint(equalTo: weakDiseaseContainerView.bottomAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func thumbTapped() {
        checkPhotoGallaryAvailable(allow: {
            let ipc = UIImagePickerController()
            ipc.sourceType = .photoLibrary
            ipc.allowsEditing = false
            ipc.delegate = self
            self.present(ipc, animated: true, completion: nil)
        })
    }
    
    @objc func weakHelpTapped() {
        print("weakHelpTapped")
    }
}


// MARK: ImagePicker
extension MyPetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage { selectedImage = image }
        else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { selectedImage = image }
        if let _selectedImage = selectedImage { changedImage = _selectedImage }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: HTTP - UploadImage
extension MyPetViewController: UploadImageRequestProtocol {
    func response(imageName: Int?, uploadImage status: String) {
        print("[HTTP RES]", uploadImageRequest.apiUrl, status)
        if status == "OK" {
            guard let imageName = imageName else { return }
            changedThumbnail = "/images/users/\(app.getUserId())/\(imageName).jpg"
            editPetRequest.fetch(vc: self, paramDict: ["peId": String(app.getUserPetId()), "imageName": String(imageName)])
        } else {
            hideIndicator(idv: indicatorView, bov: blurOverlayView)
        }
    }
}

// MARK: HTTP - EditPet
extension MyPetViewController: EditPetRequestProtocol {
    func response(editPet status: String) {
        print("[HTTP RES]", editPetRequest.apiUrl, status)
        if status == "OK" {
            guard let changedThumbnail = self.changedThumbnail else { return }
            thumbImageView.image = changedImage
            app.setPetThumbnail(thumbnail: changedThumbnail)
        }
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
    }
}
