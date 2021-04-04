//
//  ProductReviewViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/13.
//

import UIKit


class ProductReviewViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    var product: Product? {
        didSet {
            guard let product = self.product else { return }
            
            isModalInPresentation = true
            showIndicator(idv: indicatorView, bov: blurOverlayView)
            getProductReviewRequest.fetch(vc: self, paramDict: ["pId": String(product.id), "peId": String(app.getPetId())])
        }
    }
    let getProductReviewRequest = GetProductReviewRequest()
    
    
    // MARK: View
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var writeReviewButton: ConfirmButton = {
        let cb = ConfirmButton(type: .system)
        cb.setActive(isActive: true)
        cb.setTitle("리뷰 작성하기", for: .normal)
        cb.titleLabel?.font = .boldSystemFont(ofSize: 20)
        cb.addTarget(self, action: #selector(writeReviewTapped), for: .touchUpInside)
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
    
    // MARK: View - Header
    lazy var headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var headerSimilarStarView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var headerSimilarStarLabel: UILabel = {
        let label = UILabel()
        label.text = "유사견 별점"
        label.textColor = .mainColor
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var headerStarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var headerStarLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 별점"
        label.textColor = .systemGray2
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var graphStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_L
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Graph - Pala
    lazy var graphPalaContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphSimilarPalaView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphPalaView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphPalaTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "기호성"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphSimilarPalaLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphPalaLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Graph - Bene
    lazy var graphBeneContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphSimilarBeneView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphBeneView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphBeneTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "기대효과"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphSimilarBeneLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphBeneLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Graph - Cost
    lazy var graphCostContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphSimilarCostView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphCostView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphCostTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가성비"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphSimilarCostLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphCostLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Graph - Side
    lazy var graphSideContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphSimilarSideView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphSideView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphSideTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "부작용(%)"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphSimilarSideLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var graphSideLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Score
    lazy var scoreContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var similarScoreImageView: UIImageView = {
        let img = UIImage(systemName: "star.fill")
        let iv = UIImageView(image: img)
        iv.tintColor = .mainColor
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var similarScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var scoreImageView: UIImageView = {
        let img = UIImage(systemName: "star.fill")
        let iv = UIImageView(image: img)
        iv.tintColor = .systemGray2
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var reviewCntLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var reviewCntTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "리뷰"
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var scoreBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    lazy var reviewStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XXL
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
        
        navigationItem.title = "제품 리뷰"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        getProductReviewRequest.delegate = self
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(bottomView)
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        bottomView.addSubview(writeReviewButton)
        writeReviewButton.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        writeReviewButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        writeReviewButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        writeReviewButton.heightAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.12).isActive = true
        writeReviewButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SPACE_XXL).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SPACE_XXL).isActive = true
        
        // MARK: ConfigureView - Header
        stackView.addArrangedSubview(headerContainerView)
        headerContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        headerContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        headerContainerView.addSubview(headerSimilarStarView)
        headerSimilarStarView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        headerSimilarStarView.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        headerSimilarStarView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        headerSimilarStarView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        headerSimilarStarView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true
        
        headerContainerView.addSubview(headerSimilarStarLabel)
        headerSimilarStarLabel.leadingAnchor.constraint(equalTo: headerSimilarStarView.trailingAnchor, constant: SPACE_XS).isActive = true
        headerSimilarStarLabel.centerYAnchor.constraint(equalTo: headerSimilarStarView.centerYAnchor).isActive = true
        
        headerContainerView.addSubview(headerStarView)
        headerStarView.leadingAnchor.constraint(equalTo: headerSimilarStarLabel.trailingAnchor, constant: SPACE).isActive = true
        headerStarView.centerYAnchor.constraint(equalTo: headerSimilarStarView.centerYAnchor).isActive = true
        headerStarView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        headerStarView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        headerContainerView.addSubview(headerStarLabel)
        headerStarLabel.leadingAnchor.constraint(equalTo: headerStarView.trailingAnchor, constant: SPACE_XS).isActive = true
        headerStarLabel.centerYAnchor.constraint(equalTo: headerSimilarStarView.centerYAnchor).isActive = true
        
        stackView.addArrangedSubview(graphStackView)
        graphStackView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        graphStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        // MARK: ConfigureView - Graph - Pala
        graphStackView.addArrangedSubview(graphPalaContainerView)
        graphPalaContainerView.leadingAnchor.constraint(equalTo: graphStackView.leadingAnchor).isActive = true
        graphPalaContainerView.trailingAnchor.constraint(equalTo: graphStackView.trailingAnchor).isActive = true
        
        graphPalaContainerView.addSubview(graphSimilarPalaLabel)
        graphSimilarPalaLabel.topAnchor.constraint(equalTo: graphPalaContainerView.topAnchor).isActive = true
        graphSimilarPalaLabel.trailingAnchor.constraint(equalTo: graphPalaContainerView.trailingAnchor).isActive = true
        
        graphPalaContainerView.addSubview(graphPalaLabel)
        graphPalaLabel.topAnchor.constraint(equalTo: graphSimilarPalaLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        graphPalaLabel.trailingAnchor.constraint(equalTo: graphPalaContainerView.trailingAnchor).isActive = true
        graphPalaLabel.bottomAnchor.constraint(equalTo: graphPalaContainerView.bottomAnchor).isActive = true
        
        graphPalaContainerView.addSubview(graphSimilarPalaView)
        graphSimilarPalaView.centerYAnchor.constraint(equalTo: graphSimilarPalaLabel.centerYAnchor).isActive = true
        graphSimilarPalaView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphSimilarPalaView.trailingAnchor.constraint(equalTo: graphPalaContainerView.trailingAnchor, constant: -(SCREEN_WIDTH * 0.09)).isActive = true
        
        graphPalaContainerView.addSubview(graphPalaView)
        graphPalaView.centerYAnchor.constraint(equalTo: graphPalaLabel.centerYAnchor).isActive = true
        graphPalaView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphPalaView.trailingAnchor.constraint(equalTo: graphPalaContainerView.trailingAnchor, constant: -(SCREEN_WIDTH * 0.09)).isActive = true
        
        graphPalaContainerView.addSubview(graphPalaTitleLabel)
        graphPalaTitleLabel.centerYAnchor.constraint(equalTo: graphPalaContainerView.centerYAnchor).isActive = true
        graphPalaTitleLabel.leadingAnchor.constraint(equalTo: graphPalaContainerView.leadingAnchor).isActive = true
        
        // MARK: ConfigureView - Graph - Bene
        graphStackView.addArrangedSubview(graphBeneContainerView)
        graphBeneContainerView.leadingAnchor.constraint(equalTo: graphStackView.leadingAnchor).isActive = true
        graphBeneContainerView.trailingAnchor.constraint(equalTo: graphStackView.trailingAnchor).isActive = true
        
        graphBeneContainerView.addSubview(graphSimilarBeneLabel)
        graphSimilarBeneLabel.topAnchor.constraint(equalTo: graphBeneContainerView.topAnchor).isActive = true
        graphSimilarBeneLabel.trailingAnchor.constraint(equalTo: graphBeneContainerView.trailingAnchor).isActive = true
        
        graphBeneContainerView.addSubview(graphBeneLabel)
        graphBeneLabel.topAnchor.constraint(equalTo: graphSimilarBeneLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        graphBeneLabel.trailingAnchor.constraint(equalTo: graphBeneContainerView.trailingAnchor).isActive = true
        graphBeneLabel.bottomAnchor.constraint(equalTo: graphBeneContainerView.bottomAnchor).isActive = true
        
        graphBeneContainerView.addSubview(graphSimilarBeneView)
        graphSimilarBeneView.centerYAnchor.constraint(equalTo: graphSimilarBeneLabel.centerYAnchor).isActive = true
        graphSimilarBeneView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphSimilarBeneView.trailingAnchor.constraint(equalTo: graphBeneContainerView.trailingAnchor, constant: -(SCREEN_WIDTH * 0.09)).isActive = true
        
        graphBeneContainerView.addSubview(graphBeneView)
        graphBeneView.centerYAnchor.constraint(equalTo: graphBeneLabel.centerYAnchor).isActive = true
        graphBeneView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphBeneView.trailingAnchor.constraint(equalTo: graphBeneContainerView.trailingAnchor, constant: -(SCREEN_WIDTH * 0.09)).isActive = true
        
        graphBeneContainerView.addSubview(graphBeneTitleLabel)
        graphBeneTitleLabel.centerYAnchor.constraint(equalTo: graphBeneContainerView.centerYAnchor).isActive = true
        graphBeneTitleLabel.leadingAnchor.constraint(equalTo: graphBeneContainerView.leadingAnchor).isActive = true
        
        // MARK: ConfigureView - Graph - Cost
        graphStackView.addArrangedSubview(graphCostContainerView)
        graphCostContainerView.leadingAnchor.constraint(equalTo: graphStackView.leadingAnchor).isActive = true
        graphCostContainerView.trailingAnchor.constraint(equalTo: graphStackView.trailingAnchor).isActive = true
        
        graphCostContainerView.addSubview(graphSimilarCostLabel)
        graphSimilarCostLabel.topAnchor.constraint(equalTo: graphCostContainerView.topAnchor).isActive = true
        graphSimilarCostLabel.trailingAnchor.constraint(equalTo: graphCostContainerView.trailingAnchor).isActive = true
        
        graphCostContainerView.addSubview(graphCostLabel)
        graphCostLabel.topAnchor.constraint(equalTo: graphSimilarCostLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        graphCostLabel.trailingAnchor.constraint(equalTo: graphCostContainerView.trailingAnchor).isActive = true
        graphCostLabel.bottomAnchor.constraint(equalTo: graphCostContainerView.bottomAnchor).isActive = true
        
        graphCostContainerView.addSubview(graphSimilarCostView)
        graphSimilarCostView.centerYAnchor.constraint(equalTo: graphSimilarCostLabel.centerYAnchor).isActive = true
        graphSimilarCostView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphSimilarCostView.trailingAnchor.constraint(equalTo: graphCostContainerView.trailingAnchor, constant: -(SCREEN_WIDTH * 0.09)).isActive = true
        
        graphCostContainerView.addSubview(graphCostView)
        graphCostView.centerYAnchor.constraint(equalTo: graphCostLabel.centerYAnchor).isActive = true
        graphCostView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphCostView.trailingAnchor.constraint(equalTo: graphCostContainerView.trailingAnchor, constant: -(SCREEN_WIDTH * 0.09)).isActive = true
        
        graphCostContainerView.addSubview(graphCostTitleLabel)
        graphCostTitleLabel.centerYAnchor.constraint(equalTo: graphCostContainerView.centerYAnchor).isActive = true
        graphCostTitleLabel.leadingAnchor.constraint(equalTo: graphCostContainerView.leadingAnchor).isActive = true
        
        // MARK: ConfigureView - Graph - Side
        graphStackView.addArrangedSubview(graphSideContainerView)
        graphSideContainerView.leadingAnchor.constraint(equalTo: graphStackView.leadingAnchor).isActive = true
        graphSideContainerView.trailingAnchor.constraint(equalTo: graphStackView.trailingAnchor).isActive = true
        
        graphSideContainerView.addSubview(graphSimilarSideLabel)
        graphSimilarSideLabel.topAnchor.constraint(equalTo: graphSideContainerView.topAnchor).isActive = true
        graphSimilarSideLabel.leadingAnchor.constraint(equalTo: graphCostLabel.leadingAnchor).isActive = true
        graphSimilarSideLabel.trailingAnchor.constraint(equalTo: graphSideContainerView.trailingAnchor).isActive = true
        
        graphSideContainerView.addSubview(graphSideLabel)
        graphSideLabel.topAnchor.constraint(equalTo: graphSimilarSideLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        graphSideLabel.leadingAnchor.constraint(equalTo: graphCostLabel.leadingAnchor).isActive = true
        graphSideLabel.trailingAnchor.constraint(equalTo: graphSideContainerView.trailingAnchor).isActive = true
        graphSideLabel.bottomAnchor.constraint(equalTo: graphSideContainerView.bottomAnchor).isActive = true
        
        graphSideContainerView.addSubview(graphSimilarSideView)
        graphSimilarSideView.centerYAnchor.constraint(equalTo: graphSimilarSideLabel.centerYAnchor).isActive = true
        graphSimilarSideView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphSimilarSideView.trailingAnchor.constraint(equalTo: graphSideContainerView.trailingAnchor, constant: -(SCREEN_WIDTH * 0.09)).isActive = true
        
        graphSideContainerView.addSubview(graphSideView)
        graphSideView.centerYAnchor.constraint(equalTo: graphSideLabel.centerYAnchor).isActive = true
        graphSideView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        graphSideView.trailingAnchor.constraint(equalTo: graphSideContainerView.trailingAnchor, constant: -(SCREEN_WIDTH * 0.09)).isActive = true
        
        graphSideContainerView.addSubview(graphSideTitleLabel)
        graphSideTitleLabel.centerYAnchor.constraint(equalTo: graphSideContainerView.centerYAnchor).isActive = true
        graphSideTitleLabel.leadingAnchor.constraint(equalTo: graphSideContainerView.leadingAnchor).isActive = true
        
        graphSimilarPalaView.leadingAnchor.constraint(equalTo: graphSideTitleLabel.trailingAnchor, constant: SPACE_S).isActive = true
        graphPalaView.leadingAnchor.constraint(equalTo: graphSideTitleLabel.trailingAnchor, constant: SPACE_S).isActive = true
        graphSimilarBeneView.leadingAnchor.constraint(equalTo: graphSideTitleLabel.trailingAnchor, constant: SPACE_S).isActive = true
        graphBeneView.leadingAnchor.constraint(equalTo: graphSideTitleLabel.trailingAnchor, constant: SPACE_S).isActive = true
        graphSimilarCostView.leadingAnchor.constraint(equalTo: graphSideTitleLabel.trailingAnchor, constant: SPACE_S).isActive = true
        graphCostView.leadingAnchor.constraint(equalTo: graphSideTitleLabel.trailingAnchor, constant: SPACE_S).isActive = true
        graphSimilarSideView.leadingAnchor.constraint(equalTo: graphSideTitleLabel.trailingAnchor, constant: SPACE_S).isActive = true
        graphSideView.leadingAnchor.constraint(equalTo: graphSideTitleLabel.trailingAnchor, constant: SPACE_S).isActive = true
        
        // MARK: ConfigureView - Score
        stackView.addArrangedSubview(scoreContainerView)
        scoreContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        scoreContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        scoreContainerView.addSubview(similarScoreImageView)
        similarScoreImageView.topAnchor.constraint(equalTo: scoreContainerView.topAnchor).isActive = true
        similarScoreImageView.leadingAnchor.constraint(equalTo: scoreContainerView.leadingAnchor).isActive = true
        similarScoreImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        similarScoreImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scoreContainerView.addSubview(similarScoreLabel)
        similarScoreLabel.centerYAnchor.constraint(equalTo: similarScoreImageView.centerYAnchor).isActive = true
        similarScoreLabel.leadingAnchor.constraint(equalTo: similarScoreImageView.trailingAnchor, constant: SPACE_XXS).isActive = true
        
        scoreContainerView.addSubview(scoreImageView)
        scoreImageView.bottomAnchor.constraint(equalTo: similarScoreImageView.bottomAnchor).isActive = true
        scoreImageView.leadingAnchor.constraint(equalTo: similarScoreLabel.trailingAnchor, constant: SPACE_S).isActive = true
        scoreImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        scoreImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        scoreContainerView.addSubview(scoreLabel)
        scoreLabel.centerYAnchor.constraint(equalTo: scoreImageView.centerYAnchor).isActive = true
        scoreLabel.leadingAnchor.constraint(equalTo: scoreImageView.trailingAnchor, constant: SPACE_XXXS).isActive = true
        
        scoreContainerView.addSubview(reviewCntLabel)
        reviewCntLabel.centerYAnchor.constraint(equalTo: scoreImageView.centerYAnchor).isActive = true
        reviewCntLabel.trailingAnchor.constraint(equalTo: scoreContainerView.trailingAnchor).isActive = true
        
        scoreContainerView.addSubview(reviewCntTitleLabel)
        reviewCntTitleLabel.centerYAnchor.constraint(equalTo: reviewCntLabel.centerYAnchor).isActive = true
        reviewCntTitleLabel.trailingAnchor.constraint(equalTo: reviewCntLabel.leadingAnchor, constant: -SPACE_XS).isActive = true
        
        scoreContainerView.addSubview(scoreBottomLine)
        scoreBottomLine.topAnchor.constraint(equalTo: similarScoreImageView.bottomAnchor, constant: SPACE_S).isActive = true
        scoreBottomLine.leadingAnchor.constraint(equalTo: scoreContainerView.leadingAnchor).isActive = true
        scoreBottomLine.trailingAnchor.constraint(equalTo: scoreContainerView.trailingAnchor).isActive = true
        scoreBottomLine.bottomAnchor.constraint(equalTo: scoreContainerView.bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(reviewStackView)
        reviewStackView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        reviewStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func backTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func writeReviewTapped() {
        guard let product = self.product else { return }
        
        let productWriteReviewVC = ProductWriteReviewViewController()
        productWriteReviewVC.pId = product.id
        productWriteReviewVC.delegate = self
        navigationController?.pushViewController(productWriteReviewVC, animated: true)
    }
}


// MARK: HTTP - GetProductReview
extension ProductReviewViewController: GetProductReviewRequestProtocol {
    func response(reviewList: [Review]?, similarTotalScore: Double?, similarPalaScore: Double?, similarBeneScore: Double?, similarCostScore: Double?, similarSidePer: Int?, totalScore: Double?, palaScore: Double?, beneScore: Double?, costScore: Double?, sidePer: Int?, getProductReview status: String) {
        print("[HTTP RES]", getProductReviewRequest.apiUrl, status)
        
        isModalInPresentation = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(backTapped))
        
        if status == "OK" {
            guard let reviewList = reviewList else { return }
            reviewStackView.removeAllChildView()
            
            guard let similarTotalScore = similarTotalScore else { return }
            guard let similarPalaScore = similarPalaScore else { return }
            guard let similarBeneScore = similarBeneScore else { return }
            guard let similarCostScore = similarCostScore else { return }
            guard let similarSidePer = similarSidePer else { return }
            guard let totalScore = totalScore else { return }
            guard let palaScore = palaScore else { return }
            guard let beneScore = beneScore else { return }
            guard let costScore = costScore else { return }
            guard let sidePer = sidePer else { return }
            
            similarScoreLabel.text = String(format: "%.1f", similarTotalScore)
            scoreLabel.text = String(format: "%.1f", totalScore)
            reviewCntLabel.text = String(reviewList.count)
            
            // MARK: Graph - Pala
            graphSimilarPalaLabel.text = String(format: "%.1f", similarPalaScore)
            graphPalaLabel.text = String(format: "%.1f", palaScore)
            
            let similarPalaGageView = UIView()
            similarPalaGageView.backgroundColor = .mainColor
            similarPalaGageView.translatesAutoresizingMaskIntoConstraints = false
            
            graphSimilarPalaView.addSubview(similarPalaGageView)
            similarPalaGageView.topAnchor.constraint(equalTo: graphSimilarPalaView.topAnchor).isActive = true
            similarPalaGageView.leadingAnchor.constraint(equalTo: graphSimilarPalaView.leadingAnchor).isActive = true
            similarPalaGageView.widthAnchor.constraint(equalTo: graphSimilarPalaView.widthAnchor, multiplier: CGFloat(similarPalaScore) * 0.2).isActive = true
            similarPalaGageView.bottomAnchor.constraint(equalTo: graphSimilarPalaView.bottomAnchor).isActive = true
            
            let palaGageView = UIView()
            palaGageView.backgroundColor = .systemGray2
            palaGageView.translatesAutoresizingMaskIntoConstraints = false
            
            graphPalaView.addSubview(palaGageView)
            palaGageView.topAnchor.constraint(equalTo: graphPalaView.topAnchor).isActive = true
            palaGageView.leadingAnchor.constraint(equalTo: graphPalaView.leadingAnchor).isActive = true
            palaGageView.widthAnchor.constraint(equalTo: graphPalaView.widthAnchor, multiplier: CGFloat(palaScore) * 0.2).isActive = true
            palaGageView.bottomAnchor.constraint(equalTo: graphPalaView.bottomAnchor).isActive = true
            
            // MARK: Graph - Bene
            graphSimilarBeneLabel.text = String(format: "%.1f", similarBeneScore)
            graphBeneLabel.text = String(format: "%.1f", beneScore)
            
            let similarBeneGageView = UIView()
            similarBeneGageView.backgroundColor = .mainColor
            similarBeneGageView.translatesAutoresizingMaskIntoConstraints = false
            
            graphSimilarBeneView.addSubview(similarBeneGageView)
            similarBeneGageView.topAnchor.constraint(equalTo: graphSimilarBeneView.topAnchor).isActive = true
            similarBeneGageView.leadingAnchor.constraint(equalTo: graphSimilarBeneView.leadingAnchor).isActive = true
            similarBeneGageView.widthAnchor.constraint(equalTo: graphSimilarBeneView.widthAnchor, multiplier: CGFloat(similarBeneScore) * 0.2).isActive = true
            similarBeneGageView.bottomAnchor.constraint(equalTo: graphSimilarBeneView.bottomAnchor).isActive = true
            
            let beneGageView = UIView()
            beneGageView.backgroundColor = .systemGray2
            beneGageView.translatesAutoresizingMaskIntoConstraints = false
            
            graphBeneView.addSubview(beneGageView)
            beneGageView.topAnchor.constraint(equalTo: graphBeneView.topAnchor).isActive = true
            beneGageView.leadingAnchor.constraint(equalTo: graphBeneView.leadingAnchor).isActive = true
            beneGageView.widthAnchor.constraint(equalTo: graphBeneView.widthAnchor, multiplier: CGFloat(beneScore) * 0.2).isActive = true
            beneGageView.bottomAnchor.constraint(equalTo: graphBeneView.bottomAnchor).isActive = true
            
            // MARK: Graph - Cost
            graphSimilarCostLabel.text = String(format: "%.1f", similarCostScore)
            graphCostLabel.text = String(format: "%.1f", costScore)
            
            let similarCostGageView = UIView()
            similarCostGageView.backgroundColor = .mainColor
            similarCostGageView.translatesAutoresizingMaskIntoConstraints = false
            
            graphSimilarCostView.addSubview(similarCostGageView)
            similarCostGageView.topAnchor.constraint(equalTo: graphSimilarCostView.topAnchor).isActive = true
            similarCostGageView.leadingAnchor.constraint(equalTo: graphSimilarCostView.leadingAnchor).isActive = true
            similarCostGageView.widthAnchor.constraint(equalTo: graphSimilarCostView.widthAnchor, multiplier: CGFloat(similarCostScore) * 0.2).isActive = true
            similarCostGageView.bottomAnchor.constraint(equalTo: graphSimilarCostView.bottomAnchor).isActive = true
            
            let costGageView = UIView()
            costGageView.backgroundColor = .systemGray2
            costGageView.translatesAutoresizingMaskIntoConstraints = false
            
            graphCostView.addSubview(costGageView)
            costGageView.topAnchor.constraint(equalTo: graphCostView.topAnchor).isActive = true
            costGageView.leadingAnchor.constraint(equalTo: graphCostView.leadingAnchor).isActive = true
            costGageView.widthAnchor.constraint(equalTo: graphCostView.widthAnchor, multiplier: CGFloat(costScore) * 0.2).isActive = true
            costGageView.bottomAnchor.constraint(equalTo: graphCostView.bottomAnchor).isActive = true
            
            // MARK: Graph - Side
            graphSimilarSideLabel.text = String(similarSidePer)
            graphSideLabel.text = String(sidePer)
            
            let similarSideGageView = UIView()
            similarSideGageView.backgroundColor = .systemRed
            similarSideGageView.translatesAutoresizingMaskIntoConstraints = false
            
            graphSimilarSideView.addSubview(similarSideGageView)
            similarSideGageView.topAnchor.constraint(equalTo: graphSimilarSideView.topAnchor).isActive = true
            similarSideGageView.leadingAnchor.constraint(equalTo: graphSimilarSideView.leadingAnchor).isActive = true
            similarSideGageView.widthAnchor.constraint(equalTo: graphSimilarSideView.widthAnchor, multiplier: CGFloat(similarSidePer) * 0.01).isActive = true
            similarSideGageView.bottomAnchor.constraint(equalTo: graphSimilarSideView.bottomAnchor).isActive = true
            
            let sideGageView = UIView()
            sideGageView.backgroundColor = .systemGray2
            sideGageView.translatesAutoresizingMaskIntoConstraints = false
            
            graphSideView.addSubview(sideGageView)
            sideGageView.topAnchor.constraint(equalTo: graphSideView.topAnchor).isActive = true
            sideGageView.leadingAnchor.constraint(equalTo: graphSideView.leadingAnchor).isActive = true
            sideGageView.widthAnchor.constraint(equalTo: graphSideView.widthAnchor, multiplier: CGFloat(sidePer) * 0.01).isActive = true
            sideGageView.bottomAnchor.constraint(equalTo: graphSideView.bottomAnchor).isActive = true
            
            for review in reviewList {
                let rv = ReviewView()
                rv.review = review
                
                reviewStackView.addArrangedSubview(rv)
                rv.leadingAnchor.constraint(equalTo: reviewStackView.leadingAnchor).isActive = true
                rv.trailingAnchor.constraint(equalTo: reviewStackView.trailingAnchor).isActive = true
            }
        }
        
        hideIndicator(idv: indicatorView, bov: blurOverlayView)
    }
}

// MARK: ProductWriteReviewVC
extension ProductReviewViewController: ProductWriteReviewViewControllerProtocol {
    func addReview(review: Review) {
        
        let rv = ReviewView()
        rv.review = review
        
        reviewStackView.addArrangedSubview(rv)
        rv.leadingAnchor.constraint(equalTo: reviewStackView.leadingAnchor).isActive = true
        rv.trailingAnchor.constraint(equalTo: reviewStackView.trailingAnchor).isActive = true
    }
}
