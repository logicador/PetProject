//
//  WeakDiseaseView.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/16.
//

import UIKit


class WeakDiseaseView: UIView {
    
    // MARK: View
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
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
        
        if let symptomNameList = disease.symptomNameList {
            if symptomNameList.count == 0 { symptomLabel.isHidden = true }
            else {
                let symptomMabs = NSMutableAttributedString()
                .bold("관련 증상: ", fontSize: 16)
                    .thin(symptomNameList.joined(separator: " / "), fontSize: 16)
                symptomLabel.attributedText = symptomMabs
            }
        }
        
        if let reason = disease.reason {
            if reason.isEmpty { reasonLabel.isHidden = true }
            else {
                let reasonMabs = NSMutableAttributedString()
                    .bold("발병 원인: ", fontSize: 16)
                    .thin(reason, fontSize: 16)
                reasonLabel.attributedText = reasonMabs
            }
        }
        
        if let management = disease.management {
            if management.isEmpty { managementLabel.isHidden = true }
            else {
                let managementMabs = NSMutableAttributedString()
                    .bold("관리법: ", fontSize: 16)
                    .thin(management, fontSize: 16)
                managementLabel.attributedText = managementMabs
            }
        }
        
        configureView()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(symptomLabel)
        symptomLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        symptomLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(reasonLabel)
        reasonLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        reasonLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(managementLabel)
        managementLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        managementLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
    }
}
