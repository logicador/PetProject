//
//  NoticeListViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/16.
//

import UIKit


class NoticeListViewController: UIViewController {
    
    // MARK: Property
    let getNoticesRequest = GetNoticesRequest()
    
    
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
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "공지사항"
        
        configureView()
        
        getNoticesRequest.delegate = self
        
        getNoticesRequest.fetch(vc: self, paramDict: [:])
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
}


// MARK: HTTP - GetNotices
extension NoticeListViewController: GetNoticesRequestProtocol {
    func response(noticeList: [Notice]?, getNotices status: String) {
        print("[HTTP RES]", getNoticesRequest.apiUrl, status)
        
        if status == "OK" {
            guard let noticeList = noticeList else { return }
            
            for notice in noticeList {
                let nv = NoticeView()
                nv.notice = notice
                nv.delegate = self
                
                stackView.addArrangedSubview(nv)
                nv.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
                nv.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
            }
        }
    }
}

// MARK: NoticeView
extension NoticeListViewController: NoticeViewProtocol {
    func selectNotice(notice: Notice) {
        print("selectNotice", notice.id)
    }
}
