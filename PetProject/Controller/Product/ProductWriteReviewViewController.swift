//
//  ProductWriteReviewViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/15.
//

import UIKit


protocol ProductWriteReviewViewControllerProtocol {
    func addReview(review: Review)
}


class ProductWriteReviewViewController: UIViewController {
    
    // MARK: Property
    var delegate: ProductWriteReviewViewControllerProtocol?
    var pId: Int?
    let app = App()
    var selectedImageIndex: Int = 0
    var pala = 0
    var bene = 0
    var cost = 0
    var side = "N"
    var _title = ""
    var descAdv = ""
    var descDisAdv = ""
    var imageNameList: [Int] = []
    var uploadImageCnt = 0
    let uploadImageRequest = UploadImageRequest()
    let addReviewRequest = AddReviewRequest()
    
    
    // MARK: View
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var addReviewButton: ConfirmButton = {
        let cb = ConfirmButton(type: .system)
        cb.setActive(isActive: true)
        cb.setTitle("리뷰 올리기", for: .normal)
        cb.titleLabel?.font = .boldSystemFont(ofSize: 20)
        cb.addTarget(self, action: #selector(addReviewTapped), for: .touchUpInside)
        return cb
    }()
    
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
        sv.spacing = SPACE_XXL
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var starStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var containerStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Pala
    lazy var palaContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var palaStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XS
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var palaLabel: UILabel = {
        let label = UILabel()
        label.text = "기호성"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Bene
    lazy var beneContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var beneStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XS
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var beneLabel: UILabel = {
        let label = UILabel()
        label.text = "기대효과"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Cost
    lazy var costContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var costStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XS
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var costLabel: UILabel = {
        let label = UILabel()
        label.text = "가성비"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Side
    lazy var sideContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var sideImageView: UIImageView = {
        let img = UIImage(systemName: "star.fill")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray3
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sideTapped)))
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var sideLabel: UILabel = {
        let label = UILabel()
        label.text = "부작용"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Title
    lazy var titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var titleTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var titleTextContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = LINE_WIDTH
        view.layer.cornerRadius = SPACE_XXS
        view.layer.borderColor = UIColor.separator.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var titleTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 14)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // MARK: View - Adv
    lazy var advContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var advTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "장점"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var advTextContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = LINE_WIDTH
        view.layer.cornerRadius = SPACE_XXS
        view.layer.borderColor = UIColor.separator.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var advTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: View - DisAdv
    lazy var disAdvContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var disAdvTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "단점"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var disAdvTextContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = LINE_WIDTH
        view.layer.cornerRadius = SPACE_XXS
        view.layer.borderColor = UIColor.separator.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var disAdvTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: View - Image
    lazy var imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var imageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이미지"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var imageStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XS
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
        
        navigationItem.title = "리뷰쓰기"
        
//        isModalInPresentation = true
        
        configureView()
        
        uploadImageRequest.delegate = self
        addReviewRequest.delegate = self
        
        hideKeyboardWhenTappedAround()
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(bottomView)
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        bottomView.addSubview(addReviewButton)
        addReviewButton.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        addReviewButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        addReviewButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        addReviewButton.heightAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.12).isActive = true
        addReviewButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SPACE_XXL).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SPACE_XXL).isActive = true
        
        stackView.addArrangedSubview(starStackView)
        starStackView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        starStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        stackView.addArrangedSubview(containerStackView)
        containerStackView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        containerStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        // MARK: ConfigureView - Pala
        starStackView.addArrangedSubview(palaContainerView)
        palaContainerView.leadingAnchor.constraint(equalTo: starStackView.leadingAnchor).isActive = true
        palaContainerView.trailingAnchor.constraint(equalTo: starStackView.trailingAnchor).isActive = true
        
        palaContainerView.addSubview(palaStackView)
        palaStackView.topAnchor.constraint(equalTo: palaContainerView.topAnchor).isActive = true
        palaStackView.trailingAnchor.constraint(equalTo: palaContainerView.trailingAnchor).isActive = true
        palaStackView.bottomAnchor.constraint(equalTo: palaContainerView.bottomAnchor).isActive = true
        
        for i in 1...5 {
            let img = UIImage(systemName: "star.fill")
            let iv = UIImageView(image: img)
            iv.contentMode = .scaleAspectFit
            iv.tintColor = .systemGray3
            iv.tag = i
            iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(palaTapped)))
            iv.isUserInteractionEnabled = true
            iv.translatesAutoresizingMaskIntoConstraints = false
            
            palaStackView.addArrangedSubview(iv)
            iv.widthAnchor.constraint(equalTo: palaContainerView.widthAnchor, multiplier: 0.1).isActive = true
            iv.heightAnchor.constraint(equalTo: palaContainerView.widthAnchor, multiplier: 0.1).isActive = true
        }
        
        palaContainerView.addSubview(palaLabel)
        palaLabel.centerYAnchor.constraint(equalTo: palaStackView.centerYAnchor).isActive = true
        palaLabel.leadingAnchor.constraint(equalTo: palaContainerView.leadingAnchor).isActive = true
        
        // MARK: ConfigureView - Bene
        starStackView.addArrangedSubview(beneContainerView)
        beneContainerView.leadingAnchor.constraint(equalTo: starStackView.leadingAnchor).isActive = true
        beneContainerView.trailingAnchor.constraint(equalTo: starStackView.trailingAnchor).isActive = true
        
        beneContainerView.addSubview(beneStackView)
        beneStackView.topAnchor.constraint(equalTo: beneContainerView.topAnchor).isActive = true
        beneStackView.trailingAnchor.constraint(equalTo: beneContainerView.trailingAnchor).isActive = true
        beneStackView.bottomAnchor.constraint(equalTo: beneContainerView.bottomAnchor).isActive = true
        
        for i in 1...5 {
            let img = UIImage(systemName: "star.fill")
            let iv = UIImageView(image: img)
            iv.contentMode = .scaleAspectFit
            iv.tintColor = .systemGray3
            iv.tag = i
            iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(beneTapped)))
            iv.isUserInteractionEnabled = true
            iv.translatesAutoresizingMaskIntoConstraints = false
            
            beneStackView.addArrangedSubview(iv)
            iv.widthAnchor.constraint(equalTo: beneContainerView.widthAnchor, multiplier: 0.1).isActive = true
            iv.heightAnchor.constraint(equalTo: beneContainerView.widthAnchor, multiplier: 0.1).isActive = true
        }
        
        beneContainerView.addSubview(beneLabel)
        beneLabel.centerYAnchor.constraint(equalTo: beneStackView.centerYAnchor).isActive = true
        beneLabel.leadingAnchor.constraint(equalTo: beneContainerView.leadingAnchor).isActive = true
        
        // MARK: ConfigureView - Cost
        starStackView.addArrangedSubview(costContainerView)
        costContainerView.leadingAnchor.constraint(equalTo: starStackView.leadingAnchor).isActive = true
        costContainerView.trailingAnchor.constraint(equalTo: starStackView.trailingAnchor).isActive = true
        
        costContainerView.addSubview(costStackView)
        costStackView.topAnchor.constraint(equalTo: costContainerView.topAnchor).isActive = true
        costStackView.trailingAnchor.constraint(equalTo: costContainerView.trailingAnchor).isActive = true
        costStackView.bottomAnchor.constraint(equalTo: costContainerView.bottomAnchor).isActive = true
        
        for i in 1...5 {
            let img = UIImage(systemName: "star.fill")
            let iv = UIImageView(image: img)
            iv.contentMode = .scaleAspectFit
            iv.tintColor = .systemGray3
            iv.tag = i
            iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(costTapped)))
            iv.isUserInteractionEnabled = true
            iv.translatesAutoresizingMaskIntoConstraints = false
            
            costStackView.addArrangedSubview(iv)
            iv.widthAnchor.constraint(equalTo: costContainerView.widthAnchor, multiplier: 0.1).isActive = true
            iv.heightAnchor.constraint(equalTo: costContainerView.widthAnchor, multiplier: 0.1).isActive = true
        }
        
        costContainerView.addSubview(costLabel)
        costLabel.centerYAnchor.constraint(equalTo: costStackView.centerYAnchor).isActive = true
        costLabel.leadingAnchor.constraint(equalTo: costContainerView.leadingAnchor).isActive = true
        
        // MARK: ConfigureView - Side
        starStackView.addArrangedSubview(sideContainerView)
        sideContainerView.leadingAnchor.constraint(equalTo: starStackView.leadingAnchor).isActive = true
        sideContainerView.trailingAnchor.constraint(equalTo: starStackView.trailingAnchor).isActive = true
        
        sideContainerView.addSubview(sideImageView)
        sideImageView.topAnchor.constraint(equalTo: sideContainerView.topAnchor).isActive = true
        sideImageView.leadingAnchor.constraint(equalTo: costStackView.leadingAnchor).isActive = true
        sideImageView.widthAnchor.constraint(equalTo: sideContainerView.widthAnchor, multiplier: 0.1).isActive = true
        sideImageView.heightAnchor.constraint(equalTo: sideContainerView.widthAnchor, multiplier: 0.1).isActive = true
        sideImageView.bottomAnchor.constraint(equalTo: sideContainerView.bottomAnchor).isActive = true
        
        sideContainerView.addSubview(sideLabel)
        sideLabel.centerYAnchor.constraint(equalTo: sideImageView.centerYAnchor).isActive = true
        sideLabel.leadingAnchor.constraint(equalTo: sideContainerView.leadingAnchor).isActive = true
        
        // MARK: ConfigureView - Title
