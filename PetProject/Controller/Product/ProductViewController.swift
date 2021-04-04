//
//  ProductViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/12.
//

import UIKit
import SDWebImage


class ProductViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let getProductRequest = GetProductRequest()
    var pId: Int? {
        didSet {
            guard let pId = self.pId else { return }
            getProductRequest.fetch(vc: self, paramDict: ["pId": String(pId)])
        }
    }
    var product: Product? {
        didSet {
            guard let product = self.product else { return }
            
            productIngredientVC.product = product
            productReviewVC.product = product
            
            // Set Info
            if let url = URL(string: ADMIN_URL + product.thumbnail) {
                infoImageView.sd_setImage(with: url, completed: nil)
            }
            infoBrandLabel.text = product.pbName
            infoNameLabel.text = product.name
            infoPriceLabel.text = "\(product.price.intComma())원"
            infoDetailOriginLabel.text = product.origin
            infoDetailManufacturerLabel.text = product.manufacturer
            infoDetailPackingVolumeLabel.text = product.packingVolume
            infoDetailRecommendLabel.text = product.recommend
            infoScoreLabel.text = " \(String(format: "%.1f", product.avgScore)) "
            infoScoreCntLabel.text = "(\(String(product.reviewCnt)))"
            // Set Detail Images
            for detailImage in product.detailImageList {
                let iv = UIImageView()
                iv.contentMode = .scaleAspectFit
                iv.translatesAutoresizingMaskIntoConstraints = false
                
                infoDetailImageStackView.addArrangedSubview(iv)
                iv.centerXAnchor.constraint(equalTo: infoDetailImageStackView.centerXAnchor).isActive = true
                iv.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH * CONTENTS_RATIO).isActive = true
                
                // 이미지 높이 full size 너비 기준으로 비율 계산해서 세팅
                if let url = URL(string: ADMIN_URL + detailImage) {
                    iv.sd_setImage(with: url, completed: { (image, _, _, _) in
                        guard let img = image else { return }
                        let imgWidth = img.size.width
                        let imgHeight = img.size.height
                        
                        let width = SCREEN_WIDTH * CONTENTS_RATIO
                        
                        if imgHeight > imgWidth {
                            let ratio = (width > imgWidth) ? width / imgWidth : imgWidth / width
                            let height = imgHeight * ratio
                            
                            iv.heightAnchor.constraint(equalToConstant: height).isActive = true
                        } else {
                            let ratio = width / imgWidth
                            let height = imgHeight * ratio
                            
                            iv.heightAnchor.constraint(equalToConstant: height).isActive = true
                        }
                    })
                }
            }
        }
    }
    let productIngredientVC = ProductIngredientViewController()
    let productReviewVC = ProductReviewViewController()
    
    
    // MARK: View
    lazy var tabContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tabInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("기본정보", for: .normal)
        button.tintColor = .mainColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tag = 1
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(tabTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tabNutrientButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("성분분석", for: .normal)
        button.tintColor = .systemGray2
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.tag = 2
        button.addTarget(self, action: #selector(tabTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tabReviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("리뷰", for: .normal)
        button.tintColor = .systemGray2
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.tag = 3
        button.addTarget(self, action: #selector(tabTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tabLeftLine: LineView = {
        let lv = LineView(orientation: .vertical, width: 2)
        return lv
    }()
    lazy var tabRightLine: LineView = {
        let lv = LineView(orientation: .vertical, width: 2)
        return lv
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
    lazy var tabSpaceBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Info
    lazy var infoScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var infoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_L
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var infoImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .tertiarySystemGroupedBackground
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: View - Info - Header
    lazy var infoHeaderContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var infoBrandLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Info - Score
    lazy var infoScoreContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var infoScoreImageView: UIImageView = {
        let img = UIImage(systemName: "star.fill")
        let iv = UIImageView(image: img)
        iv.tintColor = .mainColor
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var infoScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .boldSystemFont(ofSize: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoScoreCntLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoScoreBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Info - Detail
    lazy var infoDetailContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var infoDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "상세정보"
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Info - Detail - Origin
    lazy var infoDetailOriginTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "원산지"
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoDetailOriginLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoDetailOriginBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Info - Detail - Manufacturer
    lazy var infoDetailManufacturerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "제조사"
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoDetailManufacturerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoDetailManufacturerBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Info - Detail - PackingVolume
    lazy var infoDetailPackingVolumeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "포장 단위"
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoDetailPackingVolumeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoDetailPackingVolumeBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Info - Detail - Recommend
    lazy var infoDetailRecommendTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "섭취 권장 대상"
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var infoDetailRecommendLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var infoDetailImageStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "제품 정보"
        
        configureView()
        
        getProductRequest.delegate = self
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(tabContainerView)
        tabContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tabContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tabContainerView.addSubview(tabInfoButton)
        tabInfoButton.topAnchor.constraint(equalTo: tabContainerView.topAnchor).isActive = true
        tabInfoButton.leadingAnchor.constraint(equalTo: tabContainerView.leadingAnchor).isActive = true
        tabInfoButton.widthAnchor.constraint(equalTo: tabContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        tabInfoButton.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        
        tabContainerView.addSubview(tabNutrientButton)
        tabNutrientButton.topAnchor.constraint(equalTo: tabContainerView.topAnchor).isActive = true
        tabNutrientButton.centerXAnchor.constraint(equalTo: tabContainerView.centerXAnchor).isActive = true
        tabNutrientButton.widthAnchor.constraint(equalTo: tabContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        tabNutrientButton.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        
        tabContainerView.addSubview(tabReviewButton)
        tabReviewButton.topAnchor.constraint(equalTo: tabContainerView.topAnchor).isActive = true
        tabReviewButton.trailingAnchor.constraint(equalTo: tabContainerView.trailingAnchor).isActive = true
        tabReviewButton.widthAnchor.constraint(equalTo: tabContainerView.widthAnchor, multiplier: 1 / 3).isActive = true
        tabReviewButton.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        
        tabContainerView.addSubview(tabLeftLine)
        tabLeftLine.leadingAnchor.constraint(equalTo: tabNutrientButton.leadingAnchor).isActive = true
        tabLeftLine.topAnchor.constraint(equalTo: tabContainerView.topAnchor, constant: SPACE_XS + SPACE_XXXXS).isActive = true
        tabLeftLine.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor, constant: -(SPACE_XS + SPACE_XXXXS)).isActive = true
        
        tabContainerView.addSubview(tabRightLine)
        tabRightLine.trailingAnchor.constraint(equalTo: tabNutrientButton.trailingAnchor).isActive = true
        tabRightLine.topAnchor.constraint(equalTo: tabContainerView.topAnchor, constant: SPACE_XS + SPACE_XXXXS).isActive = true
        tabRightLine.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor, constant: -(SPACE_XS + SPACE_XXXXS)).isActive = true
        
        view.addSubview(tabBottomLine)
        tabBottomLine.topAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        tabBottomLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabBottomLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(tabSpaceView)
        tabSpaceView.topAnchor.constraint(equalTo: tabBottomLine.bottomAnchor).isActive = true
        tabSpaceView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabSpaceView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabSpaceView.heightAnchor.constraint(equalToConstant: SPACE_XS).isActive = true
        
        view.addSubview(tabSpaceBottomLine)
        tabSpaceBottomLine.topAnchor.constraint(equalTo: tabSpaceView.bottomAnchor).isActive = true
        tabSpaceBottomLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabSpaceBottomLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Info
        view.addSubview(infoScrollView)
        infoScrollView.topAnchor.constraint(equalTo: tabSpaceBottomLine.bottomAnchor).isActive = true
        infoScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        infoScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        infoScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        infoScrollView.addSubview(infoStackView)
        infoStackView.topAnchor.constraint(equalTo: infoScrollView.topAnchor, constant: SPACE_L).isActive = true
        infoStackView.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor).isActive = true
        infoStackView.trailingAnchor.constraint(equalTo: infoScrollView.trailingAnchor).isActive = true
        infoStackView.widthAnchor.constraint(equalTo: infoScrollView.widthAnchor).isActive = true
        infoStackView.bottomAnchor.constraint(equalTo: infoScrollView.bottomAnchor).isActive = true
        
        infoStackView.addArrangedSubview(infoImageView)
        infoImageView.centerXAnchor.constraint(equalTo: infoStackView.centerXAnchor).isActive = true
        infoImageView.widthAnchor.constraint(equalTo: infoStackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        infoImageView.heightAnchor.constraint(equalTo: infoStackView.widthAnchor, multiplier: CONTENTS_RATIO_XXXXXXXS).isActive = true
        
        // MARK: ConfigureView - Info - Header
        infoStackView.addArrangedSubview(infoHeaderContainerView)
        infoHeaderContainerView.centerXAnchor.constraint(equalTo: infoStackView.centerXAnchor).isActive = true
        infoHeaderContainerView.widthAnchor.constraint(equalTo: infoStackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        infoHeaderContainerView.addSubview(infoBrandLabel)
        infoBrandLabel.topAnchor.constraint(equalTo: infoHeaderContainerView.topAnchor).isActive = true
        infoBrandLabel.leadingAnchor.constraint(equalTo: infoHeaderContainerView.leadingAnchor).isActive = true
        infoBrandLabel.trailingAnchor.constraint(equalTo: infoHeaderContainerView.trailingAnchor).isActive = true
        
        infoHeaderContainerView.addSubview(infoNameLabel)
        infoNameLabel.topAnchor.constraint(equalTo: infoBrandLabel.bottomAnchor, constant: SPACE_XXS).isActive = true
        infoNameLabel.leadingAnchor.constraint(equalTo: infoHeaderContainerView.leadingAnchor).isActive = true
        infoNameLabel.trailingAnchor.constraint(equalTo: infoHeaderContainerView.trailingAnchor).isActive = true
        infoNameLabel.bottomAnchor.constraint(equalTo: infoHeaderContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Info - Score
        infoStackView.addArrangedSubview(infoScoreContainerView)
        infoScoreContainerView.centerXAnchor.constraint(equalTo: infoStackView.centerXAnchor).isActive = true
        infoScoreContainerView.widthAnchor.constraint(equalTo: infoStackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        infoScoreContainerView.addSubview(infoScoreImageView)
        infoScoreImageView.topAnchor.constraint(equalTo: infoScoreContainerView.topAnchor).isActive = true
        infoScoreImageView.leadingAnchor.constraint(equalTo: infoScoreContainerView.leadingAnchor).isActive = true
        infoScoreImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        infoScoreImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        infoScoreContainerView.addSubview(infoScoreLabel)
        infoScoreLabel.centerYAnchor.constraint(equalTo: infoScoreImageView.centerYAnchor).isActive = true
        infoScoreLabel.leadingAnchor.constraint(equalTo: infoScoreImageView.trailingAnchor).isActive = true
        
        infoScoreContainerView.addSubview(infoScoreCntLabel)
        infoScoreCntLabel.centerYAnchor.constraint(equalTo: infoScoreImageView.centerYAnchor).isActive = true
        infoScoreCntLabel.leadingAnchor.constraint(equalTo: infoScoreLabel.trailingAnchor).isActive = true
        
        infoScoreContainerView.addSubview(infoPriceLabel)
        infoPriceLabel.centerYAnchor.constraint(equalTo: infoScoreImageView.centerYAnchor).isActive = true
        infoPriceLabel.trailingAnchor.constraint(equalTo: infoScoreContainerView.trailingAnchor).isActive = true
        
        infoScoreContainerView.addSubview(infoScoreBottomLine)
        infoScoreBottomLine.topAnchor.constraint(equalTo: infoScoreImageView.bottomAnchor, constant: SPACE_XS).isActive = true
        infoScoreBottomLine.leadingAnchor.constraint(equalTo: infoScoreContainerView.leadingAnchor).isActive = true
        infoScoreBottomLine.trailingAnchor.constraint(equalTo: infoScoreContainerView.trailingAnchor).isActive = true
        infoScoreBottomLine.bottomAnchor.constraint(equalTo: infoScoreContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Info - Detail
        infoStackView.addArrangedSubview(infoDetailContainerView)
        infoDetailContainerView.centerXAnchor.constraint(equalTo: infoStackView.centerXAnchor).isActive = true
        infoDetailContainerView.widthAnchor.constraint(equalTo: infoStackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        infoDetailContainerView.addSubview(infoDetailLabel)
        infoDetailLabel.topAnchor.constraint(equalTo: infoDetailContainerView.topAnchor).isActive = true
        infoDetailLabel.leadingAnchor.constraint(equalTo: infoDetailContainerView.leadingAnchor).isActive = true
        
        // MARK: ConfigureView - Info - Detail - Origin
        infoDetailContainerView.addSubview(infoDetailOriginTitleLabel)
        infoDetailOriginTitleLabel.topAnchor.constraint(equalTo: infoDetailLabel.bottomAnchor, constant: SPACE_S).isActive = true
        infoDetailOriginTitleLabel.leadingAnchor.constraint(equalTo: infoDetailContainerView.leadingAnchor).isActive = true
        
        infoDetailContainerView.addSubview(infoDetailOriginBottomLine)
        infoDetailOriginBottomLine.topAnchor.constraint(equalTo: infoDetailOriginTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        infoDetailOriginBottomLine.leadingAnchor.constraint(equalTo: infoDetailContainerView.leadingAnchor).isActive = true
        infoDetailOriginBottomLine.trailingAnchor.constraint(equalTo: infoDetailContainerView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Info - Detail - Manufacturer
        infoDetailContainerView.addSubview(infoDetailManufacturerTitleLabel)
        infoDetailManufacturerTitleLabel.topAnchor.constraint(equalTo: infoDetailOriginBottomLine.bottomAnchor, constant: SPACE_XS).isActive = true
        infoDetailManufacturerTitleLabel.leadingAnchor.constraint(equalTo: infoDetailContainerView.leadingAnchor).isActive = true
        
        infoDetailContainerView.addSubview(infoDetailManufacturerBottomLine)
        infoDetailManufacturerBottomLine.topAnchor.constraint(equalTo: infoDetailManufacturerTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        infoDetailManufacturerBottomLine.leadingAnchor.constraint(equalTo: infoDetailContainerView.leadingAnchor).isActive = true
        infoDetailManufacturerBottomLine.trailingAnchor.constraint(equalTo: infoDetailContainerView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Info - Detail - PackingVolume
        infoDetailContainerView.addSubview(infoDetailPackingVolumeTitleLabel)
        infoDetailPackingVolumeTitleLabel.topAnchor.constraint(equalTo: infoDetailManufacturerBottomLine.bottomAnchor, constant: SPACE_XS).isActive = true
        infoDetailPackingVolumeTitleLabel.leadingAnchor.constraint(equalTo: infoDetailContainerView.leadingAnchor).isActive = true
        
        infoDetailContainerView.addSubview(infoDetailPackingVolumeBottomLine)
        infoDetailPackingVolumeBottomLine.topAnchor.constraint(equalTo: infoDetailPackingVolumeTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        infoDetailPackingVolumeBottomLine.leadingAnchor.constraint(equalTo: infoDetailContainerView.leadingAnchor).isActive = true
        infoDetailPackingVolumeBottomLine.trailingAnchor.constraint(equalTo: infoDetailContainerView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Info - Detail - Recommend
        infoDetailContainerView.addSubview(infoDetailRecommendTitleLabel)
        infoDetailRecommendTitleLabel.topAnchor.constraint(equalTo: infoDetailPackingVolumeBottomLine.bottomAnchor, constant: SPACE_XS).isActive = true
        infoDetailRecommendTitleLabel.leadingAnchor.constraint(equalTo: infoDetailContainerView.leadingAnchor).isActive = true
        infoDetailRecommendTitleLabel.bottomAnchor.constraint(equalTo: infoDetailContainerView.bottomAnchor).isActive = true
        
        infoDetailContainerView.addSubview(infoDetailOriginLabel)
        infoDetailOriginLabel.centerYAnchor.constraint(equalTo: infoDetailOriginTitleLabel.centerYAnchor).isActive = true
        infoDetailOriginLabel.leadingAnchor.constraint(equalTo: infoDetailRecommendTitleLabel.trailingAnchor, constant: SCREEN_WIDTH * (1 - CONTENTS_RATIO)).isActive = true
        
        infoDetailContainerView.addSubview(infoDetailManufacturerLabel)
        infoDetailManufacturerLabel.centerYAnchor.constraint(equalTo: infoDetailManufacturerTitleLabel.centerYAnchor).isActive = true
        infoDetailManufacturerLabel.leadingAnchor.constraint(equalTo: infoDetailRecommendTitleLabel.trailingAnchor, constant: SCREEN_WIDTH * (1 - CONTENTS_RATIO)).isActive = true
        
        infoDetailContainerView.addSubview(infoDetailPackingVolumeLabel)
        infoDetailPackingVolumeLabel.centerYAnchor.constraint(equalTo: infoDetailPackingVolumeTitleLabel.centerYAnchor).isActive = true
        infoDetailPackingVolumeLabel.leadingAnchor.constraint(equalTo: infoDetailRecommendTitleLabel.trailingAnchor, constant: SCREEN_WIDTH * (1 - CONTENTS_RATIO)).isActive = true
        
        infoDetailContainerView.addSubview(infoDetailRecommendLabel)
        infoDetailRecommendLabel.centerYAnchor.constraint(equalTo: infoDetailRecommendTitleLabel.centerYAnchor).isActive = true
        infoDetailRecommendLabel.leadingAnchor.constraint(equalTo: infoDetailRecommendTitleLabel.trailingAnchor, constant: SCREEN_WIDTH * (1 - CONTENTS_RATIO)).isActive = true
        infoDetailRecommendLabel.trailingAnchor.constraint(equalTo: infoDetailContainerView.trailingAnchor).isActive = true
        
        infoStackView.addArrangedSubview(infoDetailImageStackView)
        infoDetailImageStackView.centerXAnchor.constraint(equalTo: infoStackView.centerXAnchor).isActive = true
        infoDetailImageStackView.widthAnchor.constraint(equalTo: infoStackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func tabTapped(sender: UIButton) {
        if sender.tag == 2 {
            present(UINavigationController(rootViewController: productIngredientVC), animated: true, completion: nil)
            
        } else if sender.tag == 3 {
            present(UINavigationController(rootViewController: productReviewVC), animated: true, completion: nil)
        }
    }
}


// MARK: HTTP - GetProduct
extension ProductViewController: GetProductRequestProtocol {
    func response(product: Product?, getProduct status: String) {
        print("[HTTP RES]", getProductRequest.apiUrl, status)
        
        if status == "OK" {
            guard let product = product else { return }
            self.product = product
        }
    }
}
