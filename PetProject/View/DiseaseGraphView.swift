//
//  DiseaseGraphView.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/16.
//

import UIKit


class DiseaseGraphView: UIView {
    
    // MARK: View
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .mainColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var perLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var graphContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var graphView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: Init
    init(similarCnt: Int, disease: Disease) {
        super.init(frame: .zero)
        
        configureView()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var cnt = 0
        if let _cnt = disease.cnt { cnt = _cnt }
        
//        guard let cnt = disease.cnt else { return }
        let ratio = Float(cnt) / Float(similarCnt)
        
        nameLabel.text = disease.name
        perLabel.text = "\(String(Int(ratio * 100)))%"
        
        graphContainerView.addSubview(graphView)
        graphView.topAnchor.constraint(equalTo: graphContainerView.topAnchor).isActive = true
        graphView.leadingAnchor.constraint(equalTo: graphContainerView.leadingAnchor).isActive = true
        graphView.widthAnchor.constraint(equalTo: graphContainerView.widthAnchor, multiplier: CGFloat(ratio)).isActive = true
        graphView.bottomAnchor.constraint(equalTo: graphContainerView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        addSubview(perLabel)
        perLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        perLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(graphContainerView)
        graphContainerView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: SPACE_XXS).isActive = true
        graphContainerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        graphContainerView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        graphContainerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
