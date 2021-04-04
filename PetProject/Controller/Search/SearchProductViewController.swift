//
//  SearchProductViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import UIKit


protocol SearchProductViewControllerProtocol {
    func selectProduct(product: Product)
}


class SearchProductViewController: UIViewController {
    
    // MARK: Property
    var delegate: SearchProductViewControllerProtocol?
    var pcId: Int?
    let getProductsRequest = GetProductsRequest()
    var productList: [Product] = []
    var currentKeyword = ""
    
    
    // MARK: View
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.layer.cornerRadius = SPACE_XXS
        tv.register(SelectTVCell.self, forCellReuseIdentifier: "SelectTVCell")
        tv.separatorInset.left = SPACE
        tv.separatorInset.right = SPACE
        tv.tableFooterView = UIView(frame: CGRect.zero) // 빈 셀 안보이게
        tv.dataSource = self
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        navigationItem.title = "제품 선택"
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "검색어를 입력해주세요."
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 해도 검색창 안사라지게
        
        configureView()
        
        hideKeyboardWhenTappedAround()
        
        getProductsRequest.delegate = self
        
        guard let pcId = self.pcId else { return }
        getProductsRequest.fetch(vc: self, paramDict: ["pcId": String(pcId)])
        
        // MARK: For DEV_DEBUG
//        guard let pcId = self.pcId else { return }
//        navigationItem.searchController?.searchBar.text = "TEST"
//        getProductsRequest.fetch(vc: self, paramDict: ["pcId": String(pcId), "keyword": "TEST"])
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (SCREEN_WIDTH * 0.06)).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_L).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(SCREEN_WIDTH * 0.12)).isActive = true
    }
}


// MARK: TableView
extension SearchProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectTVCell", for: indexPath) as! SelectTVCell
        cell.selectionStyle = .none
        cell.index = indexPath.row
        cell.label.text = productList[indexPath.row].name
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}


// MARK: SelectTVCell
extension SearchProductViewController: SelectTVCellProtocol {
    func select(index: Int) {
        dismissKeyboard()
        
        let product = productList[index]
        delegate?.selectProduct(product: product)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: HTTP - GetProducts
extension SearchProductViewController: GetProductsRequestProtocol {
    func response(productList: [Product]?, getProducts status: String) {
        print("[HTTP RES]", getProductsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let productList = productList else { return }
            self.productList = productList
            tableView.reloadData()
        }
    }
}

// MARK: SearchBar
extension SearchProductViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
//        // 1자 이상
//        if keyword.count < 1 { return }
        
        // 한글 Char 거르기
        let wordList = Array(keyword)
        for word in wordList {
            if KOR_CHAR_LIST.contains(word) { return }
        }
        
        // 이미 검색한 키워드 (리스트에 뿌려놓음)
        if currentKeyword == keyword { return }
        currentKeyword = keyword
        
        guard let pcId = self.pcId else { return }
        getProductsRequest.fetch(vc: self, paramDict: ["pcId": String(pcId), "keyword": keyword])
    }
}
