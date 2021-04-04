//
//  DiseaseView.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/17.
//

import UIKit


protocol DiseaseViewProtocol {
    func selectDisease(disease: Disease)
}


class DiseaseView: UIView {
    
    // MARK: Property
    var delegate: DiseaseViewProtocol?
    var disease: Disease? {
        didSet {
            guard let disease = self.disease else { return }
            nameLabel.text = disease.name
        }
    }
    
    
    // MARK: View
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        configureView()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func selfTapped() {
        guard let disease = self.disease else { return }
        delegate?.selectDisease(disease: disease)
    }
}
