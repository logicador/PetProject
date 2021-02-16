//
//  SelectAllergyViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import UIKit


protocol SelectAllergyViewControllerProtocol {
    func selectAllergyList(allergyList: [FoodCategory2])
}


class SelectAllergyViewController: UIViewController {
    
    // MARK: Property
    var delegate: SelectAllergyViewControllerProtocol?
    let getFoodCategoriesRequest = GetFoodCategoriesRequest()
    var foodCategory1List: [FoodCategory1] = []
    var selectedAllergyList: [FoodCategory2] = []
    
    
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
        
        navigationItem.title = "알레르기 선택"
        
        configureView()
        
        getFoodCategoriesRequest.delegate = self
        
        getFoodCategoriesRequest.fetch(vc: self, paramDict: [:])
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


// MARK: GetFoodCategories
extension SelectAllergyViewController: GetFoodCategoriesRequestProtocol {
    func response(foodCategory1List: [FoodCategory1]?, getFoodCategories status: String) {
        print("[HTTP RES]", getFoodCategoriesRequest.apiUrl, status)
        
        if status == "OK" {
            guard let foodCategory1List = foodCategory1List else { return }
            self.foodCategory1List = foodCategory1List
            
            for (i, foodCategory1) in foodCategory1List.enumerated() {
                var indexItemList: [IndexItem] = []
                for (j, foodCategory2) in foodCategory1.foodCategory2List.enumerated() {
                    let indexItem = IndexItem(index: j, name: foodCategory2.name)
                    indexItemList.append(indexItem)
                }
                
                let ov = OpenView(index: i)
                ov.delegate = self
                ov.indexItemList = indexItemList
                ov.label.text = "\(foodCategory1.name)(\(foodCategory1.foodCategory2List.count))"
                stackView.addArrangedSubview(ov)
                ov.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
                ov.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
            }
        }
    }
}


// MARK: OpenView
extension SelectAllergyViewController: OpenViewProtocol {
    func apply(index: Int, isApplied: Bool, indexItem: IndexItem) {
        let allergy = foodCategory1List[index].foodCategory2List[indexItem.index]

        if isApplied {
            selectedAllergyList.append(allergy)
        } else {
            for (i, selectedAllergy) in selectedAllergyList.enumerated() {
                if selectedAllergy.id == allergy.id {
                    selectedAllergyList.remove(at: i)
                    break
                }
            }
        }

        delegate?.selectAllergyList(allergyList: selectedAllergyList)
    }
}
