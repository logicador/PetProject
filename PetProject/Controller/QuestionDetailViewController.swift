//
//  QuestionDetailViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/03/16.
//

import UIKit


protocol QuestionDetailViewControllerProtocol {
    func removeQuestion()
}


class QuestionDetailViewController: UIViewController {
    
    // MARK: Property
    var delegate: QuestionDetailViewControllerProtocol?
    let removeQuestionRequest = RemoveQuestionRequest()
    var question: Question? {
        didSet {
            guard let question = self.question else { return }
            
            contentsLabel.text = question.contents
            
            if question.status == "Q" {
                answerContainerView.isHidden = true
            } else {
                answerLabel.text = question.answer ?? ""
            }
        }
    }
    
    
    // MARK: View
    lazy var contentsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "문의내용"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var contentsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var answerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var answerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "답변내용"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "문의내용"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(backTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(removeTapped))
    
        configureView()
        
        removeQuestionRequest.delegate = self
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(contentsTitleLabel)
        contentsTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SPACE_XXL).isActive = true
        contentsTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentsTitleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        view.addSubview(contentsLabel)
        contentsLabel.topAnchor.constraint(equalTo: contentsTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        contentsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        view.addSubview(answerContainerView)
        answerContainerView.topAnchor.constraint(equalTo: contentsLabel.bottomAnchor, constant: SPACE_XXL).isActive = true
        answerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        answerContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        answerContainerView.addSubview(answerTitleLabel)
        answerTitleLabel.topAnchor.constraint(equalTo: answerContainerView.topAnchor).isActive = true
        answerTitleLabel.leadingAnchor.constraint(equalTo: answerContainerView.leadingAnchor).isActive = true
        answerTitleLabel.trailingAnchor.constraint(equalTo: answerContainerView.trailingAnchor).isActive = true
        
        answerContainerView.addSubview(answerLabel)
        answerLabel.topAnchor.constraint(equalTo: answerTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        answerLabel.leadingAnchor.constraint(equalTo: answerContainerView.leadingAnchor).isActive = true
        answerLabel.trailingAnchor.constraint(equalTo: answerContainerView.trailingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func backTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func removeTapped() {
        guard let question = self.question else { return }
        
        let alert = UIAlertController(title: nil, message: "정말 문의글을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
            self.removeQuestionRequest.fetch(vc: self, paramDict: ["qId": String(question.id)])
        }))
        present(alert, animated: true)
    }
}


// MARK: HTTP - RemoveQuestion
extension QuestionDetailViewController: RemoveQuestionRequestProtocol {
    func response(removeQuestion status: String) {
        print("[HTTP RES]", removeQuestionRequest.apiUrl, status)
        
        if status == "OK" {
            let alert = UIAlertController(title: nil, message: "문의글이 삭제되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                self.delegate?.removeQuestion()
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true)
        }
    }
}
