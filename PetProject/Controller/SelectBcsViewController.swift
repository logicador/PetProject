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
        let bv = BcsView(bcs: Bcs(step: 1, visually: "갈비뼈, 요추, 골반뼈가 모두 겉으로 드러나고, 지방과 근육이 없는 게 보임", touch: "갈비뼈, 요추, 골반뼈가 모두 겉으로 드러나고, 지방과 근육이 없는 게 보임"))
        bv.delegate = self
        return bv
    }()
    
    lazy var bcs2View: BcsView = {
        let bv = BcsView(bcs: Bcs(step: 2, visually: "갈비뼈, 요추, 골반뼈가 모두 겉으로 드러나고, 지방과 근육이 없는 게 보임", touch: "갈비뼈, 요추, 골반뼈가 모두 겉으로 드러나고, 지방과 근육이 없는 게 보임"))
        bv.delegate = self
        return bv
    }()
    
    lazy var bcs3View: BcsView = {
        let bv = BcsView(bcs: Bcs(step: 3, visually: "갈비뼈, 요추, 골반뼈가 모두 겉으로 드러나고, 지방과 근육이 없는 게 보임", touch: "갈비뼈, 요추, 골반뼈가 모두 겉으로 드러나고, 지방과 근육이 없는 게 보임"))
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
    }
}


// MARK: BcsView
extension SelectBcsViewController: BcsViewProtocol {
    func selectBcs(isSelected: Bool, bcs: Bcs) {
        
        if isSelected {
            if bcs.step == 1 {
                bcs2View.setSelect(isSelected: false)
                bcs3View.setSelect(isSelected: false)
            } else if bcs.step == 2 {
                bcs1View.setSelect(isSelected: false)
                bcs3View.setSelect(isSelected: false)
            } else {
                bcs1View.setSelect(isSelected: false)
                bcs2View.setSelect(isSelected: false)
            }
        }
        
        delegate?.selectBcs(isSelected: isSelected, bcs: bcs)
    }
}
