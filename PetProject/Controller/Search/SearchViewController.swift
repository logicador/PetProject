//
//  SearchViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/11.
//

import UIKit


class SearchViewController: UIViewController {
    
    // MARK: View
    lazy var testView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "검색"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(backTapped))
        
        configureView()
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(testView)
        testView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        testView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        testView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        testView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func backTapped() {
        dismiss(animated: true, completion: nil)
    }
}
