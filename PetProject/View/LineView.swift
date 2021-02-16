//
//  LineView.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


class LineView: UIView {
    
    public enum OrienTation : Int {
        case horizontal = 0
        case vertical = 1
    }
    
    
    // MARK: View
//    lazy var view: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    
    // MARK: Init
    init(orientation: OrienTation = .horizontal, width: CGFloat = LINE_WIDTH, color: UIColor = .separator) {
        super.init(frame: CGRect.zero)
        
//        backgroundColor = color
        layer.borderWidth = width / 2
        layer.borderColor = color.cgColor
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if orientation == .horizontal {
            heightAnchor.constraint(equalToConstant: width).isActive = true
        } else {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
