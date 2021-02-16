//
//  HomeViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/11.
//

import UIKit


class HomeViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var mainVC: MainViewController?
    let searchImageViewWidth = SCREEN_WIDTH * 0.18
    let hotItemImageViewWidth = SCREEN_WIDTH * 0.18
    let hotItemImageViewheight = SCREEN_WIDTH * 0.2
    let getPetRequest = GetPetRequest()
    let getPetIngredientRequest = GetPetIngredientRequest()
    
    
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
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var bannerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View - Search
    lazy var searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.text = "음식이나 질병 및 증상에 대해 감색해 보세요!"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Search - Disease
    lazy var searchDiseaseContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchDiseaseTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var searchDiseaseImageView: UIImageView = {
        let img = UIImage(imageLiteralResourceName: "SearchDisease")
        let iv = UIImageView(image: img)
        iv.backgroundColor = .white
        iv.layer.cornerRadius = searchImageViewWidth / 2
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var searchDiseaseLabel: UILabel = {
        let label = UILabel()
        label.text = "질병검색"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Search - Food
    lazy var searchFoodContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchFoodTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var searchFoodImageView: UIImageView = {
        let img = UIImage(imageLiteralResourceName: "SearchFood")
        let iv = UIImageView(image: img)
        iv.backgroundColor = .white
        iv.layer.cornerRadius = searchImageViewWidth / 2
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var searchFoodLabel: UILabel = {
        let label = UILabel()
        label.text = "음식검색"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Search - Symptom
    lazy var searchSymptomContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchSymptomTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var searchSymptomImageView: UIImageView = {
        let img = UIImage(imageLiteralResourceName: "SearchSymptom")
        let iv = UIImageView(image: img)
        iv.backgroundColor = .white
        iv.layer.cornerRadius = searchImageViewWidth / 2
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var searchSymptomLabel: UILabel = {
        let label = UILabel()
        label.text = "증상검색"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Hot
    lazy var hotContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var moreHotImageView: UIImageView = {
        let img = UIImage(systemName: "chevron.right")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray2
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var moreHotButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("더보기", for: .normal)
        button.tintColor = .systemGray2
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(moreHotTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var hotLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var hotItemContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View - Hot - Supplement
    lazy var hotItemSupplementContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hotItemSupplementTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var hotItemSupplementImageView: UIImageView = {
        let img = UIImage(imageLiteralResourceName: "HotSupplement")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var hotItemSupplementLabelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XXXS
        view.backgroundColor = .mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var hotItemSupplementLabel: UILabel = {
        let label = UILabel()
        label.text = "영양제"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Hot - Feed
    lazy var hotItemFeedContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hotItemFeedTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var hotItemFeedImageView: UIImageView = {
        let img = UIImage(imageLiteralResourceName: "HotFeed")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var hotItemFeedLabelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XXXS
        view.backgroundColor = .mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var hotItemFeedLabel: UILabel = {
        let label = UILabel()
        label.text = "사료"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Hot - Snack
    lazy var hotItemSnackContainerView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hotItemSnackTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var hotItemSnackImageView: UIImageView = {
        let img = UIImage(imageLiteralResourceName: "HotSnack")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var hotItemSnackLabelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SPACE_XXXS
        view.backgroundColor = .mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var hotItemSnackLabel: UILabel = {
        let label = UILabel()
        label.text = "간식"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        getPetRequest.delegate = self
        getPetIngredientRequest.delegate = self
        
        getPetRequest.fetch(vc: self, paramDict: ["peId": String(app.getUserPetId())])
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(bannerView)
        bannerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        bannerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        bannerView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1 / 3).isActive = true
        
        // MARK: ConfigureView - Search
        stackView.addArrangedSubview(searchContainerView)
        searchContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        searchContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        searchContainerView.addSubview(searchLabel)
        searchLabel.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        searchLabel.centerXAnchor.constraint(equalTo: searchContainerView.centerXAnchor).isActive = true
        
        // MARK: ConfigureView - Search - Disease
        searchContainerView.addSubview(searchDiseaseContainerView)
        searchDiseaseContainerView.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: SPACE_XXL).isActive = true
        searchDiseaseContainerView.centerXAnchor.constraint(equalTo: searchContainerView.centerXAnchor).isActive = true
        searchDiseaseContainerView.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -SPACE_XXL).isActive = true
        
        searchDiseaseContainerView.addSubview(searchDiseaseImageView)
        searchDiseaseImageView.topAnchor.constraint(equalTo: searchDiseaseContainerView.topAnchor).isActive = true
        searchDiseaseImageView.leadingAnchor.constraint(equalTo: searchDiseaseContainerView.leadingAnchor).isActive = true
        searchDiseaseImageView.trailingAnchor.constraint(equalTo: searchDiseaseContainerView.trailingAnchor).isActive = true
        searchDiseaseImageView.widthAnchor.constraint(equalToConstant: searchImageViewWidth).isActive = true
        searchDiseaseImageView.heightAnchor.constraint(equalToConstant: searchImageViewWidth).isActive = true
        
        searchDiseaseContainerView.addSubview(searchDiseaseLabel)
        searchDiseaseLabel.topAnchor.constraint(equalTo: searchDiseaseImageView.bottomAnchor, constant: SPACE_XS).isActive = true
        searchDiseaseLabel.centerXAnchor.constraint(equalTo: searchDiseaseContainerView.centerXAnchor).isActive = true
        searchDiseaseLabel.bottomAnchor.constraint(equalTo: searchDiseaseContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Search - Food
        searchContainerView.addSubview(searchFoodContainerView)
        searchFoodContainerView.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: SPACE_XXL).isActive = true
        searchFoodContainerView.trailingAnchor.constraint(equalTo: searchDiseaseContainerView.leadingAnchor, constant: -SPACE_XL).isActive = true
        searchFoodContainerView.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -SPACE_XXL).isActive = true
        
        searchFoodContainerView.addSubview(searchFoodImageView)
        searchFoodImageView.topAnchor.constraint(equalTo: searchFoodContainerView.topAnchor).isActive = true
        searchFoodImageView.leadingAnchor.constraint(equalTo: searchFoodContainerView.leadingAnchor).isActive = true
        searchFoodImageView.trailingAnchor.constraint(equalTo: searchFoodContainerView.trailingAnchor).isActive = true
        searchFoodImageView.widthAnchor.constraint(equalToConstant: searchImageViewWidth).isActive = true
        searchFoodImageView.heightAnchor.constraint(equalToConstant: searchImageViewWidth).isActive = true
        
        searchFoodContainerView.addSubview(searchFoodLabel)
        searchFoodLabel.topAnchor.constraint(equalTo: searchFoodImageView.bottomAnchor, constant: SPACE_XS).isActive = true
        searchFoodLabel.centerXAnchor.constraint(equalTo: searchFoodContainerView.centerXAnchor).isActive = true
        searchFoodLabel.bottomAnchor.constraint(equalTo: searchFoodContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Search - Symptom
        searchContainerView.addSubview(searchSymptomContainerView)
        searchSymptomContainerView.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: SPACE_XXL).isActive = true
        searchSymptomContainerView.leadingAnchor.constraint(equalTo: searchDiseaseContainerView.trailingAnchor, constant: SPACE_XL).isActive = true
        searchSymptomContainerView.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -SPACE_XXL).isActive = true
        
        searchSymptomContainerView.addSubview(searchSymptomImageView)
        searchSymptomImageView.topAnchor.constraint(equalTo: searchSymptomContainerView.topAnchor).isActive = true
        searchSymptomImageView.leadingAnchor.constraint(equalTo: searchSymptomContainerView.leadingAnchor).isActive = true
        searchSymptomImageView.trailingAnchor.constraint(equalTo: searchSymptomContainerView.trailingAnchor).isActive = true
        searchSymptomImageView.widthAnchor.constraint(equalToConstant: searchImageViewWidth).isActive = true
        searchSymptomImageView.heightAnchor.constraint(equalToConstant: searchImageViewWidth).isActive = true
        
        searchSymptomContainerView.addSubview(searchSymptomLabel)
        searchSymptomLabel.topAnchor.constraint(equalTo: searchSymptomImageView.bottomAnchor, constant: SPACE_XS).isActive = true
        searchSymptomLabel.centerXAnchor.constraint(equalTo: searchSymptomContainerView.centerXAnchor).isActive = true
        searchSymptomLabel.bottomAnchor.constraint(equalTo: searchSymptomContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Hot
        stackView.addArrangedSubview(hotContainerView)
        hotContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        hotContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        hotContainerView.addSubview(hotLabel)
        hotLabel.topAnchor.constraint(equalTo: hotContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        hotLabel.leadingAnchor.constraint(equalTo: hotContainerView.leadingAnchor).isActive = true
        hotLabel.bottomAnchor.constraint(equalTo: hotContainerView.bottomAnchor, constant: -SPACE_XXL).isActive = true
        
        hotContainerView.addSubview(moreHotImageView)
        moreHotImageView.centerYAnchor.constraint(equalTo: hotLabel.centerYAnchor).isActive = true
        moreHotImageView.trailingAnchor.constraint(equalTo: hotContainerView.trailingAnchor).isActive = true
        moreHotImageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        moreHotImageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        hotContainerView.addSubview(moreHotButton)
        moreHotButton.centerYAnchor.constraint(equalTo: moreHotImageView.centerYAnchor).isActive = true
        moreHotButton.trailingAnchor.constraint(equalTo: moreHotImageView.leadingAnchor).isActive = true
        
        stackView.addArrangedSubview(hotItemContainerView)
        hotItemContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        hotItemContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Hot - Supplement
        hotItemContainerView.addSubview(hotItemSupplementContainerView)
        hotItemSupplementContainerView.topAnchor.constraint(equalTo: hotItemContainerView.topAnchor).isActive = true
        hotItemSupplementContainerView.centerXAnchor.constraint(equalTo: hotItemContainerView.centerXAnchor).isActive = true
        hotItemSupplementContainerView.bottomAnchor.constraint(equalTo: hotItemContainerView.bottomAnchor).isActive = true
        
        hotItemSupplementContainerView.addSubview(hotItemSupplementImageView)
        hotItemSupplementImageView.topAnchor.constraint(equalTo: hotItemSupplementContainerView.topAnchor).isActive = true
        hotItemSupplementImageView.leadingAnchor.constraint(equalTo: hotItemSupplementContainerView.leadingAnchor).isActive = true
        hotItemSupplementImageView.trailingAnchor.constraint(equalTo: hotItemSupplementContainerView.trailingAnchor).isActive = true
        hotItemSupplementImageView.widthAnchor.constraint(equalToConstant: hotItemImageViewWidth).isActive = true
        hotItemSupplementImageView.heightAnchor.constraint(equalToConstant: hotItemImageViewheight).isActive = true
        
        hotItemSupplementContainerView.addSubview(hotItemSupplementLabelView)
        hotItemSupplementLabelView.topAnchor.constraint(equalTo: hotItemSupplementImageView.bottomAnchor).isActive = true
        hotItemSupplementLabelView.centerXAnchor.constraint(equalTo: hotItemSupplementContainerView.centerXAnchor).isActive = true
        hotItemSupplementLabelView.bottomAnchor.constraint(equalTo: hotItemSupplementContainerView.bottomAnchor).isActive = true
        
        hotItemSupplementLabelView.addSubview(hotItemSupplementLabel)
        hotItemSupplementLabel.topAnchor.constraint(equalTo: hotItemSupplementLabelView.topAnchor, constant: SPACE_XXXXS).isActive = true
        hotItemSupplementLabel.leadingAnchor.constraint(equalTo: hotItemSupplementLabelView.leadingAnchor, constant: SPACE_XS).isActive = true
        hotItemSupplementLabel.trailingAnchor.constraint(equalTo: hotItemSupplementLabelView.trailingAnchor, constant: -SPACE_XS).isActive = true
        hotItemSupplementLabel.bottomAnchor.constraint(equalTo: hotItemSupplementLabelView.bottomAnchor, constant: -SPACE_XXXXS).isActive = true
        
        // MARK: ConfigureView - Hot - Feed
        hotItemContainerView.addSubview(hotItemFeedContainerView)
        hotItemFeedContainerView.topAnchor.constraint(equalTo: hotItemContainerView.topAnchor).isActive = true
        hotItemFeedContainerView.trailingAnchor.constraint(equalTo: hotItemSupplementContainerView.leadingAnchor, constant: -SPACE_XL).isActive = true
        hotItemFeedContainerView.bottomAnchor.constraint(equalTo: hotItemContainerView.bottomAnchor).isActive = true
        
        hotItemFeedContainerView.addSubview(hotItemFeedImageView)
        hotItemFeedImageView.topAnchor.constraint(equalTo: hotItemFeedContainerView.topAnchor).isActive = true
        hotItemFeedImageView.leadingAnchor.constraint(equalTo: hotItemFeedContainerView.leadingAnchor).isActive = true
        hotItemFeedImageView.trailingAnchor.constraint(equalTo: hotItemFeedContainerView.trailingAnchor).isActive = true
        hotItemFeedImageView.widthAnchor.constraint(equalToConstant: hotItemImageViewWidth).isActive = true
        hotItemFeedImageView.heightAnchor.constraint(equalToConstant: hotItemImageViewheight).isActive = true
        
        hotItemFeedContainerView.addSubview(hotItemFeedLabelView)
        hotItemFeedLabelView.topAnchor.constraint(equalTo: hotItemFeedImageView.bottomAnchor).isActive = true
        hotItemFeedLabelView.centerXAnchor.constraint(equalTo: hotItemFeedContainerView.centerXAnchor).isActive = true
        hotItemFeedLabelView.bottomAnchor.constraint(equalTo: hotItemFeedContainerView.bottomAnchor).isActive = true
        
        hotItemFeedLabelView.addSubview(hotItemFeedLabel)
        hotItemFeedLabel.topAnchor.constraint(equalTo: hotItemFeedLabelView.topAnchor, constant: SPACE_XXXXS).isActive = true
        hotItemFeedLabel.leadingAnchor.constraint(equalTo: hotItemFeedLabelView.leadingAnchor, constant: SPACE_XS).isActive = true
        hotItemFeedLabel.trailingAnchor.constraint(equalTo: hotItemFeedLabelView.trailingAnchor, constant: -SPACE_XS).isActive = true
        hotItemFeedLabel.bottomAnchor.constraint(equalTo: hotItemFeedLabelView.bottomAnchor, constant: -SPACE_XXXXS).isActive = true
        
        // MARK: ConfigureView - Hot - Snack
        hotItemContainerView.addSubview(hotItemSnackContainerView)
        hotItemSnackContainerView.topAnchor.constraint(equalTo: hotItemContainerView.topAnchor).isActive = true
        hotItemSnackContainerView.leadingAnchor.constraint(equalTo: hotItemSupplementContainerView.trailingAnchor, constant: SPACE_XL).isActive = true
        hotItemSnackContainerView.bottomAnchor.constraint(equalTo: hotItemContainerView.bottomAnchor).isActive = true
        
        hotItemSnackContainerView.addSubview(hotItemSnackImageView)
        hotItemSnackImageView.topAnchor.constraint(equalTo: hotItemSnackContainerView.topAnchor).isActive = true
        hotItemSnackImageView.leadingAnchor.constraint(equalTo: hotItemSnackContainerView.leadingAnchor).isActive = true
        hotItemSnackImageView.trailingAnchor.constraint(equalTo: hotItemSnackContainerView.trailingAnchor).isActive = true
        hotItemSnackImageView.widthAnchor.constraint(equalToConstant: hotItemImageViewWidth).isActive = true
        hotItemSnackImageView.heightAnchor.constraint(equalToConstant: hotItemImageViewheight).isActive = true
        
        hotItemSnackContainerView.addSubview(hotItemSnackLabelView)
        hotItemSnackLabelView.topAnchor.constraint(equalTo: hotItemSnackImageView.bottomAnchor).isActive = true
        hotItemSnackLabelView.centerXAnchor.constraint(equalTo: hotItemSnackContainerView.centerXAnchor).isActive = true
        hotItemSnackLabelView.bottomAnchor.constraint(equalTo: hotItemSnackContainerView.bottomAnchor).isActive = true
        
        hotItemSnackLabelView.addSubview(hotItemSnackLabel)
        hotItemSnackLabel.topAnchor.constraint(equalTo: hotItemSnackLabelView.topAnchor, constant: SPACE_XXXXS).isActive = true
        hotItemSnackLabel.leadingAnchor.constraint(equalTo: hotItemSnackLabelView.leadingAnchor, constant: SPACE_XS).isActive = true
        hotItemSnackLabel.trailingAnchor.constraint(equalTo: hotItemSnackLabelView.trailingAnchor, constant: -SPACE_XS).isActive = true
        hotItemSnackLabel.bottomAnchor.constraint(equalTo: hotItemSnackLabelView.bottomAnchor, constant: -SPACE_XXXXS).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func searchDiseaseTapped() {
        print("searchDiseaseTapped")
    }
    
    @objc func searchFoodTapped() {
        print("searchFoodTapped")
    }
    
    @objc func searchSymptomTapped() {
        print("searchSymptomTapped")
    }
    
    @objc func moreHotTapped() {
        mainVC?.openProductListVC(category: "ALL")
    }
    
    @objc func hotItemSupplementTapped() {
        mainVC?.openProductListVC(category: "SUPPLEMENT")
    }
    
    @objc func hotItemFeedTapped() {
        mainVC?.openProductListVC(category: "FEED")
    }
    
    @objc func hotItemSnackTapped() {
        mainVC?.openProductListVC(category: "SNACK")
    }
}


// MARK: HTTP - GetPet
extension HomeViewController: GetPetRequestProtocol {
    func response(pet: Pet?, getPet status: String) {
        print("[HTTP RES]", getPetRequest.apiUrl, status)
        
        if status == "OK" {
            guard let pet = pet else { return }
            app.setPet(pet: pet)
            hotLabel.text = "\(pet.name) 친구들에게 핫한 아이템"
            
            showIndicator(idv: indicatorView, bov: blurOverlayView)
            getPetIngredientRequest.fetch(vc: self, paramDict: ["peId": String(pet.id)])
        }
    }
}

// MARK: HTTP - GetPetIngredient
extension HomeViewController: GetPetIngredientRequestProtocol {
    func response(warningFoodList: [Food]?, warningNutrientList: [Nutrient]?, goodFoodList: [Food]?, goodNutrientList: [Nutrient]?, similarGoodFoodList: [Food]?, similarGoodNutrientList: [Nutrient]?, similarCnt: Int?, weakDiseaseList: [Disease]?, getPetIngredient status: String) {
        print("[HTTP RES]", getPetIngredientRequest.apiUrl, status)
        
        if status == "OK" {
            guard let warningFoodList = warningFoodList else { return }
            guard let warningNutrientList = warningNutrientList else { return }
            guard let goodFoodList = goodFoodList else { return }
            guard let goodNutrientList = goodNutrientList else { return }
            guard let similarGoodFoodList = similarGoodFoodList else { return }
            guard let similarGoodNutrientList = similarGoodNutrientList else { return }
            guard let similarCnt = similarCnt else { return }
            guard let weakDiseaseList = weakDiseaseList else { return }
            
            app.setPetWarningFoodList(foodList: warningFoodList)
            app.setPetWarningNutrientList(nutrientList: warningNutrientList)
            app.setPetGoodFoodList(foodList: goodFoodList)
            app.setPetGoodNutrientList(nutrientList: goodNutrientList)
            app.setPetSimilarGoodFoodList(foodList: similarGoodFoodList)
            app.setPetSimilarGoodNutrientList(nutrientList: similarGoodNutrientList)
            app.setSimilarCnt(cnt: similarCnt)
            app.setWeakDiseaseList(diseaseList: weakDiseaseList)
        }
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
    }
}
