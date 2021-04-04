//
//  SelectBcsViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import UIKit


protocol SelectBcsViewControllerProtocol {
    func selectBcs(isSelected: Bool, bcs: Bcs)
}


class SelectBcsViewController: UIViewController {
    
    // MARK: Property
    var delegate: SelectBcsViewControllerProtocol?
    
    
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
    
    lazy var bcs1View: BcsView = {
        let bv = BcsView(bcs: Bcs(step: 1, visually: "갈비뼈, 요추, 골반뼈가 쉽게 보이며, 지방과 근육의 손 실이 눈에 보임", touch: "지방과 근육이 거의 만 져지지 않음"))
        bv.delegate = self
        return bv
    }()
    
    lazy var bcs2View: BcsView = {
        let bv = BcsView(bcs: Bcs(step: 2, visually: "요추의 끝이 보이고, 골 반뼈가 드러나며, 허리와 복부 가 홀쭉함", touch: "갈비뼈가 쉽게 만져지며 지방은 적게 만져짐"))
        bv.delegate = self
        return bv
    }()
    
    lazy var bcs3View: BcsView = {
        let bv = BcsView(bcs: Bcs(step: 3, visually: "옆, 위에서 보아도 허리 가 구분되며, 옆에서 보았을 때 배 부분이 들어가 있음", touch: "갈비뼈를 만질 수 있으 며 지방과 살이 적당히 만져짐"))
        bv.delegate = self
        return bv
    }()
    
    lazy var bcs4View: BcsView = {
        let bv = BcsView(bcs: Bcs(step: 4, visually: "위에서 보았을 때 허리가 구분되지 않으나 튀어나오지않고,옆에서보았을때배가살짝들 어가 있음", touch: "갈비뼈가 살짝 만져지는 느낌이 있거나 만 지기 어려움"))
        bv.delegate = self
        return bv
    }()
    
    lazy var bcs5View: BcsView = {
        let bv = BcsView(bcs: Bcs(step: 5, visually: "요추와 꼬리가 시작되는 부분에 지방이 많 아살이접힘,허리와배가구분되지않으며,배가 나와있음.", touch: "-"))
        bv.delegate = self
        return bv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        navigationItem.title = "신체지수 선택"
        
        configureView()
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
        
        stackView.addArrangedSubview(bcs1View)
        bcs1View.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        bcs1View.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        
        stackView.addArrangedSubview(bcs2View)
        bcs2View.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        bcs2View.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        
        stackView.addArrangedSubview(bcs3View)
        bcs3View.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        bcs3View.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        
        stackView.addArrangedSubview(bcs4View)
        bcs4View.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        bcs4View.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        
        stackView.addArrangedSubview(bcs5View)
        bcs5View.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        bcs5View.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
    }
}


// MARK: BcsView
extension SelectBcsViewController: BcsViewProtocol {
    func selectBcs(isSelected: Bool, bcs: Bcs) {
        
        if isSelected {
            if bcs.step == 1 {
                bcs2View.setSelect(isSelected: false)
                bcs3View.setSelect(isSelected: false)
                bcs4View.setSelect(isSelected: false)
                bcs5View.setSelect(isSelected: false)
            } else if bcs.step == 2 {
                bcs1View.setSelect(isSelected: false)
                bcs3View.setSelect(isSelected: false)
                bcs4View.setSelect(isSelected: false)
                bcs5View.setSelect(isSelected: false)
            } else if bcs.step == 3 {
                bcs1View.setSelect(isSelected: false)
                bcs2View.setSelect(isSelected: false)
                bcs4View.setSelect(isSelected: false)
                bcs5View.setSelect(isSelected: false)
            } else if bcs.step == 4 {
                bcs1View.setSelect(isSelected: false)
                bcs2View.setSelect(isSelected: false)
                bcs3View.setSelect(isSelected: false)
                bcs5View.setSelect(isSelected: false)
            } else {
                bcs1View.setSelect(isSelected: false)
                bcs2View.setSelect(isSelected: false)
                bcs3View.setSelect(isSelected: false)
                bcs4View.setSelect(isSelected: false)
            }
        }
        
        delegate?.selectBcs(isSelected: isSelected, bcs: bcs)
    }
}
