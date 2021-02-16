//
//  ToggleButton.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


class ToggleButton: UIButton {
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setSelect()

        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func setSelect(isSelected: Bool = false) {
        if isSelected {
            backgroundColor = .mainColor
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = .white
            setTitleColor(.systemGray3, for: .normal)
        }
        backgroundColor = isSelected ? .mainColor : .white
    }
}
