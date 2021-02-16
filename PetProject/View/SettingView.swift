//
//  SettingView.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/16.
//

import UIKit


class SettingView: UIView {
    
    // MARK: View
    lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var imageView: UIImageView = {
        let img = UIImage(systemName: "chevron.right")
        let iv = UIImageView(image: img)
        iv.tintColor = .systemGray2
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var line: LineView = {
        let lv = LineView()
        return lv
    }()
    
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        configureView()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(view)
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: SPACE_S).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -SPACE_S).isActive = true
        
        view.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        addSubview(line)
        line.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        line.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
