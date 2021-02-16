//
//  SelectTVCell.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


protocol SelectTVCellProtocol {
    func select(index: Int)
}


class SelectTVCell: UITableViewCell {
    
    // MARK: Property
    var delegate: SelectTVCellProtocol?
    var index: Int?
    
    
    // MARK: View
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("선택", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.tintColor = .mainColor
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SPACE_XL).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(button)
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SPACE_XL).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func tapped() {
        guard let index = self.index else { return }
        delegate?.select(index: index)
    }
}
