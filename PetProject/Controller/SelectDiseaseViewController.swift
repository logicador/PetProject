//
//  SelectDiseaseViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import UIKit


protocol SelectDiseaseViewControllerProtocol {
    func selectDiseaseList(diseaseList: [Disease])
}


class SelectDiseaseViewController: UIViewController {
    
    // MARK: Property
    var delegate: SelectDiseaseViewControllerProtocol?
    var bodyPartList = BODYPARTS
    let getDiseaseRequest = GetDiseasesRequest()
    var selectedDiseaseList: [Disease] = []
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
        
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        navigationItem.title = "질병 선택"
        
        configureView()
        
        getDiseaseRequest.delegate = self
        
        getDiseaseRequest.fetch(vc: self, paramDict: [:])
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: (SCREEN_WIDTH * 0.06)).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -(SCREEN_WIDTH * 0.12)).isActive = true
    }
}


// MARK: HTTP - GetDisease
extension SelectDiseaseViewController: GetDiseasesRequestProtocol {
    func response(diseaseList: [Disease]?, getDiseases status: String) {
        print("[HTTP RES]", getDiseaseRequest.apiUrl, status)
        
        if status == "OK" {
            guard let diseaseList = diseaseList else { return }
            for disease in diseaseList {
                for (i, bodyPart) in bodyPartList.enumerated() {
                    if disease.bpId == bodyPart.id {
                        bodyPartList[i].diseaseList.append(disease)
                        break
                    }
                }
            }
            
            for (i, bodyPart) in bodyPartList.enumerated() {
                var indexItemList: [IndexItem] = []
                for (j, disease) in bodyPart.diseaseList.enumerated() {
                    let indexItem = IndexItem(index: j, name: disease.name)
                    indexItemList.append(indexItem)
                }
                
                let ov = OpenView(index: i)
                ov.delegate = self
                ov.indexItemList = indexItemList
                ov.label.text = "\(bodyPart.name)(\(bodyPart.diseaseList.count))"
                stackView.addArrangedSubview(ov)
                ov.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
                ov.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
            }
        }
    }
}

// MARK: OpenView
extension SelectDiseaseViewController: OpenViewProtocol {
    func apply(index: Int, isApplied: Bool, indexItem: IndexItem) {
        let disease = bodyPartList[index].diseaseList[indexItem.index]
        
        if isApplied {
            selectedDiseaseList.append(disease)
        } else {
            for (i, selectedDisease) in selectedDiseaseList.enumerated() {
                if selectedDisease.id == disease.id {
                    selectedDiseaseList.remove(at: i)
                    break
                }
            }
        }
        
        delegate?.selectDiseaseList(diseaseList: selectedDiseaseList)
    }
}