//        containerStackView.addArrangedSubview(titleContainerView)
//        titleContainerView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
//        titleContainerView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
//
//        titleContainerView.addSubview(titleTitleLabel)
//        titleTitleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor).isActive = true
//        titleTitleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor).isActive = true
//
//        titleContainerView.addSubview(titleTextContainerView)
//        titleTextContainerView.topAnchor.constraint(equalTo: titleTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
//        titleTextContainerView.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor).isActive = true
//        titleTextContainerView.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor).isActive = true
//        titleTextContainerView.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor).isActive = true
//
//        titleTextContainerView.addSubview(titleTextField)
//        titleTextField.topAnchor.constraint(equalTo: titleTextContainerView.topAnchor, constant: SPACE_XS).isActive = true
//        titleTextField.leadingAnchor.constraint(equalTo: titleTextContainerView.leadingAnchor, constant: SPACE_S).isActive = true
//        titleTextField.trailingAnchor.constraint(equalTo: titleTextContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
//        titleTextField.bottomAnchor.constraint(equalTo: titleTextContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        // MARK: ConfigureView - Adv
        containerStackView.addArrangedSubview(advContainerView)
        advContainerView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        advContainerView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        advContainerView.addSubview(advTitleLabel)
        advTitleLabel.topAnchor.constraint(equalTo: advContainerView.topAnchor).isActive = true
        advTitleLabel.leadingAnchor.constraint(equalTo: advContainerView.leadingAnchor).isActive = true
        
        advContainerView.addSubview(advTextContainerView)
        advTextContainerView.topAnchor.constraint(equalTo: advTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        advTextContainerView.leadingAnchor.constraint(equalTo: advContainerView.leadingAnchor).isActive = true
        advTextContainerView.trailingAnchor.constraint(equalTo: advContainerView.trailingAnchor).isActive = true
        advTextContainerView.bottomAnchor.constraint(equalTo: advContainerView.bottomAnchor).isActive = true
        
        advTextContainerView.addSubview(advTextView)
        advTextView.topAnchor.constraint(equalTo: advTextContainerView.topAnchor, constant: SPACE_XS).isActive = true
        advTextView.leadingAnchor.constraint(equalTo: advTextContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        advTextView.trailingAnchor.constraint(equalTo: advTextContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        advTextView.heightAnchor.constraint(equalTo: advTextContainerView.widthAnchor, multiplier: 0.5).isActive = true
        advTextView.bottomAnchor.constraint(equalTo: advTextContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        // MARK: ConfigureView - DisAdv
        containerStackView.addArrangedSubview(disAdvContainerView)
        disAdvContainerView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        disAdvContainerView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        disAdvContainerView.addSubview(disAdvTitleLabel)
        disAdvTitleLabel.topAnchor.constraint(equalTo: disAdvContainerView.topAnchor).isActive = true
        disAdvTitleLabel.leadingAnchor.constraint(equalTo: disAdvContainerView.leadingAnchor).isActive = true
        
        disAdvContainerView.addSubview(disAdvTextContainerView)
        disAdvTextContainerView.topAnchor.constraint(equalTo: disAdvTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        disAdvTextContainerView.leadingAnchor.constraint(equalTo: disAdvContainerView.leadingAnchor).isActive = true
        disAdvTextContainerView.trailingAnchor.constraint(equalTo: disAdvContainerView.trailingAnchor).isActive = true
        disAdvTextContainerView.bottomAnchor.constraint(equalTo: disAdvContainerView.bottomAnchor).isActive = true
        
        disAdvTextContainerView.addSubview(disAdvTextView)
        disAdvTextView.topAnchor.constraint(equalTo: disAdvTextContainerView.topAnchor, constant: SPACE_XS).isActive = true
        disAdvTextView.leadingAnchor.constraint(equalTo: disAdvTextContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        disAdvTextView.trailingAnchor.constraint(equalTo: disAdvTextContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        disAdvTextView.heightAnchor.constraint(equalTo: disAdvTextContainerView.widthAnchor, multiplier: 0.5).isActive = true
        disAdvTextView.bottomAnchor.constraint(equalTo: disAdvTextContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        // MARK: ConfigureView - Image
        containerStackView.addArrangedSubview(imageContainerView)
        imageContainerView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        imageContainerView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
        
        imageContainerView.addSubview(imageTitleLabel)
        imageTitleLabel.topAnchor.constraint(equalTo: imageContainerView.topAnchor).isActive = true
        imageTitleLabel.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor).isActive = true
        
        imageContainerView.addSubview(imageStackView)
        imageStackView.topAnchor.constraint(equalTo: imageTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        imageStackView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor).isActive = true
        imageStackView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor).isActive = true
        imageStackView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        
        for i in 1...4 {
            let iv = UIImageView()
            iv.backgroundColor = .tertiarySystemGroupedBackground
            iv.clipsToBounds = true
            iv.contentMode = .scaleAspectFill
            iv.tag = i
            iv.isUserInteractionEnabled = true
            iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
            iv.translatesAutoresizingMaskIntoConstraints = false
            
            imageStackView.addArrangedSubview(iv)
            iv.widthAnchor.constraint(equalTo: imageStackView.widthAnchor, multiplier: (1 / 4), constant: -((SPACE_XS * 3) / 4)).isActive = true
            iv.heightAnchor.constraint(equalTo: imageStackView.widthAnchor, multiplier: (1 / 4), constant: -((SPACE_XS * 3) / 4)).isActive = true
            
            let img = UIImage(systemName: "plus")
            let icon = UIImageView(image: img)
            icon.contentMode = .scaleAspectFit
            icon.tintColor = .white
            icon.translatesAutoresizingMaskIntoConstraints = false
            
            iv.addSubview(icon)
            icon.centerXAnchor.constraint(equalTo: iv.centerXAnchor).isActive = true
            icon.centerYAnchor.constraint(equalTo: iv.centerYAnchor).isActive = true
            icon.widthAnchor.constraint(equalTo: iv.widthAnchor, multiplier: 0.4).isActive = true
            icon.heightAnchor.constraint(equalTo: iv.widthAnchor, multiplier: 0.4).isActive = true
        }
    }
    
    func getReviewParamDict() -> [String: String] {
        guard let pId = self.pId else { return [:] }
        
        var paramDict: [String: String] = [:]
        
        paramDict["peId"] = String(app.getPetId())
        paramDict["pId"] = String(pId)
        paramDict["pala"] = String(pala)
        paramDict["bene"] = String(bene)
        paramDict["cost"] = String(cost)
        paramDict["side"] = side
//        paramDict["title"] = _title
        paramDict["descAdv"] = descAdv
        paramDict["descDisAdv"] = descDisAdv
        paramDict["imageNameList"] = imageNameList.description
        
        return paramDict
    }
    
    // MARK: Function - @OBJC
    @objc func addReviewTapped() {
        pala = 0
        bene = 0
        cost = 0
        uploadImageCnt = 0
        
        for v in palaStackView.subviews { if v.tintColor == .mainColor { pala += 1 } }
        if pala == 0 {
            let alert = UIAlertController(title: nil, message: "기호성 별점을 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        for v in beneStackView.subviews { if v.tintColor == .mainColor { bene += 1 } }
        if bene == 0 {
            let alert = UIAlertController(title: nil, message: "기대효과 별점을 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        for v in costStackView.subviews { if v.tintColor == .mainColor { cost += 1 } }
        if cost == 0 {
            let alert = UIAlertController(title: nil, message: "가성비 별점을 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
            present(alert, animated: true)
            return
        }
        
//        guard let t = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
//        _title = t
//
//        if _title.isEmpty {
//            let alert = UIAlertController(title: nil, message: "제목을 입력해주세요.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
//            present(alert, animated: true)
//            return
//        }
//        if _title.count < 1 || (_title.count > 20 || _title.count < 5) {
//            let alert = UIAlertController(title: nil, message: "제목은 5-20자 까지 입력 가능합니다.\n\n\(_title.count)/20", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
//            present(alert, animated: true)
//            return
//        }
        
        descAdv = advTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        descDisAdv = disAdvTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if descAdv.isEmpty && descDisAdv.isEmpty {
            let alert = UIAlertController(title: nil, message: "장점 또는 단점을 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        if !descAdv.isEmpty && (descAdv.count > 100 || descAdv.count < 10) {
            let alert = UIAlertController(title: nil, message: "장점은 10-100자 까지 입력 가능합니다.\n\n\(descAdv.count)/100", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        if !descDisAdv.isEmpty && (descDisAdv.count > 100 || descDisAdv.count < 10) {
            let alert = UIAlertController(title: nil, message: "단점은 10-100자 까지 입력 가능합니다.\n\n\(descAdv.count)/100", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        side = (sideImageView.tintColor == .systemRed) ? "Y" : "N"
        
        for v in imageStackView.subviews {
            let iv = v as! UIImageView
            if let image = iv.image {
                uploadImageCnt += 1
                uploadImageRequest.fetch(vc: self, image: image)
            }
        }
        
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        if uploadImageCnt == 0 {
            addReviewRequest.fetch(vc: self, paramDict: getReviewParamDict())
        }
    }
    
    @objc func palaTapped(sender: UITapGestureRecognizer) {
        dismissKeyboard()
        
        guard let v = sender.view else { return }
        let tag = v.tag
        for i in 1...palaStackView.subviews.count {
            if i <= tag { palaStackView.subviews[i - 1].tintColor = .mainColor }
            else { palaStackView.subviews[i - 1].tintColor = .systemGray3 }
        }
    }
    
    @objc func beneTapped(sender: UITapGestureRecognizer) {
        dismissKeyboard()
        
        guard let v = sender.view else { return }
        let tag = v.tag
        for i in 1...beneStackView.subviews.count {
            if i <= tag { beneStackView.subviews[i - 1].tintColor = .mainColor }
            else { beneStackView.subviews[i - 1].tintColor = .systemGray3 }
        }
    }
    
    @objc func costTapped(sender: UITapGestureRecognizer) {
        dismissKeyboard()
        
        guard let v = sender.view else { return }
        let tag = v.tag
        for i in 1...costStackView.subviews.count {
            if i <= tag { costStackView.subviews[i - 1].tintColor = .mainColor }
            else { costStackView.subviews[i - 1].tintColor = .systemGray3 }
        }
    }
    
    @objc func sideTapped() {
        dismissKeyboard()
        
        sideImageView.tintColor = (sideImageView.tintColor == .systemRed) ? .systemGray3 : .systemRed
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        dismissKeyboard()
        
        guard let v = sender.view else { return }
        let tag = v.tag
        
        selectedImageIndex = tag
        
        checkPhotoGallaryAvailable(allow: {
            let ipc = UIImagePickerController()
            ipc.sourceType = .photoLibrary
            ipc.allowsEditing = true
            ipc.delegate = self
            self.present(ipc, animated: true, completion: nil)
        })
    }
}


// MARK: ImagePicker
extension ProductWriteReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
        }
        if let _selectedImage = selectedImage {
            let iv = imageStackView.subviews[selectedImageIndex - 1] as! UIImageView
            iv.image = _selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: HTTP - UploadImage
extension ProductWriteReviewViewController: UploadImageRequestProtocol {
    func response(imageName: Int?, uploadImage status: String) {
        print("[HTTP RES]", uploadImageRequest.apiUrl, status)
        
        if status == "OK" {
            guard let imageName = imageName else { return }
            imageNameList.append(imageName)
            
            if uploadImageCnt == imageNameList.count {
                addReviewRequest.fetch(vc: self, paramDict: getReviewParamDict())
            }
            
        } else {
            hideIndicator(idv: indicatorView, bov: blurOverlayView)
        }
    }
}

// MARK: HTTP - AddReview
extension ProductWriteReviewViewController: AddReviewRequestProtocol {
    func response(review: Review?, addReview status: String) {
        print("[HTTP RES]", addReviewRequest.apiUrl, status)
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
        
        if status == "OK" {
            guard let review = review else { return }
            let alert = UIAlertController(title: "리뷰쓰기", message: "리뷰가 성공적으로 등록되었습니다. 감사합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                self.delegate?.addReview(review: review)
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true)
        }
    }
}
