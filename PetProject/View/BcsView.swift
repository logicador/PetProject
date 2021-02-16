//
//  BcsView.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import UIKit


protocol BcsViewProtocol {
    func selectBcs(isSelected: Bool, bcs: Bcs)
}


class BcsView: UIView {
    
    // MARK: Property
    var delegate: BcsViewProtocol?
    var bcs: Bcs?
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                backgroundColor = .mainColor
                stepLabel.textColor = .white
                visuallyLabel.textColor = .white
                touchLabel.textColor = .white
                
            } else {
                backgroundColor = .white
                stepLabel.textColor = .mainColor
                visuallyLabel.textColor = .black
                touchLabel.textColor = .black
            }
        }
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var stepLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var visuallyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var touchLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    init(bcs: Bcs) {
        super.init(frame: CGRect.zero)
        self.bcs = bcs
        
        stepLabel.text = "\(String(bcs.step))단계"
        
        let visualMabs = NSMutableAttributedString()
            .bold("육안:  ", fontSize: 20)
            .thin(bcs.visually, fontSize: 18)
        visuallyLabel.attributedText = visualMabs
        
        let touchMabs = NSMutableAttributedString()
            .bold("촉감:  ", fontSize: 20)
            .thin(bcs.touch, fontSize: 18)
        touchLabel.attributedText = touchMabs
        
        visuallyLabel.setLineSpacing(lineSpacing: SPACE_XXXS)
        touchLabel.setLineSpacing(lineSpacing: SPACE_XXXS)
        
        layer.cornerRadius = SPACE_XXS
        
        setSelect()
        
        configureView()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: SPACE).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE_L).isActive = true
        
        containerView.addSubview(stepLabel)
        stepLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        stepLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        stepLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        containerView.addSubview(visuallyLabel)
        visuallyLabel.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: SPACE_S).isActive = true
        visuallyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        visuallyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        containerView.addSubview(touchLabel)
        touchLabel.topAnchor.constraint(equalTo: visuallyLabel.bottomAnchor, constant: SPACE_S).isActive = true
        touchLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        touchLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        touchLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    func setSelect(isSelected: Bool = false) {
        self.isSelected = isSelected
    }
    
    // MARK: Function - @OBJC
    @objc func selfTapped() {
        guard let bcs = self.bcs else { return }
        isSelected = !isSelected
        delegate?.selectBcs(isSelected: isSelected, bcs: bcs)
    }
}
