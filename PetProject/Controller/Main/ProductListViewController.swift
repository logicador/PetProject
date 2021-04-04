//
//  ProductListViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/11.
//

import UIKit


class ProductListViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var mainVC: MainViewController?
    let productFilterList: [ProductFilter] = [
        ProductFilter(filter: "PALA", name: "기호성"),
        ProductFilter(filter: "BENE", name: "기대효과"),
        ProductFilter(filter: "COST", name: "가성비"),
        ProductFilter(filter: "SIDE", name: "부작용낮은순"),
        ProductFilter(filter: "RCNT", name: "최신순"),
        ProductFilter(filter: "BEST", name: "베스트순")
    ]
    var selectedTab: String = "SIMILAR" {
        didSet {
            if selectedTab == "SIMILAR" {
                tabButton.tintColor = .mainColor
                tabOtherButton.tintColor = .systemGray2
            } else {
                tabButton.tintColor = .systemGray2
                tabOtherButton.tintColor = .mainColor
            }
        }
    }
    var selectedCategory: String = "" {
        didSet {
            if selectedCategory == "ALL" {
                categoryAllButton.tintColor = .mainColor
                categoryFeedButton.tintColor = .systemGray3
                categorySupplementButton.tintColor = .systemGray3
                categorySnackButton.tintColor = .systemGray3
                
            } else if selectedCategory == "FEED" {
                categoryAllButton.tintColor = .systemGray3
                categoryFeedButton.tintColor = .mainColor
                categorySupplementButton.tintColor = .systemGray3
                categorySnackButton.tintColor = .systemGray3
                
            } else if selectedCategory == "SUPPLEMENT" {
                categoryAllButton.tintColor = .systemGray3
                categoryFeedButton.tintColor = .systemGray3
                categorySupplementButton.tintColor = .mainColor
                categorySnackButton.tintColor = .systemGray3
                
            } else {
                categoryAllButton.tintColor = .systemGray3
                categoryFeedButton.tintColor = .systemGray3
                categorySupplementButton.tintColor = .systemGray3
                categorySnackButton.tintColor = .mainColor
            }
            
            getProducts()
        }
    }
    var selectedFilter: ProductFilter = ProductFilter(filter: "RCNT", name: "최신순") {
        didSet {
            filterLabel.text = selectedFilter.name
            if selectedFilter.filter == "PALA" { pickerView.selectRow(0, inComponent: 0, animated: false) }
            else if selectedFilter.filter == "BENE" { pickerView.selectRow(1, inComponent: 0, animated: false) }
            else if selectedFilter.filter == "COST" { pickerView.selectRow(2, inComponent: 0, animated: false) }
            else if selectedFilter.filter == "SIDE" { pickerView.selectRow(3, inComponent: 0, animated: false) }
            else if selectedFilter.filter == "RCNT" { pickerView.selectRow(4, inComponent: 0, animated: false) }
            else { pickerView.selectRow(5, inComponent: 0, animated: false) }
        }
    }
    let getProductsRequest = GetProductsRequest()
    
    
    // MARK: View
    lazy var tabContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var tabCenterLine: LineView = {
        let lv = LineView(orientation: .vertical, width: 2)
        return lv
    }()
    lazy var tabButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .mainColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tag = 1
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(tabTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var tabOtherButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다른 친구들 추천", for: .normal)
        button.tintColor = .systemGray2
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.tag = 2
        button.addTarget(self, action: #selector(tabTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    // MARK: View - Category
    lazy var categoryContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var categoryFeedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("사료", for: .normal)
        button.tintColor = .systemGray3
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.tag = 2
        button.addTarget(self, action: #selector(categoryTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var categorySupplementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("영양제", for: .normal)
        button.tintColor = .systemGray3
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.tag = 3
        button.addTarget(self, action: #selector(categoryTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var categoryAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체", for: .normal)
        button.tintColor = .mainColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.tag = 1
        button.addTarget(self, action: #selector(categoryTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var categorySnackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("간식", for: .normal)
        button.tintColor = .systemGray3
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.tag = 4
        button.addTarget(self, action: #selector(categoryTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var categoryTopLine: LineView = {
        let lv = LineView()
        return lv
    }()
    lazy var categoryBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Other
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
        sv.spacing = SPACE_L
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var recommendDescLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        let mabs = NSMutableAttributedString()
            .bold("[\(app.getPetName()) 친구 추천]", fontSize: 14)
            .thin(" 카테고리에서는 견종 / 나이 / 성별 / BCS비만도 / 중성화수술 유무를 기준으로 나의 반려견과 유사한 반려견의 데이터만 제공됩니다.", fontSize: 14)
        label.attributedText = mabs
        label.setLineSpacing(lineSpacing: SPACE_XXXXS)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var filterContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var filterButtonView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(filterTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.text = "최신순"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var filterImageView: UIImageView = {
        let img = UIImage(systemName: "chevron.down")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray2
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var pickerOverlayView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickerOverlayTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var pickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.alpha = 0
        pv.backgroundColor = .white
        pv.delegate = self
        pv.dataSource = self
        pv.selectRow(4, inComponent: 0, animated: false)
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    lazy var productContainerStackView: UIStackView = {
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
        
        configureView()
        
        getProductsRequest.delegate = self
        
        tabButton.setTitle("\(app.getPetName()) 친구 추천", for: .normal)
        
        if selectedCategory.isEmpty { selectedCategory = "ALL" }
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(tabContainerView)
        tabContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tabContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tabContainerView.addSubview(tabButton)
        tabButton.topAnchor.constraint(equalTo: tabContainerView.topAnchor).isActive = true
        tabButton.leadingAnchor.constraint(equalTo: tabContainerView.leadingAnchor).isActive = true
        tabButton.widthAnchor.constraint(equalTo: tabContainerView.widthAnchor, multiplier: 0.5).isActive = true
        tabButton.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        
        tabContainerView.addSubview(tabOtherButton)
        tabOtherButton.topAnchor.constraint(equalTo: tabContainerView.topAnchor).isActive = true
        tabOtherButton.trailingAnchor.constraint(equalTo: tabContainerView.trailingAnchor).isActive = true
        tabOtherButton.widthAnchor.constraint(equalTo: tabContainerView.widthAnchor, multiplier: 0.5).isActive = true
        tabOtherButton.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        
        tabContainerView.addSubview(tabCenterLine)
        tabCenterLine.centerXAnchor.constraint(equalTo: tabContainerView.centerXAnchor).isActive = true
        tabCenterLine.topAnchor.constraint(equalTo: tabContainerView.topAnchor, constant: SPACE_XS + SPACE_XXXXS).isActive = true
        tabCenterLine.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor, constant: -(SPACE_XS + SPACE_XXXXS)).isActive = true
        
        view.addSubview(tabBottomLine)
        tabBottomLine.topAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        tabBottomLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabBottomLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(tabSpaceView)
        tabSpaceView.topAnchor.constraint(equalTo: tabBottomLine.bottomAnchor).isActive = true
        tabSpaceView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabSpaceView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabSpaceView.heightAnchor.constraint(equalToConstant: SPACE_XS).isActive = true
        
        // MARK: ConfigureView - Category
        view.addSubview(categoryTopLine)
        categoryTopLine.topAnchor.constraint(equalTo: tabSpaceView.bottomAnchor).isActive = true
        categoryTopLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoryTopLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(categoryContainerView)
        categoryContainerView.topAnchor.constraint(equalTo: categoryTopLine.bottomAnchor).isActive = true
        categoryContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoryContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        categoryContainerView.addSubview(categoryFeedButton)
        categoryFeedButton.topAnchor.constraint(equalTo: categoryContainerView.topAnchor).isActive = true
        categoryFeedButton.trailingAnchor.constraint(equalTo: categoryContainerView.centerXAnchor, constant: -SPACE_S).isActive = true
        categoryFeedButton.bottomAnchor.constraint(equalTo: categoryContainerView.bottomAnchor).isActive = true
        
        categoryContainerView.addSubview(categorySupplementButton)
        categorySupplementButton.topAnchor.constraint(equalTo: categoryContainerView.topAnchor).isActive = true
        categorySupplementButton.leadingAnchor.constraint(equalTo: categoryContainerView.centerXAnchor, constant: SPACE_S).isActive = true
        categorySupplementButton.bottomAnchor.constraint(equalTo: categoryContainerView.bottomAnchor).isActive = true
        
        categoryContainerView.addSubview(categoryAllButton)
        categoryAllButton.topAnchor.constraint(equalTo: categoryContainerView.topAnchor).isActive = true
        categoryAllButton.trailingAnchor.constraint(equalTo: categoryFeedButton.leadingAnchor, constant: -SPACE_XL).isActive = true
        categoryAllButton.bottomAnchor.constraint(equalTo: categoryContainerView.bottomAnchor).isActive = true
        
        categoryContainerView.addSubview(categorySnackButton)
        categorySnackButton.topAnchor.constraint(equalTo: categoryContainerView.topAnchor).isActive = true
        categorySnackButton.leadingAnchor.constraint(equalTo: categorySupplementButton.trailingAnchor, constant: SPACE_XL).isActive = true
        categorySnackButton.bottomAnchor.constraint(equalTo: categoryContainerView.bottomAnchor).isActive = true
        
        view.addSubview(categoryBottomLine)
        categoryBottomLine.topAnchor.constraint(equalTo: categoryContainerView.bottomAnchor).isActive = true
        categoryBottomLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoryBottomLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Other
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: categoryBottomLine.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SPACE_L).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(recommendDescLabel)
        recommendDescLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        recommendDescLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XXXS).isActive = true
        
        stackView.addArrangedSubview(filterContainerView)
        filterContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        filterContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        filterContainerView.addSubview(filterButtonView)
        filterButtonView.topAnchor.constraint(equalTo: filterContainerView.topAnchor).isActive = true
        filterButtonView.trailingAnchor.constraint(equalTo: filterContainerView.trailingAnchor).isActive = true
        filterButtonView.bottomAnchor.constraint(equalTo: filterContainerView.bottomAnchor).isActive = true
        
        filterButtonView.addSubview(filterLabel)
        filterLabel.topAnchor.constraint(equalTo: filterButtonView.topAnchor, constant: SPACE_XXS).isActive = true
        filterLabel.leadingAnchor.constraint(equalTo: filterButtonView.leadingAnchor, constant: SPACE_XS).isActive = true
        filterLabel.bottomAnchor.constraint(equalTo: filterButtonView.bottomAnchor, constant: -SPACE_XXS).isActive = true
        
        filterButtonView.addSubview(filterImageView)
        filterImageView.leadingAnchor.constraint(equalTo: filterLabel.trailingAnchor, constant: SPACE_XXS).isActive = true
        filterImageView.centerYAnchor.constraint(equalTo: filterLabel.centerYAnchor).isActive = true
        filterImageView.trailingAnchor.constraint(equalTo: filterButtonView.trailingAnchor, constant: -SPACE_XS).isActive = true
        filterImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        filterImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        stackView.addArrangedSubview(productContainerStackView)
        productContainerStackView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        productContainerStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        view.addSubview(pickerOverlayView)
        pickerOverlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pickerOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickerOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pickerOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        pickerOverlayView.addSubview(pickerView)
        pickerView.leadingAnchor.constraint(equalTo: pickerOverlayView.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: pickerOverlayView.trailingAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: pickerOverlayView.bottomAnchor).isActive = true
    }
    
    func getProducts() {
        showIndicator(idv: indicatorView, bov: blurOverlayView)
        getProductsRequest.fetch(vc: self, paramDict: ["peId": String(app.getPetId()), "tab": selectedTab, "category": selectedCategory, "filter": selectedFilter.filter])
    }
    
    // MARK: Function - @OBJC
    @objc func tabTapped(sender: UIButton) {
        if sender.tag == 1 {
            tabButton.tintColor = .mainColor
            tabOtherButton.tintColor = .systemGray2
            selectedTab = "SIMILAR"
        } else {
            tabButton.tintColor = .systemGray2
            tabOtherButton.tintColor = .mainColor
            selectedTab = "OTHER"
        }
        getProducts()
    }
    
    @objc func categoryTapped(sender: UIButton) {
        if sender.tag == 1 { selectedCategory = "ALL" }
        else if sender.tag == 2 { selectedCategory = "FEED" }
        else if sender.tag == 3 { selectedCategory = "SUPPLEMENT" }
        else { selectedCategory = "SNACK" }
    }
    
    @objc func filterTapped() {
        pickerOverlayView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.pickerOverlayView.alpha = 1
            self.pickerView.alpha = 1
        })
    }
    
    @objc func pickerOverlayTapped() {
        UIView.animate(withDuration: 0.2, animations: {
            self.pickerOverlayView.alpha = 0
            self.pickerView.alpha = 0
        }, completion: { (_) in
            self.pickerOverlayView.isHidden = false
        })
    }
}


// MARK: PickerView
extension ProductListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return productFilterList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return productFilterList[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFilter = productFilterList[row]
        getProducts()
    }
}

// MARK: HTTP - GetProducts
extension ProductListViewController: GetProductsRequestProtocol {
    func response(productList: [Product]?, getProducts status: String) {
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
        
        if status == "OK" {
            guard let productList = productList else { return }
            productContainerStackView.removeAllChildView()
            
            for (i, product) in productList.enumerated() {
                let pv = ProductView()
                pv.product = product
                pv.delegate = self
                
                productContainerStackView.addArrangedSubview(pv)
                pv.leadingAnchor.constraint(equalTo: productContainerStackView.leadingAnchor).isActive = true
                pv.trailingAnchor.constraint(equalTo: productContainerStackView.trailingAnchor).isActive = true
                
                if i == productList.count - 1 {
                    pv.bottomLine.isHidden = true
                }
            }
        }
    }
}

// MARK: ProductView
extension ProductListViewController: ProductViewProtocol {
    func selectProduct(product: Product) {
        let productVC = ProductViewController()
        productVC.product = product
        navigationController?.pushViewController(productVC, animated: true)
    }
}
