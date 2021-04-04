//
//  ProductIngredientViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/13.
//

import UIKit


class ProductIngredientViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var product: Product? {
        didSet {
            guard let product = self.product else { return }
            
            isModalInPresentation = true
            showIndicator(idv: indicatorView, bov: blurOverlayView)
            getProductIngredientRequest.fetch(vc: self, paramDict: ["pId": String(product.id)])
            
            // 제품이 사료라면
            if product.pcId == 1 { configureFeedNutrientView() }
        }
    }
    let productAllIngredientVC = ProductAllIngredientViewController()
    var warningFoodList: [Food] = []
    var warningNutrientList: [Nutrient] = []
    var goodFoodList: [Food] = []
    var goodNutrientList: [Nutrient] = []
    var similarGoodFoodList: [Food] = []
    var similarGoodNutrientList: [Nutrient] = []
    let getProductIngredientRequest = GetProductIngredientRequest()
    
    
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
        sv.spacing = SPACE_XXL
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Ingredient
    lazy var ingredientContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var ingredientTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "포함 성분"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var allIngredientView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allIngredientTapped)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var allIngredientLabel: UILabel = {
        let label = UILabel()
        label.text = "전체성분 살펴 보기"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var allIngredientImageView: UIImageView = {
        let img = UIImage(systemName: "chevron.right")
        let iv = UIImageView(image: img)
        iv.tintColor = .systemGray2
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var normalIngredientImageView: UIImageView = {
        let img = UIImage(imageLiteralResourceName: "ProductIngredientNormal")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var normalIngredientLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var goodIngredientImageView: UIImageView = {
        let img = UIImage(imageLiteralResourceName: "ProductIngredientGood")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var goodIngredientLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .mainColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var warningIngredientImageView: UIImageView = {
        let img = UIImage(imageLiteralResourceName: "ProductIngredientWarning")
        let iv = UIImageView(image: img)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var warningIngredientLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .warningColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - FeedNutrient
    lazy var feedNutrientContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var feedNutrientTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "영양정보"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var feedNutrientSubTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "수분 포함상태 기준"
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var feedNutrientAAFCOView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var feedNutrientAAFCOLabel: UILabel = {
        let label = UILabel()
        label.text = " AAFCO(미국사료협회)권장"
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var feedNutrientCurrentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var feedNutrientCurrentLabel: UILabel = {
        let label = UILabel()
        label.text = " 현재 사료 함유량"
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - FeedNutrient - Graph
    lazy var graphStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_L
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - FeedNutrient - Graph - Prot
    lazy var graphProtContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphProtTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "조단백"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphProtView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphAAFCOProtView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphProtLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphAAFCOProtLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - FeedNutrient - Graph - Fat
    lazy var graphFatContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphFatTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "조지방"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphFatView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphAAFCOFatView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphFatLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphAAFCOFatLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - FeedNutrient - Graph - Fibe
    lazy var graphFibeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphFibeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "조섬유"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphFibeView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphAAFCOFibeView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphFibeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphAAFCOFibeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - FeedNutrient - Graph - Ash
    lazy var graphAshContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphAshTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "조회분"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphAshView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphAAFCOAshView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphAshLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphAAFCOAshLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - FeedNutrient - Graph - Calc
    lazy var graphCalcContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphCalcTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "칼슘"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphCalcView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphAAFCOCalcView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphCalcLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphAAFCOCalcLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - FeedNutrient - Graph - Phos
    lazy var graphPhosContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphPhosTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "인"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphPhosView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphAAFCOPhosView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphPhosLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphAAFCOPhosLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - FeedNutrient - Graph - Mois
    lazy var graphMoisContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphMoisTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "수분"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphMoisView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphAAFCOMoisView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphMoisLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphAAFCOMoisLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
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
        
        navigationItem.title = "제품 성분분석"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        getProductIngredientRequest.delegate = self
        
        warningFoodList = app.getPetWarningFoodList()
        warningNutrientList = app.getPetWarningNutrientList()
        goodFoodList = app.getPetGoodFoodList()
        goodNutrientList = app.getPetGoodNutrientList()
        similarGoodFoodList = app.getPetSimilarGoodFoodList()
        similarGoodNutrientList = app.getPetSimilarGoodNutrientList()
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SPACE_XXL).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Ingredient
        stackView.addArrangedSubview(ingredientContainerView)
        ingredientContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        ingredientContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        ingredientContainerView.addSubview(ingredientTitleLabel)
        ingredientTitleLabel.topAnchor.constraint(equalTo: ingredientContainerView.topAnchor).isActive = true
        ingredientTitleLabel.leadingAnchor.constraint(equalTo: ingredientContainerView.leadingAnchor).isActive = true
        
        ingredientContainerView.addSubview(allIngredientView)
        allIngredientView.centerYAnchor.constraint(equalTo: ingredientTitleLabel.centerYAnchor).isActive = true
        allIngredientView.trailingAnchor.constraint(equalTo: ingredientContainerView.trailingAnchor).isActive = true
        
        allIngredientView.addSubview(allIngredientImageView)
        allIngredientImageView.trailingAnchor.constraint(equalTo: allIngredientView.trailingAnchor).isActive = true
        allIngredientImageView.topAnchor.constraint(equalTo: allIngredientView.topAnchor).isActive = true
        allIngredientImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        allIngredientImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        allIngredientImageView.bottomAnchor.constraint(equalTo: allIngredientView.bottomAnchor).isActive = true
        
        allIngredientView.addSubview(allIngredientLabel)
        allIngredientLabel.centerYAnchor.constraint(equalTo: allIngredientImageView.centerYAnchor).isActive = true
        allIngredientLabel.leadingAnchor.constraint(equalTo: allIngredientView.leadingAnchor).isActive = true
        allIngredientLabel.trailingAnchor.constraint(equalTo: allIngredientImageView.leadingAnchor).isActive = true
        
        ingredientContainerView.addSubview(normalIngredientImageView)
        normalIngredientImageView.topAnchor.constraint(equalTo: ingredientTitleLabel.bottomAnchor, constant: SPACE_XL).isActive = true
        normalIngredientImageView.centerXAnchor.constraint(equalTo: ingredientContainerView.centerXAnchor).isActive = true
        normalIngredientImageView.widthAnchor.constraint(equalTo: ingredientContainerView.widthAnchor, multiplier: 0.28).isActive = true
        normalIngredientImageView.heightAnchor.constraint(equalTo: ingredientContainerView.widthAnchor, multiplier: 0.28).isActive = true
        
        ingredientContainerView.addSubview(normalIngredientLabel)
        normalIngredientLabel.topAnchor.constraint(equalTo: normalIngredientImageView.bottomAnchor).isActive = true
        normalIngredientLabel.centerXAnchor.constraint(equalTo: normalIngredientImageView.centerXAnchor).isActive = true
        normalIngredientLabel.bottomAnchor.constraint(equalTo: ingredientContainerView.bottomAnchor).isActive = true
        
        ingredientContainerView.addSubview(goodIngredientImageView)
        goodIngredientImageView.topAnchor.constraint(equalTo: ingredientTitleLabel.bottomAnchor, constant: SPACE_XL).isActive = true
        goodIngredientImageView.leadingAnchor.constraint(equalTo: ingredientContainerView.leadingAnchor).isActive = true
        goodIngredientImageView.widthAnchor.constraint(equalTo: ingredientContainerView.widthAnchor, multiplier: 0.28).isActive = true
        goodIngredientImageView.heightAnchor.constraint(equalTo: ingredientContainerView.widthAnchor, multiplier: 0.28).isActive = true
        
        ingredientContainerView.addSubview(goodIngredientLabel)
        goodIngredientLabel.topAnchor.constraint(equalTo: goodIngredientImageView.bottomAnchor).isActive = true
        goodIngredientLabel.centerXAnchor.constraint(equalTo: goodIngredientImageView.centerXAnchor).isActive = true
        
        ingredientContainerView.addSubview(warningIngredientImageView)
        warningIngredientImageView.topAnchor.constraint(equalTo: ingredientTitleLabel.bottomAnchor, constant: SPACE_XL).isActive = true
        warningIngredientImageView.trailingAnchor.constraint(equalTo: ingredientContainerView.trailingAnchor).isActive = true
        warningIngredientImageView.widthAnchor.constraint(equalTo: ingredientContainerView.widthAnchor, multiplier: 0.28).isActive = true
        warningIngredientImageView.heightAnchor.constraint(equalTo: ingredientContainerView.widthAnchor, multiplier: 0.28).isActive = true
        
        ingredientContainerView.addSubview(warningIngredientLabel)
        warningIngredientLabel.topAnchor.constraint(equalTo: warningIngredientImageView.bottomAnchor).isActive = true
        warningIngredientLabel.centerXAnchor.constraint(equalTo: warningIngredientImageView.centerXAnchor).isActive = true
    }
    
    func configureFeedNutrientView() {
        guard let product = self.product else { return }
        
        guard let fnProt = product.fnProt else { return }
        guard let fnFat = product.fnFat else { return }
        guard let fnFibe = product.fnFibe else { return }
        guard let fnAsh = product.fnAsh else { return }
        guard let fnCalc = product.fnCalc else { return }
        guard let fnPhos = product.fnPhos else { return }
        guard let fnMois = product.fnMois else { return }
        
        let AAFCOProt = 18
        let AAFCOFat = 5.5
        let AAFCOFibe = 0
        let AAFCOAsh = 0
        let AAFCOCalc = 0.5
        let AAFCOPhos = 0.4
        let AAFCOMois = 0
        
        graphProtLabel.text = "\(String(fnProt))%"
        graphAAFCOProtLabel.text = "\(String(AAFCOProt))%"
        graphFatLabel.text = "\(String(fnFat))%"
        graphAAFCOFatLabel.text = "\(String(AAFCOFat))%"
        graphFibeLabel.text = "\(String(fnFibe))%"
        graphAAFCOFibeLabel.text = "\(String(AAFCOFibe))%"
        graphAshLabel.text = "\(String(fnAsh))%"
        graphAAFCOAshLabel.text = "\(String(AAFCOAsh))%"
        graphCalcLabel.text = "\(String(fnCalc))%"
        graphAAFCOCalcLabel.text = "\(String(AAFCOCalc))%"
        graphPhosLabel.text = "\(String(fnPhos))%"
        graphAAFCOPhosLabel.text = "\(String(AAFCOPhos))%"
        graphMoisLabel.text = "\(String(fnMois))%"
        graphAAFCOMoisLabel.text = "\(String(AAFCOMois))%"
        
        stackView.addArrangedSubview(feedNutrientContainerView)
        feedNutrientContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        feedNutrientContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        feedNutrientContainerView.addSubview(feedNutrientTitleLabel)
        feedNutrientTitleLabel.topAnchor.constraint(equalTo: feedNutrientContainerView.topAnchor).isActive = true
        feedNutrientTitleLabel.leadingAnchor.constraint(equalTo: feedNutrientContainerView.leadingAnchor).isActive = true
        
        feedNutrientContainerView.addSubview(feedNutrientSubTitleLabel)
        feedNutrientSubTitleLabel.centerYAnchor.constraint(equalTo: feedNutrientTitleLabel.centerYAnchor).isActive = true
        feedNutrientSubTitleLabel.leadingAnchor.constraint(equalTo: feedNutrientTitleLabel.trailingAnchor, constant: SPACE_XS).isActive = true
        
        feedNutrientContainerView.addSubview(feedNutrientAAFCOView)
        feedNutrientAAFCOView.topAnchor.constraint(equalTo: feedNutrientTitleLabel.bottomAnchor, constant: SPACE_L).isActive = true
        feedNutrientAAFCOView.leadingAnchor.constraint(equalTo: feedNutrientContainerView.leadingAnchor).isActive = true
        feedNutrientAAFCOView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        feedNutrientAAFCOView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        feedNutrientContainerView.addSubview(feedNutrientAAFCOLabel)
        feedNutrientAAFCOLabel.centerYAnchor.constraint(equalTo: feedNutrientAAFCOView.centerYAnchor).isActive = true
        feedNutrientAAFCOLabel.leadingAnchor.constraint(equalTo: feedNutrientAAFCOView.trailingAnchor).isActive = true
        
        feedNutrientContainerView.addSubview(feedNutrientCurrentView)
        feedNutrientCurrentView.centerYAnchor.constraint(equalTo: feedNutrientAAFCOView.centerYAnchor).isActive = true
        feedNutrientCurrentView.leadingAnchor.constraint(equalTo: feedNutrientAAFCOLabel.trailingAnchor, constant: SPACE_S).isActive = true
        feedNutrientCurrentView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        feedNutrientCurrentView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        feedNutrientContainerView.addSubview(feedNutrientCurrentLabel)
        feedNutrientCurrentLabel.centerYAnchor.constraint(equalTo: feedNutrientAAFCOView.centerYAnchor).isActive = true
        feedNutrientCurrentLabel.leadingAnchor.constraint(equalTo: feedNutrientCurrentView.trailingAnchor).isActive = true
        
        feedNutrientContainerView.addSubview(graphStackView)
        graphStackView.topAnchor.constraint(equalTo: feedNutrientAAFCOView.bottomAnchor, constant: SPACE_L).isActive = true
        graphStackView.leadingAnchor.constraint(equalTo: feedNutrientContainerView.leadingAnchor).isActive = true
        graphStackView.trailingAnchor.constraint(equalTo: feedNutrientContainerView.trailingAnchor).isActive = true
        graphStackView.bottomAnchor.constraint(equalTo: feedNutrientContainerView.bottomAnchor, constant: -SPACE_L).isActive = true
        
        // MARK: configureFeedNutrientView - Prot
        graphStackView.addArrangedSubview(graphProtContainerView)
        graphProtContainerView.leadingAnchor.constraint(equalTo: graphStackView.leadingAnchor).isActive = true
        graphProtContainerView.trailingAnchor.constraint(equalTo: graphStackView.trailingAnchor).isActive = true
        
        graphProtContainerView.addSubview(graphProtLabel)
        graphProtLabel.topAnchor.constraint(equalTo: graphProtContainerView.topAnchor).isActive = true
        graphProtLabel.trailingAnchor.constraint(equalTo: graphProtContainerView.trailingAnchor).isActive = true
        
        graphProtContainerView.addSubview(graphAAFCOProtLabel)
        graphAAFCOProtLabel.topAnchor.constraint(equalTo: graphProtLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        graphAAFCOProtLabel.trailingAnchor.constraint(equalTo: graphProtContainerView.trailingAnchor).isActive = true
        graphAAFCOProtLabel.bottomAnchor.constraint(equalTo: graphProtContainerView.bottomAnchor).isActive = true
        
        graphProtContainerView.addSubview(graphProtView)
        graphProtView.centerYAnchor.constraint(equalTo: graphProtLabel.centerYAnchor).isActive = true
        graphProtView.centerXAnchor.constraint(equalTo: graphProtContainerView.centerXAnchor).isActive = true
        graphProtView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphProtView.widthAnchor.constraint(equalTo: graphProtContainerView.widthAnchor, multiplier: 0.7).isActive = true
        
        graphProtContainerView.addSubview(graphAAFCOProtView)
        graphAAFCOProtView.centerYAnchor.constraint(equalTo: graphAAFCOProtLabel.centerYAnchor).isActive = true
        graphAAFCOProtView.centerXAnchor.constraint(equalTo: graphProtContainerView.centerXAnchor).isActive = true
        graphAAFCOProtView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphAAFCOProtView.widthAnchor.constraint(equalTo: graphProtContainerView.widthAnchor, multiplier: 0.7).isActive = true
        
        graphProtContainerView.addSubview(graphProtTitleLabel)
        graphProtTitleLabel.centerYAnchor.constraint(equalTo: graphProtContainerView.centerYAnchor).isActive = true
        graphProtTitleLabel.leadingAnchor.constraint(equalTo: graphProtContainerView.leadingAnchor).isActive = true
        
        let protGageView = UIView()
        protGageView.backgroundColor = .mainColor
        protGageView.translatesAutoresizingMaskIntoConstraints = false
        
        graphProtView.addSubview(protGageView)
        protGageView.topAnchor.constraint(equalTo: graphProtView.topAnchor).isActive = true
        protGageView.leadingAnchor.constraint(equalTo: graphProtView.leadingAnchor).isActive = true
        protGageView.widthAnchor.constraint(equalTo: graphProtView.widthAnchor, multiplier: CGFloat(fnProt) * 0.01).isActive = true
        protGageView.bottomAnchor.constraint(equalTo: graphProtView.bottomAnchor).isActive = true
        
        let AFFCOProtGageView = UIView()
        AFFCOProtGageView.backgroundColor = .systemGray2
        AFFCOProtGageView.translatesAutoresizingMaskIntoConstraints = false
        
        graphAAFCOProtView.addSubview(AFFCOProtGageView)
        AFFCOProtGageView.topAnchor.constraint(equalTo: graphAAFCOProtView.topAnchor).isActive = true
        AFFCOProtGageView.leadingAnchor.constraint(equalTo: graphAAFCOProtView.leadingAnchor).isActive = true
        AFFCOProtGageView.widthAnchor.constraint(equalTo: graphAAFCOProtView.widthAnchor, multiplier: CGFloat(AAFCOProt) * 0.01).isActive = true
        AFFCOProtGageView.bottomAnchor.constraint(equalTo: graphAAFCOProtView.bottomAnchor).isActive = true
        
        // MARK: configureFeedNutrientView - Fat
        graphStackView.addArrangedSubview(graphFatContainerView)
        graphFatContainerView.leadingAnchor.constraint(equalTo: graphStackView.leadingAnchor).isActive = true
        graphFatContainerView.trailingAnchor.constraint(equalTo: graphStackView.trailingAnchor).isActive = true
        
        graphFatContainerView.addSubview(graphFatLabel)
        graphFatLabel.topAnchor.constraint(equalTo: graphFatContainerView.topAnchor).isActive = true
        graphFatLabel.trailingAnchor.constraint(equalTo: graphFatContainerView.trailingAnchor).isActive = true
        
        graphFatContainerView.addSubview(graphAAFCOFatLabel)
        graphAAFCOFatLabel.topAnchor.constraint(equalTo: graphFatLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        graphAAFCOFatLabel.trailingAnchor.constraint(equalTo: graphFatContainerView.trailingAnchor).isActive = true
        graphAAFCOFatLabel.bottomAnchor.constraint(equalTo: graphFatContainerView.bottomAnchor).isActive = true
        
        graphFatContainerView.addSubview(graphFatView)
        graphFatView.centerYAnchor.constraint(equalTo: graphFatLabel.centerYAnchor).isActive = true
        graphFatView.centerXAnchor.constraint(equalTo: graphFatContainerView.centerXAnchor).isActive = true
        graphFatView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphFatView.widthAnchor.constraint(equalTo: graphFatContainerView.widthAnchor, multiplier: 0.7).isActive = true
        
        graphFatContainerView.addSubview(graphAAFCOFatView)
        graphAAFCOFatView.centerYAnchor.constraint(equalTo: graphAAFCOFatLabel.centerYAnchor).isActive = true
        graphAAFCOFatView.centerXAnchor.constraint(equalTo: graphFatContainerView.centerXAnchor).isActive = true
        graphAAFCOFatView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphAAFCOFatView.widthAnchor.constraint(equalTo: graphFatContainerView.widthAnchor, multiplier: 0.7).isActive = true
        
        graphFatContainerView.addSubview(graphFatTitleLabel)
        graphFatTitleLabel.centerYAnchor.constraint(equalTo: graphFatContainerView.centerYAnchor).isActive = true
        graphFatTitleLabel.leadingAnchor.constraint(equalTo: graphFatContainerView.leadingAnchor).isActive = true
        
        let fatGageView = UIView()
        fatGageView.backgroundColor = .mainColor
        fatGageView.translatesAutoresizingMaskIntoConstraints = false
        
        graphFatView.addSubview(fatGageView)
        fatGageView.topAnchor.constraint(equalTo: graphFatView.topAnchor).isActive = true
        fatGageView.leadingAnchor.constraint(equalTo: graphFatView.leadingAnchor).isActive = true
        fatGageView.widthAnchor.constraint(equalTo: graphFatView.widthAnchor, multiplier: CGFloat(fnFat) * 0.01).isActive = true
        fatGageView.bottomAnchor.constraint(equalTo: graphFatView.bottomAnchor).isActive = true
        
        let AFFCOFatGageView = UIView()
        AFFCOFatGageView.backgroundColor = .systemGray2
        AFFCOFatGageView.translatesAutoresizingMaskIntoConstraints = false
        
        graphAAFCOFatView.addSubview(AFFCOFatGageView)
        AFFCOFatGageView.topAnchor.constraint(equalTo: graphAAFCOFatView.topAnchor).isActive = true
        AFFCOFatGageView.leadingAnchor.constraint(equalTo: graphAAFCOFatView.leadingAnchor).isActive = true
        AFFCOFatGageView.widthAnchor.constraint(equalTo: graphAAFCOFatView.widthAnchor, multiplier: CGFloat(AAFCOFat) * 0.01).isActive = true
        AFFCOFatGageView.bottomAnchor.constraint(equalTo: graphAAFCOFatView.bottomAnchor).isActive = true
        
        // MARK: configureFeedNutrientView - Fibe
        graphStackView.addArrangedSubview(graphFibeContainerView)
        graphFibeContainerView.leadingAnchor.constraint(equalTo: graphStackView.leadingAnchor).isActive = true
        graphFibeContainerView.trailingAnchor.constraint(equalTo: graphStackView.trailingAnchor).isActive = true
        
        graphFibeContainerView.addSubview(graphFibeLabel)
        graphFibeLabel.topAnchor.constraint(equalTo: graphFibeContainerView.topAnchor).isActive = true
        graphFibeLabel.trailingAnchor.constraint(equalTo: graphFibeContainerView.trailingAnchor).isActive = true
        
        graphFibeContainerView.addSubview(graphAAFCOFibeLabel)
        graphAAFCOFibeLabel.topAnchor.constraint(equalTo: graphFibeLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        graphAAFCOFibeLabel.trailingAnchor.constraint(equalTo: graphFibeContainerView.trailingAnchor).isActive = true
        graphAAFCOFibeLabel.bottomAnchor.constraint(equalTo: graphFibeContainerView.bottomAnchor).isActive = true
        
        graphFibeContainerView.addSubview(graphFibeView)
        graphFibeView.centerYAnchor.constraint(equalTo: graphFibeLabel.centerYAnchor).isActive = true
        graphFibeView.centerXAnchor.constraint(equalTo: graphFibeContainerView.centerXAnchor).isActive = true
        graphFibeView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphFibeView.widthAnchor.constraint(equalTo: graphFibeContainerView.widthAnchor, multiplier: 0.7).isActive = true
        
        graphFibeContainerView.addSubview(graphAAFCOFibeView)
        graphAAFCOFibeView.centerYAnchor.constraint(equalTo: graphAAFCOFibeLabel.centerYAnchor).isActive = true
        graphAAFCOFibeView.centerXAnchor.constraint(equalTo: graphFibeContainerView.centerXAnchor).isActive = true
        graphAAFCOFibeView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphAAFCOFibeView.widthAnchor.constraint(equalTo: graphFibeContainerView.widthAnchor, multiplier: 0.7).isActive = true
        
        graphFibeContainerView.addSubview(graphFibeTitleLabel)
        graphFibeTitleLabel.centerYAnchor.constraint(equalTo: graphFibeContainerView.centerYAnchor).isActive = true
        graphFibeTitleLabel.leadingAnchor.constraint(equalTo: graphFibeContainerView.leadingAnchor).isActive = true
        
        let fibeGageView = UIView()
        fibeGageView.backgroundColor = .mainColor
        fibeGageView.translatesAutoresizingMaskIntoConstraints = false
        
        graphFibeView.addSubview(fibeGageView)
        fibeGageView.topAnchor.constraint(equalTo: graphFibeView.topAnchor).isActive = true
        fibeGageView.leadingAnchor.constraint(equalTo: graphFibeView.leadingAnchor).isActive = true
        fibeGageView.widthAnchor.constraint(equalTo: graphFibeView.widthAnchor, multiplier: CGFloat(fnFibe) * 0.01).isActive = true
        fibeGageView.bottomAnchor.constraint(equalTo: graphFibeView.bottomAnchor).isActive = true
        
        let AFFCOFibeGageView = UIView()
        AFFCOFibeGageView.backgroundColor = .systemGray2
        AFFCOFibeGageView.translatesAutoresizingMaskIntoConstraints = false
        
        graphAAFCOFibeView.addSubview(AFFCOFibeGageView)
        AFFCOFibeGageView.topAnchor.constraint(equalTo: graphAAFCOFibeView.topAnchor).isActive = true
        AFFCOFibeGageView.leadingAnchor.constraint(equalTo: graphAAFCOFibeView.leadingAnchor).isActive = true
        AFFCOFibeGageView.widthAnchor.constraint(equalTo: graphAAFCOFibeView.widthAnchor, multiplier: CGFloat(AAFCOFibe) * 0.01).isActive = true
        AFFCOFibeGageView.bottomAnchor.constraint(equalTo: graphAAFCOFibeView.bottomAnchor).isActive = true
        
        // MARK: configureFeedNutrientView - Ash
        graphStackView.addArrangedSubview(graphAshContainerView)
        graphAshContainerView.leadingAnchor.constraint(equalTo: graphStackView.leadingAnchor).isActive = true
        graphAshContainerView.trailingAnchor.constraint(equalTo: graphStackView.trailingAnchor).isActive = true
        
        graphAshContainerView.addSubview(graphAshLabel)
        graphAshLabel.topAnchor.constraint(equalTo: graphAshContainerView.topAnchor).isActive = true
        graphAshLabel.trailingAnchor.constraint(equalTo: graphAshContainerView.trailingAnchor).isActive = true
        
        graphAshContainerView.addSubview(graphAAFCOAshLabel)
        graphAAFCOAshLabel.topAnchor.constraint(equalTo: graphAshLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        graphAAFCOAshLabel.trailingAnchor.constraint(equalTo: graphAshContainerView.trailingAnchor).isActive = true
        graphAAFCOAshLabel.bottomAnchor.constraint(equalTo: graphAshContainerView.bottomAnchor).isActive = true
        
        graphAshContainerView.addSubview(graphAshView)
        graphAshView.centerYAnchor.constraint(equalTo: graphAshLabel.centerYAnchor).isActive = true
        graphAshView.centerXAnchor.constraint(equalTo: graphAshContainerView.centerXAnchor).isActive = true
        graphAshView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphAshView.widthAnchor.constraint(equalTo: graphAshContainerView.widthAnchor, multiplier: 0.7).isActive = true
        
        graphAshContainerView.addSubview(graphAAFCOAshView)
        graphAAFCOAshView.centerYAnchor.constraint(equalTo: graphAAFCOAshLabel.centerYAnchor).isActive = true
        graphAAFCOAshView.centerXAnchor.constraint(equalTo: graphAshContainerView.centerXAnchor).isActive = true
        graphAAFCOAshView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphAAFCOAshView.widthAnchor.constraint(equalTo: graphAshContainerView.widthAnchor, multiplier: 0.7).isActive = true
        
        graphAshContainerView.addSubview(graphAshTitleLabel)
        graphAshTitleLabel.centerYAnchor.constraint(equalTo: graphAshContainerView.centerYAnchor).isActive = true
        graphAshTitleLabel.leadingAnchor.constraint(equalTo: graphAshContainerView.leadingAnchor).isActive = true
        
        let ashGageView = UIView()
        ashGageView.backgroundColor = .mainColor
        ashGageView.translatesAutoresizingMaskIntoConstraints = false
        
        graphAshView.addSubview(ashGageView)
        ashGageView.topAnchor.constraint(equalTo: graphAshView.topAnchor).isActive = true
        ashGageView.leadingAnchor.constraint(equalTo: graphAshView.leadingAnchor).isActive = true
        ashGageView.widthAnchor.constraint(equalTo: graphAshView.widthAnchor, multiplier: CGFloat(fnAsh) * 0.01).isActive = true
        ashGageView.bottomAnchor.constraint(equalTo: graphAshView.bottomAnchor).isActive = true
        
        let AFFCOAshGageView = UIView()
        AFFCOAshGageView.backgroundColor = .systemGray2
        AFFCOAshGageView.translatesAutoresizingMaskIntoConstraints = false
        
        graphAAFCOAshView.addSubview(AFFCOAshGageView)
        AFFCOAshGageView.topAnchor.constraint(equalTo: graphAAFCOAshView.topAnchor).isActive = true
        AFFCOAshGageView.leadingAnchor.constraint(equalTo: graphAAFCOAshView.leadingAnchor).isActive = true
        AFFCOAshGageView.widthAnchor.constraint(equalTo: graphAAFCOAshView.widthAnchor, multiplier: CGFloat(AAFCOAsh) * 0.01).isActive = true
        AFFCOAshGageView.bottomAnchor.constraint(equalTo: graphAAFCOAshView.bottomAnchor).isActive = true
        
        // MARK: configureFeedNutrientView - Calc
        graphStackView.addArrangedSubview(graphCalcContainerView)
        graphCalcContainerView.leadingAnchor.constraint(equalTo: graphStackView.leadingAnchor).isActive = true
        graphCalcContainerView.trailingAnchor.constraint(equalTo: graphStackView.trailingAnchor).isActive = true
        
        graphCalcContainerView.addSubview(graphCalcLabel)
        graphCalcLabel.topAnchor.constraint(equalTo: graphCalcContainerView.topAnchor).isActive = true
        graphCalcLabel.trailingAnchor.constraint(equalTo: graphCalcContainerView.trailingAnchor).isActive = true
        
        graphCalcContainerView.addSubview(graphAAFCOCalcLabel)
        graphAAFCOCalcLabel.topAnchor.constraint(equalTo: graphCalcLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        graphAAFCOCalcLabel.trailingAnchor.constraint(equalTo: graphCalcContainerView.trailingAnchor).isActive = true
        graphAAFCOCalcLabel.bottomAnchor.constraint(equalTo: graphCalcContainerView.bottomAnchor).isActive = true
        
        graphCalcContainerView.addSubview(graphCalcView)
        graphCalcView.centerYAnchor.constraint(equalTo: graphCalcLabel.centerYAnchor).isActive = true
        graphCalcView.centerXAnchor.constraint(equalTo: graphCalcContainerView.centerXAnchor).isActive = true
        graphCalcView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphCalcView.widthAnchor.constraint(equalTo: graphCalcContainerView.widthAnchor, multiplier: 0.7).isActive = true
        
        graphCalcContainerView.addSubview(graphAAFCOCalcView)
        graphAAFCOCalcView.centerYAnchor.constraint(equalTo: graphAAFCOCalcLabel.centerYAnchor).isActive = true
        graphAAFCOCalcView.centerXAnchor.constraint(equalTo: graphCalcContainerView.centerXAnchor).isActive = true
        graphAAFCOCalcView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphAAFCOCalcView.widthAnchor.constraint(equalTo: graphCalcContainerView.widthAnchor, multiplier: 0.7).isActive = true
        
        graphCalcContainerView.addSubview(graphCalcTitleLabel)
        graphCalcTitleLabel.centerYAnchor.constraint(equalTo: graphCalcContainerView.centerYAnchor).isActive = true
        graphCalcTitleLabel.leadingAnchor.constraint(equalTo: graphCalcContainerView.leadingAnchor).isActive = true
        
        let calcGageView = UIView()
        calcGageView.backgroundColor = .mainColor
        calcGageView.translatesAutoresizingMaskIntoConstraints = false
        
        graphCalcView.addSubview(calcGageView)
        calcGageView.topAnchor.constraint(equalTo: graphCalcView.topAnchor).isActive = true
        calcGageView.leadingAnchor.constraint(equalTo: graphCalcView.leadingAnchor).isActive = true
        calcGageView.widthAnchor.constraint(equalTo: graphCalcView.widthAnchor, multiplier: CGFloat(fnCalc) * 0.01).isActive = true
        calcGageView.bottomAnchor.constraint(equalTo: graphCalcView.bottomAnchor).isActive = true
        
        let AFFCOCalcGageView = UIView()
        AFFCOCalcGageView.backgroundColor = .systemGray2
        AFFCOCalcGageView.translatesAutoresizingMaskIntoConstraints = false
        
        graphAAFCOCalcView.addSubview(AFFCOCalcGageView)
        AFFCOCalcGageView.topAnchor.constraint(equalTo: graphAAFCOCalcView.topAnchor).isActive = true
        AFFCOCalcGageView.leadingAnchor.constraint(equalTo: graphAAFCOCalcView.leadingAnchor).isActive = true
        AFFCOCalcGageView.widthAnchor.constraint(equalTo: graphAAFCOCalcView.widthAnchor, multiplier: CGFloat(AAFCOCalc) * 0.01).isActive = true
        AFFCOCalcGageView.bottomAnchor.constraint(equalTo: graphAAFCOCalcView.bottomAnchor).isActive = true
        
        // MARK: configureFeedNutrientView - Phos
        graphStackView.addArrangedSubview(graphPhosContainerView)
        graphPhosContainerView.leadingAnchor.constraint(equalTo: graphStackView.leadingAnchor).isActive = true
        graphPhosContainerView.trailingAnchor.constraint(equalTo: graphStackView.trailingAnchor).isActive = true
        
        graphPhosContainerView.addSubview(graphPhosLabel)
        graphPhosLabel.topAnchor.constraint(equalTo: graphPhosContainerView.topAnchor).isActive = true
        graphPhosLabel.trailingAnchor.constraint(equalTo: graphPhosContainerView.trailingAnchor).isActive = true
        
        graphPhosContainerView.addSubview(graphAAFCOPhosLabel)
        graphAAFCOPhosLabel.topAnchor.constraint(equalTo: graphPhosLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        graphAAFCOPhosLabel.trailingAnchor.constraint(equalTo: graphPhosContainerView.trailingAnchor).isActive = true
        graphAAFCOPhosLabel.bottomAnchor.constraint(equalTo: graphPhosContainerView.bottomAnchor).isActive = true
        
        graphPhosContainerView.addSubview(graphPhosView)
        graphPhosView.centerYAnchor.constraint(equalTo: graphPhosLabel.centerYAnchor).isActive = true
        graphPhosView.centerXAnchor.constraint(equalTo: graphPhosContainerView.centerXAnchor).isActive = true
        graphPhosView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphPhosView.widthAnchor.constraint(equalTo: graphPhosContainerView.widthAnchor, multiplier: 0.7).isActive = true
        
        graphPhosContainerView.addSubview(graphAAFCOPhosView)
        graphAAFCOPhosView.centerYAnchor.constraint(equalTo: graphAAFCOPhosLabel.centerYAnchor).isActive = true
        graphAAFCOPhosView.centerXAnchor.constraint(equalTo: graphPhosContainerView.centerXAnchor).isActive = true
        graphAAFCOPhosView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphAAFCOPhosView.widthAnchor.constraint(equalTo: graphPhosContainerView.widthAnchor, multiplier: 0.7).isActive = true
        
        graphPhosContainerView.addSubview(graphPhosTitleLabel)
        graphPhosTitleLabel.centerYAnchor.constraint(equalTo: graphPhosContainerView.centerYAnchor).isActive = true
        graphPhosTitleLabel.leadingAnchor.constraint(equalTo: graphPhosContainerView.leadingAnchor).isActive = true
        
        let phosGageView = UIView()
        phosGageView.backgroundColor = .mainColor
        phosGageView.translatesAutoresizingMaskIntoConstraints = false
        
        graphPhosView.addSubview(phosGageView)
        phosGageView.topAnchor.constraint(equalTo: graphPhosView.topAnchor).isActive = true
        phosGageView.leadingAnchor.constraint(equalTo: graphPhosView.leadingAnchor).isActive = true
        phosGageView.widthAnchor.constraint(equalTo: graphPhosView.widthAnchor, multiplier: CGFloat(fnPhos) * 0.01).isActive = true
        phosGageView.bottomAnchor.constraint(equalTo: graphPhosView.bottomAnchor).isActive = true
        
        let AFFCOPhosGageView = UIView()
        AFFCOPhosGageView.backgroundColor = .systemGray2
        AFFCOPhosGageView.translatesAutoresizingMaskIntoConstraints = false
        
        graphAAFCOPhosView.addSubview(AFFCOPhosGageView)
        AFFCOPhosGageView.topAnchor.constraint(equalTo: graphAAFCOPhosView.topAnchor).isActive = true
        AFFCOPhosGageView.leadingAnchor.constraint(equalTo: graphAAFCOPhosView.leadingAnchor).isActive = true
        AFFCOPhosGageView.widthAnchor.constraint(equalTo: graphAAFCOPhosView.widthAnchor, multiplier: CGFloat(AAFCOPhos) * 0.01).isActive = true
        AFFCOPhosGageView.bottomAnchor.constraint(equalTo: graphAAFCOPhosView.bottomAnchor).isActive = true
        
        // MARK: configureFeedNutrientView - Mois
        graphStackView.addArrangedSubview(graphMoisContainerView)
        graphMoisContainerView.leadingAnchor.constraint(equalTo: graphStackView.leadingAnchor).isActive = true
        graphMoisContainerView.trailingAnchor.constraint(equalTo: graphStackView.trailingAnchor).isActive = true
        
        graphMoisContainerView.addSubview(graphMoisLabel)
        graphMoisLabel.topAnchor.constraint(equalTo: graphMoisContainerView.topAnchor).isActive = true
        graphMoisLabel.trailingAnchor.constraint(equalTo: graphMoisContainerView.trailingAnchor).isActive = true
        
        graphMoisContainerView.addSubview(graphAAFCOMoisLabel)
        graphAAFCOMoisLabel.topAnchor.constraint(equalTo: graphMoisLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        graphAAFCOMoisLabel.trailingAnchor.constraint(equalTo: graphMoisContainerView.trailingAnchor).isActive = true
        graphAAFCOMoisLabel.bottomAnchor.constraint(equalTo: graphMoisContainerView.bottomAnchor).isActive = true
        
        graphMoisContainerView.addSubview(graphMoisView)
        graphMoisView.centerYAnchor.constraint(equalTo: graphMoisLabel.centerYAnchor).isActive = true
        graphMoisView.centerXAnchor.constraint(equalTo: graphMoisContainerView.centerXAnchor).isActive = true
        graphMoisView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphMoisView.widthAnchor.constraint(equalTo: graphMoisContainerView.widthAnchor, multiplier: 0.7).isActive = true
        
        graphMoisContainerView.addSubview(graphAAFCOMoisView)
        graphAAFCOMoisView.centerYAnchor.constraint(equalTo: graphAAFCOMoisLabel.centerYAnchor).isActive = true
        graphAAFCOMoisView.centerXAnchor.constraint(equalTo: graphMoisContainerView.centerXAnchor).isActive = true
        graphAAFCOMoisView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphAAFCOMoisView.widthAnchor.constraint(equalTo: graphMoisContainerView.widthAnchor, multiplier: 0.7).isActive = true
        
        graphMoisContainerView.addSubview(graphMoisTitleLabel)
        graphMoisTitleLabel.centerYAnchor.constraint(equalTo: graphMoisContainerView.centerYAnchor).isActive = true
        graphMoisTitleLabel.leadingAnchor.constraint(equalTo: graphMoisContainerView.leadingAnchor).isActive = true
        
        let moisGageView = UIView()
        moisGageView.backgroundColor = .mainColor
        moisGageView.translatesAutoresizingMaskIntoConstraints = false
        
        graphMoisView.addSubview(moisGageView)
        moisGageView.topAnchor.constraint(equalTo: graphMoisView.topAnchor).isActive = true
        moisGageView.leadingAnchor.constraint(equalTo: graphMoisView.leadingAnchor).isActive = true
        moisGageView.widthAnchor.constraint(equalTo: graphMoisView.widthAnchor, multiplier: CGFloat(fnMois) * 0.01).isActive = true
        moisGageView.bottomAnchor.constraint(equalTo: graphMoisView.bottomAnchor).isActive = true
        
        let AFFCOMoisGageView = UIView()
        AFFCOMoisGageView.backgroundColor = .systemGray2
        AFFCOMoisGageView.translatesAutoresizingMaskIntoConstraints = false
        
        graphAAFCOMoisView.addSubview(AFFCOMoisGageView)
        AFFCOMoisGageView.topAnchor.constraint(equalTo: graphAAFCOMoisView.topAnchor).isActive = true
        AFFCOMoisGageView.leadingAnchor.constraint(equalTo: graphAAFCOMoisView.leadingAnchor).isActive = true
        AFFCOMoisGageView.widthAnchor.constraint(equalTo: graphAAFCOMoisView.widthAnchor, multiplier: CGFloat(AAFCOMois) * 0.01).isActive = true
        AFFCOMoisGageView.bottomAnchor.constraint(equalTo: graphAAFCOMoisView.bottomAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func backTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func allIngredientTapped() {
        navigationController?.pushViewController(productAllIngredientVC, animated: true)
    }
}


// MARK: HTTP - GetProductIngredient
extension ProductIngredientViewController: GetProductIngredientRequestProtocol {
    func response(foodList: [Food]?, nutrientList: [Nutrient]?, getProductIngredient status: String) {
        print("[HTTP RES]", getProductIngredientRequest.apiUrl, status)
        
        isModalInPresentation = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(backTapped))
        
        if status == "OK" {
            guard let foodList = foodList else { return }
            guard let nutrientList = nutrientList else { return }
            
            var productWarningFoodList: [Food] = []
            var productWarningNutrientList: [Nutrient] = []
            var productGoodFoodList: [Food] = []
            var productGoodNutrientList: [Nutrient] = []
            var productNormalFoodList: [Food] = []
            var productNormalNutrientList: [Nutrient] = []
            
            for food in foodList {
                var isAppended = false
                
                for warningFood in warningFoodList {
                    if food.id == warningFood.id {
                        productWarningFoodList.append(food)
                        isAppended = true
                        break
                    }
                }
                for goodFood in goodFoodList {
                    if food.id == goodFood.id {
                        productGoodFoodList.append(food)
                        isAppended = true
                        break
                    }
                }
                for similarGoodFood in similarGoodFoodList {
                    if food.id == similarGoodFood.id {
                        var isAlreadyIn = false
                        for f in productGoodFoodList {
                            if f.id == food.id {
                                isAlreadyIn = true
                                break
                            }
                        }
                        if !isAlreadyIn {
                            productGoodFoodList.append(food)
                            isAppended = true
                            break
                        }
                    }
                }
                
                if !isAppended {
                    productNormalFoodList.append(food)
                }
            }
            
            for nutrient in nutrientList {
                var isAppended = false
                
                for warningNutrient in warningNutrientList {
                    if nutrient.id == warningNutrient.id {
                        productWarningNutrientList.append(nutrient)
                        isAppended = true
                        break
                    }
                }
                for goodNutrient in goodNutrientList {
                    if nutrient.id == goodNutrient.id {
                        productGoodNutrientList.append(nutrient)
                        isAppended = true
                        break
                    }
                }
                for similarGoodNutrient in similarGoodNutrientList {
                    if nutrient.id == similarGoodNutrient.id {
                        var isAlreadyIn = false
                        for n in productGoodNutrientList {
                            if n.id == nutrient.id {
                                isAlreadyIn = true
                                break
                            }
                        }
                        if !isAlreadyIn {
                            productGoodNutrientList.append(nutrient)
                            isAppended = true
                            break
                        }
                    }
                }
                
                if !isAppended {
                    productNormalNutrientList.append(nutrient)
                }
            }
            
            warningIngredientLabel.text = String(productWarningFoodList.count + productWarningNutrientList.count)
            goodIngredientLabel.text = String(productGoodFoodList.count + productGoodNutrientList.count)
            normalIngredientLabel.text = String(productNormalFoodList.count + productNormalNutrientList.count)
            
            productAllIngredientVC.configureIngredientView(productWarningFoodList: productWarningFoodList, productWarningNutrientList: productWarningNutrientList, productGoodFoodList: productGoodFoodList, productGoodNutrientList: productGoodNutrientList, productNormalFoodList: productNormalFoodList, productNormalNutrientList: productNormalNutrientList)
        }
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
    }
}
