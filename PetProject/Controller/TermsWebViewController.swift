//
//  TermsWebViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/16.
//

import UIKit
import WebKit


class TermsWebViewController: UIViewController {
    
    // MARK: Property
    var path: String? {
        didSet {
            guard let path = self.path else { return }
            if let url = URL(string: PROJECT_URL + path) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
    }
    
    
    // MARK: View
    lazy var webView: WKWebView = {
        let wv = WKWebView()
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureView()
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
