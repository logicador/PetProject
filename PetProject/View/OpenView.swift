//
//  OpenView.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import UIKit
import AlignedCollectionViewFlowLayout


protocol OpenViewProtocol {
    func apply(index: Int, isApplied: Bool, indexItem: IndexItem)
}


class OpenView: UIView {
    
    // MARK: Property
    var delegate: OpenViewProtocol?
    var index: Int?
    var isOpened: Bool = false {
        didSet {
            imageView.image = (isOpened) ? UIImage(systemName: "arrowtriangle.up.fill") : UIImage(systemName: "arrowtriangle.down.fill")
            containerView.isHidden = (isOpened) ? false : true
        }
    }
    var indexItemList: [IndexItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var collectionViewHeightCons: NSLayoutConstraint?
    var selectedIndexItemList: [IndexItem] = []
        
    
    // MARK: View
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_L
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .mainColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var collectionView: UICollectionView = {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        layout.minimumInteritemSpacing = SPACE_S
        layout.minimumLineSpacing = SPACE_S
        layout.estimatedItemSize = CGSize(width: 100, height: 40)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(ToggleCVCell.self, forCellWithReuseIdentifier: "ToggleCVCell")
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    // MARK: Init
    init(index: Int) {
        super.init(frame: .zero)
        self.index = index
        
        backgroundColor = .white
        layer.cornerRadius = SPACE_XXS
        
        configureView()
        
        setOpen()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: SPACE_L).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SPACE_S).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SPACE_S).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE_L).isActive = true
        
        stackView.addArrangedSubview(titleContainerView)
        titleContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: SPACE_S).isActive = true
        titleContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -SPACE_S).isActive = true
        
        titleContainerView.addSubview(label)
        label.topAnchor.constraint(equalTo: titleContainerView.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor).isActive = true
        
        titleContainerView.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        stackView.addArrangedSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        containerView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        collectionViewHeightCons = collectionView.heightAnchor.constraint(equalToConstant: 1000)
        collectionViewHeightCons?.isActive = true
        collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    func setOpen(isOpened: Bool = false) {
        self.isOpened = isOpened
    }
    
    override func layoutSubviews() {
        collectionViewHeightCons?.isActive = false
        collectionViewHeightCons = collectionView.heightAnchor.constraint(equalToConstant: collectionView.contentSize.height)
        collectionViewHeightCons?.isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func selfTapped() {
        isOpened = !isOpened
    }
}


// MARK: CollectionView
extension OpenView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToggleCVCell", for: indexPath) as! ToggleCVCell
        cell.indexItem = indexItemList[indexPath.row]
        cell.delegate = self
        
        for selectedIndexItem in selectedIndexItemList {
            if indexItemList[indexPath.row].index == selectedIndexItem.index {
                cell.apply(isApplied: true)
            }
        }
        
        return cell
    }
}


// MARK: ToggleCVCell
extension OpenView: ToggleCVCellProtocol {
    func apply(isApplied: Bool, indexItem: IndexItem) {
        guard let index = self.index else { return }
        delegate?.apply(index: index, isApplied: isApplied, indexItem: indexItem)
    }
}
