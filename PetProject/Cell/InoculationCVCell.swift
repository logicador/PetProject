//
//  InoculationCVCell.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


protocol InoculationCVCellProtocol {
    func check(isChecked: Bool, inoculation: Inoculation)
}


class InoculationCVCell: UICollectionViewCell {
    
    // MARK: Property
    var delegate: InoculationCVCellProtocol?
    var isChecked: Bool = false {
        didSet {
            checkView.backgroundColor = (isChecked) ? .mainColor : .systemBackground
        }
    }
    var inoculation: Inoculation? {
        didSet {
            guard let inoculation = self.inoculation else { return }
            label.text = inoculation.name
        }
    }
    
    
    // MARK: View
    lazy var checkView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = SPACE_XXXS
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.isUserInteractionEnabled = false
        
        check()
        
        configureView()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(checkView)
        checkView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        checkView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        checkView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        checkView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        checkView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(label)
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: checkView.trailingAnchor, constant: SPACE_S).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func check(isChecked: Bool = false) {
        self.isChecked = isChecked
    }
    
    // MARK: Function - @OBJC
    @objc func selfTapped() {
        guard let inoculation = self.inoculation else { return }
        
        check(isChecked: !isChecked)
        delegate?.check(isChecked: isChecked, inoculation: inoculation)
    }
}
