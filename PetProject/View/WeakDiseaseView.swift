//
//  WeakDiseaseView.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/16.
//

import UIKit


class WeakDiseaseView: UIView {
    
    // MARK: View
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainColor
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var symptomLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var reasonLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var managementLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: Init
    init(disease: Disease) {
        super.init(frame: .zero)
        
        nameLabel.text = disease.name
        
        let symptomMabs = NSMutableAttributedString()
            .bold("증상: ", fontSize: 16)
            .thin("저희 강아지가 어쩌구 저쩌구인데 어쩌구 해요 저희 강아지가 어쩌구 저쩌구인데 어쩌구 저쩌구 인데저희 강아지가 어쩌구 저쩌구 인데 어쩌구 해요 저희 강아지강지가 어쩌구 가 어쩌구 저쩌구인데", fontSize: 16)
        symptomLabel.attributedText = symptomMabs
        
        let reasonMabs = NSMutableAttributedString()
            .bold("원인: ", fontSize: 16)
            .thin("저희 강아지가 어쩌구 저쩌구인데 어쩌구 해요 저희 강아지가 어쩌구 저쩌구인데 어쩌구 저쩌구 인데저희 강아지가 어쩌구 저쩌구 인데 어쩌구 해요 저희 강아지강지가 어쩌구 가 어쩌구 저쩌구인데", fontSize: 16)
        reasonLabel.attributedText = reasonMabs
        
        let managementMabs = NSMutableAttributedString()
            .bold("관리: ", fontSize: 16)
            .thin("저희 강아지가 어쩌구 저쩌구인데 어쩌구 해요 저희 강아지가 어쩌구 저쩌구인데 어쩌구 저쩌구 인데저희 강아지가 어쩌구 저쩌구 인데 어쩌구 해요 저희 강아지강지가 어쩌구 가 어쩌구 저쩌구인데", fontSize: 16)
        managementLabel.attributedText = managementMabs
        
        configureView()
        
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
        
        addSubview(symptomLabel)
        symptomLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: SPACE).isActive = true
        symptomLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        symptomLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(reasonLabel)
        reasonLabel.topAnchor.constraint(equalTo: symptomLabel.bottomAnchor, constant: SPACE).isActive = true
        reasonLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        reasonLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(managementLabel)
        managementLabel.topAnchor.constraint(equalTo: reasonLabel.bottomAnchor, constant: SPACE).isActive = true
        managementLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        managementLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        managementLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
