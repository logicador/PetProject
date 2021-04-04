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
    let getBreedCharactersRequest = GetBreedCharactersRequest()
    
    
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
    lazy var infoEditButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("수정하기", for: .normal)
        button.tintColor = .systemGray
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(infoEditTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    lazy var characterStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_S
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var adaBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "적응력"
        bcv.descLabel.text = "변화에 대처하는 능력"
        return bcv
    }()
    lazy var affBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "애정도"
        bcv.descLabel.text = "표현하는 따뜻함과 친근함의 정도"
        return bcv
    }()
    lazy var apaBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "아파트 친화성"
        bcv.descLabel.text = "크기 및 소음 경향성등 아파트 거주에 영향을 미치는 요인"
        return bcv
    }()
    lazy var barBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "짖는 경향"
        bcv.descLabel.text = "발성 크기 수준"
        return bcv
    }()
    lazy var catBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "고양이 친화성"
        bcv.descLabel.text = "고양이에 대한 인내심 및 먹잇감으로서의 낮은 인식 경향"
        return bcv
    }()
    lazy var kidBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "어린이 친화성"
        bcv.descLabel.text = "아이들에 대한 인내심 및 아이들과 잘 어울리는 경향"
        return bcv
    }()
    lazy var dogBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "강아지 친화성"
        bcv.descLabel.text = "변화에 대처하는 능력"
        return bcv
    }()
    lazy var exeBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "운동 욕구"
        bcv.descLabel.text = "다른 강아지에 대한 인내심 및 어울리는 경향"
        return bcv
    }()
    lazy var triBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "손질"
        bcv.descLabel.text = "목욕, 빗질, 전문적 털관리 등의 필요성"
        return bcv
    }()
    lazy var heaBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "건강 문제"
        bcv.descLabel.text = "해당 견종이 가지기 쉬운 건강 문제의 수준"
        return bcv
    }()
    lazy var intBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "지능"
        bcv.descLabel.text = "사고력, 문제해결능력 (훈련능력과 무관)"
        return bcv
    }()
    lazy var jokBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "장난끼"
        bcv.descLabel.text = "명랑하고 활발한 정도"
        return bcv
    }()
    lazy var haiBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "털빠짐"
        bcv.descLabel.text = "털 빠짐의 양과 빈도"
        return bcv
    }()
    lazy var socBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "사회적 욕구"
        bcv.descLabel.text = "다른 애완동물이나 사람과 교류하는 것을 선호하는 정도"
        return bcv
    }()
    lazy var strBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "낯선 사람 친화성"
        bcv.descLabel.text = "새로운 사람을 반기는 경 향"
        return bcv
    }()
    lazy var domBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "영역성"
        bcv.descLabel.text = "집, 마당, 또는 자동차를 보호하려는 성향"
        return bcv
    }()
    lazy var traBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "훈련가능성"
        bcv.descLabel.text = "새로운 것을 배우고 시도 해보려는 수준"
        return bcv
    }()
    lazy var proBCV: BreedCharacterView = {
        let bcv = BreedCharacterView()
        bcv.nameLabel.text = "집 지키는 능력"
        bcv.descLabel.text = "낯선사람에 대해 주인에게 경고할 가능성이 높은 견종"
        return bcv
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
    
    lazy var weakHelpContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var weakHelpLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        getBreedCharactersRequest.delegate = self
        
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
        
        weakHelpLabel.text = "아래는 멍스푼 회원 중 '\(pet.name)'와 유사한 반려견 데이터(\(pet.breed.name) / \(pet.monthAge)개월 / \((pet.gender == "Y") ? "수컷" : "암컷") / BCS 단계 / 중성화수술 유무 / 병력사항 등)를 분석하여 현재 가장 취약한 질병을 백분율로 나타낸 수치입니다."
    
//        guard let breedCharacterUrl = URL(string: ADMIN_URL + "/images/breed/\(pet.bId).jpg") else { return }
//        characterImageView.sd_setImage(with: breedCharacterUrl, completed: nil)
        
        getBreedCharactersRequest.fetch(vc: self, paramDict: ["bId": String(pet.bId)])
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
        
        infoContainerView.addSubview(infoEditButton)
        infoEditButton.centerYAnchor.constraint(equalTo: infoTitleLabel.centerYAnchor).isActive = true
        infoEditButton.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor).isActive = true
        
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
        
        characterContainerView.addSubview(characterStackView)
        characterStackView.topAnchor.constraint(equalTo: characterTitleBottomLine.bottomAnchor, constant: SPACE_L).isActive = true
        characterStackView.leadingAnchor.constraint(equalTo: characterContainerView.leadingAnchor).isActive = true
        characterStackView.trailingAnchor.constraint(equalTo: characterContainerView.trailingAnchor).isActive = true
        characterStackView.bottomAnchor.constraint(equalTo: characterContainerView.bottomAnchor).isActive = true
        
        characterStackView.addArrangedSubview(adaBCV)
        adaBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        adaBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(affBCV)
        affBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        affBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(apaBCV)
        apaBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        apaBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(barBCV)
        barBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        barBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(catBCV)
        catBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        catBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(kidBCV)
        kidBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        kidBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(dogBCV)
        dogBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        dogBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(exeBCV)
        exeBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        exeBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(triBCV)
        triBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        triBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(heaBCV)
        heaBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        heaBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(intBCV)
        intBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        intBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(jokBCV)
        jokBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        jokBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(haiBCV)
        haiBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        haiBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(socBCV)
        socBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        socBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(strBCV)
        strBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        strBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(domBCV)
        domBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        domBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(traBCV)
        traBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        traBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
        characterStackView.addArrangedSubview(proBCV)
        proBCV.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor).isActive = true
        proBCV.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor).isActive = true
        
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
        
        view.addSubview(weakHelpContainerView)
        weakHelpContainerView.bottomAnchor.constraint(equalTo: weakHelpImageView.topAnchor, constant: -SPACE_XXS).isActive = true
        weakHelpContainerView.trailingAnchor.constraint(equalTo: weakHelpImageView.trailingAnchor).isActive = true
        weakHelpContainerView.widthAnchor.constraint(equalTo: weakContainerView.widthAnchor, multiplier: 2 / 3).isActive = true
        
        weakHelpContainerView.addSubview(weakHelpLabel)
        weakHelpLabel.topAnchor.constraint(equalTo: weakHelpContainerView.topAnchor, constant: SPACE_XS).isActive = true
        weakHelpLabel.leadingAnchor.constraint(equalTo: weakHelpContainerView.leadingAnchor, constant: SPACE_XS).isActive = true
        weakHelpLabel.trailingAnchor.constraint(equalTo: weakHelpContainerView.trailingAnchor, constant: -SPACE_XS).isActive = true
        weakHelpLabel.bottomAnchor.constraint(equalTo: weakHelpContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
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
    
    @objc func infoEditTapped() {
        let petInfoVC = PetInfoViewController()
        petInfoVC.isEditMode = true
        navigationController?.pushViewController(petInfoVC, animated: true)
    }
    
    @objc func weakHelpTapped() {
        weakHelpContainerView.isHidden = !weakHelpContainerView.isHidden
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
            editPetRequest.fetch(vc: self, paramDict: ["peId": String(app.getPetId()), "imageName": String(imageName)])
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

// MARK: HTTP - GetBreedCharacters
extension MyPetViewController: GetBreedCharactersRequestProtocol {
    func response(breedCharacter: BreedCharacter?, getBreedCharacters status: String) {
        print("[HTTP RES]", getBreedCharactersRequest.apiUrl, status)
        
        if status == "OK" {
            guard let breedCharacter = breedCharacter else { return }
            
            adaBCV.score = breedCharacter.bc_ada
            affBCV.score = breedCharacter.bc_aff
            apaBCV.score = breedCharacter.bc_apa
            barBCV.score = breedCharacter.bc_bar
            catBCV.score = breedCharacter.bc_cat
            kidBCV.score = breedCharacter.bc_kid
            dogBCV.score = breedCharacter.bc_dog
            exeBCV.score = breedCharacter.bc_exe
            triBCV.score = breedCharacter.bc_tri
            heaBCV.score = breedCharacter.bc_hea
            intBCV.score = breedCharacter.bc_int
            jokBCV.score = breedCharacter.bc_jok
            haiBCV.score = breedCharacter.bc_hai
            socBCV.score = breedCharacter.bc_soc
            strBCV.score = breedCharacter.bc_str
            domBCV.score = breedCharacter.bc_dom
            traBCV.score = breedCharacter.bc_tra
            proBCV.score = breedCharacter.bc_pro
        }
    }
}
