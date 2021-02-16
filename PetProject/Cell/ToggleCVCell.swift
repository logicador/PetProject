//
//  ToggleCVCell.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import UIKit


protocol ToggleCVCellProtocol {
    func apply(isApplied: Bool, indexItem: IndexItem)
}


class ToggleCVCell: UICollectionViewCell {
    
    // MARK: Property
    var delegate: ToggleCVCellProtocol?
    var isApplied: Bool = false {
        didSet {
            containerView.backgroundColor = (isApplied) ? .mainColor : .white
            containerView.layer.borderColor = (isApplied) ? UIColor.mainColor.cgColor : UIColor.systemGray4.cgColor
            button.tintColor = (isApplied) ? .white : .systemGray3
        }
    }
    var indexItem: IndexItem? {
        didSet {
            guard let indexItem = self.indexItem else { return }
            button.setTitle(indexItem.name, for: .normal)
        }
    }
    
    
    // MARK: View
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = SPACE_XXS
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: SPACE_S, bottom: SPACE_XS, right: SPACE_S)
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.isUserInteractionEnabled = false
        
        apply()
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView.addSubview(button)
        button.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    func apply(isApplied: Bool = false) {
        self.isApplied = isApplied
    }
    
    // MARK: Function - @OBJC
    @objc func tapped() {
        guard let indexItem = self.indexItem else { return }
        
        apply(isApplied: !isApplied)
        delegate?.apply(isApplied: isApplied, indexItem: indexItem)
    }
}
