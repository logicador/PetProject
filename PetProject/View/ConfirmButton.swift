//
//  ConfirmButton.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


class ConfirmButton: UIButton {
    
    // MARK: Properties
    var isActive: Bool = false {
        didSet {
            backgroundColor = isActive ? .mainColor : .systemGray3
        }
    }
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = SPACE_XXS

        setActive()

        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Functions
    func setActive(isActive: Bool = false) {
        self.isActive = isActive
    }
}
