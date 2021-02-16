//
//  SearchBreedViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


protocol SearchBreedViewControllerProtocol {
    func selectBreed(breed: Breed)
}


class SearchBreedViewController: UIViewController {
    
    // MARK: Property
    var delegate: SearchBreedViewControllerProtocol?
    let getBreedsRequest = GetBreedsRequest()
    var breedList: [Breed] = []
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
        
        navigationItem.title = "견종 선택"
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "검색어를 입력해주세요."
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 해도 검색창 안사라지게
        
        configureView()
        
        getBreedsRequest.delegate = self
        
        // MARK: For DEV_DEBUG
        navigationItem.searchController?.searchBar.text = "차우"
        getBreedsRequest.fetch(vc: self, paramDict: ["keyword": "차우"])
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
extension SearchBreedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectTVCell", for: indexPath) as! SelectTVCell
        cell.selectionStyle = .none
        cell.index = indexPath.row
        cell.label.text = breedList[indexPath.row].name
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
extension SearchBreedViewController: SelectTVCellProtocol {
    func select(index: Int) {
        dismissKeyboard()
        
        let breed = breedList[index]
        delegate?.selectBreed(breed: breed)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: HTTP - GetBreeds
extension SearchBreedViewController: GetBreedsRequestProtocol {
    func response(breedList: [Breed]?, getBreeds status: String) {
        print("[HTTP RES]", getBreedsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let breedList = breedList else { return }
            self.breedList = breedList
            tableView.reloadData()
        }
    }
}

// MARK: SearchBar
extension SearchBreedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 2자 이상 (영어는 4자)
        if keyword.utf8.count < 4 {
            return
        }
        
        // 한글 Char 거르기
        let wordList = Array(keyword)
        for word in wordList {
            if KOR_CHAR_LIST.contains(word) {
                return
            }
        }
        
        // 이미 검색한 키워드 (리스트에 뿌려놓음)
        if currentKeyword == keyword { return }
        
        currentKeyword = keyword
        getBreedsRequest.fetch(vc: self, paramDict: ["keyword": keyword])
    }
}
