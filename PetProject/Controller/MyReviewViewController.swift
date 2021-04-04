//
//  MyReviewViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/03/16.
//

import UIKit


class MyReviewViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let getUserReviewsRequest = GetUserReviewsRequest()
    let removeReviewRequest = RemoveReviewRequest()
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XXL
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "내가 쓴 리뷰"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        getUserReviewsRequest.delegate = self
        removeReviewRequest.delegate = self
        
        getUserReviewsRequest.fetch(vc: self, paramDict: ["uId": String(app.getUserId())])
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SPACE_XXL).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
}


// MARK: HTTP - GetUserReviews
extension MyReviewViewController: GetUserReviewsRequestProtocol {
    func response(userReviewList: [UserReview]?, getUserReviews status: String) {
        print("[HTTP RES]", getUserReviewsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let userReviewList = userReviewList else { return }
            stackView.removeAllChildView()
            
            for userReview in userReviewList {
                let urv = UserReviewView()
                urv.userReview = userReview
                urv.delegate = self
                
                stackView.addArrangedSubview(urv)
                urv.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
                urv.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
            }
        }
    }
}

// MARK: HTTP - RemoveReview
extension MyReviewViewController: RemoveReviewRequestProtocol {
    func response(removeReview status: String) {
        print("[HTTP RES]", removeReviewRequest.apiUrl, status)
        
        if status == "OK" {
            getUserReviewsRequest.fetch(vc: self, paramDict: ["uId": String(app.getUserId())])
        }
    }
}

// MARK: UserReviewView
extension MyReviewViewController: UserReviewViewProtocol {
    func selectProduct(pId: Int) {
        let productVC = ProductViewController()
        productVC.pId = pId
        navigationController?.pushViewController(productVC, animated: true)
    }
    
    func removeUserReview(userReview: UserReview) {
        let alert = UIAlertController(title: nil, message: "정말 댓글을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
            self.removeReviewRequest.fetch(vc: self, paramDict: ["prId": String(userReview.id)])
        }))
        present(alert, animated: true)
    }
}
