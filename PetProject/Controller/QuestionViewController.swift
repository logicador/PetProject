//
//  QuestionViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/16.
//

import UIKit


class QuestionViewController: UIViewController {
    
    // MARK: Property
    let addQuestionRequest = AddQuestionRequest()
    let getQuestionsRequest = GetQuestionsRequest()
    
    
    // MARK: View
    lazy var tabContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var tabCenterLine: LineView = {
        let lv = LineView(orientation: .vertical, width: 2)
        return lv
    }()
    lazy var tabQuestionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("문의하기", for: .normal)
        button.tintColor = .mainColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tag = 1
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(tabTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var tabHistoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("문의이력", for: .normal)
        button.tintColor = .systemGray2
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.tag = 2
        button.addTarget(self, action: #selector(tabTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var tabBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    lazy var tabSpaceView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var tabSpaceBottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    // MARK: View - Question
    lazy var questionContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var addQuestionButton: ConfirmButton = {
        let cb = ConfirmButton(type: .system)
        cb.setActive(isActive: true)
        cb.setTitle("문의하기", for: .normal)
        cb.titleLabel?.font = .boldSystemFont(ofSize: 20)
        cb.addTarget(self, action: #selector(addQuestionTapped), for: .touchUpInside)
        return cb
    }()
//    lazy var titleTitleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "제목"
//        label.font = .boldSystemFont(ofSize: 20)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    lazy var titleTextContainerView: UIView = {
//        let view = UIView()
//        view.layer.borderWidth = LINE_WIDTH
//        view.layer.cornerRadius = SPACE_XXS
//        view.layer.borderColor = UIColor.separator.cgColor
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    lazy var titleTextField: UITextField = {
//        let tf = UITextField()
//        tf.font = .systemFont(ofSize: 14)
//        tf.translatesAutoresizingMaskIntoConstraints = false
//        return tf
//    }()
    lazy var contentsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "문의내용"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var contentsTextContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = LINE_WIDTH
        view.layer.cornerRadius = SPACE_XXS
        view.layer.borderColor = UIColor.separator.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var contentsTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: View - History
    lazy var historyContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var historyScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var historyStackView: UIStackView = {
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
        
        view.backgroundColor = .white
        
        navigationItem.title = "1:1 문의하기"
        
        configureView()
        
        addQuestionRequest.delegate = self
        getQuestionsRequest.delegate = self
        
        hideKeyboardWhenTappedAround()
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(tabContainerView)
        tabContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tabContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tabContainerView.addSubview(tabQuestionButton)
        tabQuestionButton.topAnchor.constraint(equalTo: tabContainerView.topAnchor).isActive = true
        tabQuestionButton.leadingAnchor.constraint(equalTo: tabContainerView.leadingAnchor).isActive = true
        tabQuestionButton.widthAnchor.constraint(equalTo: tabContainerView.widthAnchor, multiplier: 0.5).isActive = true
        tabQuestionButton.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        
        tabContainerView.addSubview(tabHistoryButton)
        tabHistoryButton.topAnchor.constraint(equalTo: tabContainerView.topAnchor).isActive = true
        tabHistoryButton.trailingAnchor.constraint(equalTo: tabContainerView.trailingAnchor).isActive = true
        tabHistoryButton.widthAnchor.constraint(equalTo: tabContainerView.widthAnchor, multiplier: 0.5).isActive = true
        tabHistoryButton.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        
        tabContainerView.addSubview(tabCenterLine)
        tabCenterLine.centerXAnchor.constraint(equalTo: tabContainerView.centerXAnchor).isActive = true
        tabCenterLine.topAnchor.constraint(equalTo: tabContainerView.topAnchor, constant: SPACE_XS + SPACE_XXXXS).isActive = true
        tabCenterLine.bottomAnchor.constraint(equalTo: tabContainerView.bottomAnchor, constant: -(SPACE_XS + SPACE_XXXXS)).isActive = true
        
        view.addSubview(tabBottomLine)
        tabBottomLine.topAnchor.constraint(equalTo: tabContainerView.bottomAnchor).isActive = true
        tabBottomLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabBottomLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(tabSpaceView)
        tabSpaceView.topAnchor.constraint(equalTo: tabBottomLine.bottomAnchor).isActive = true
        tabSpaceView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabSpaceView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabSpaceView.heightAnchor.constraint(equalToConstant: SPACE_XS).isActive = true
        
        view.addSubview(tabSpaceBottomLine)
        tabSpaceBottomLine.topAnchor.constraint(equalTo: tabSpaceView.bottomAnchor).isActive = true
        tabSpaceBottomLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabSpaceBottomLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Question
        view.addSubview(questionContainerView)
        questionContainerView.topAnchor.constraint(equalTo: tabSpaceBottomLine.bottomAnchor).isActive = true
        questionContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        questionContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        questionContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        questionContainerView.addSubview(bottomView)
        bottomView.leadingAnchor.constraint(equalTo: questionContainerView.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: questionContainerView.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: questionContainerView.bottomAnchor).isActive = true
        
        bottomView.addSubview(addQuestionButton)
        addQuestionButton.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        addQuestionButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        addQuestionButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        addQuestionButton.heightAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.12).isActive = true
        addQuestionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
//        questionContainerView.addSubview(titleTitleLabel)
//        titleTitleLabel.topAnchor.constraint(equalTo: questionContainerView.topAnchor, constant: SPACE_XXL).isActive = true
//        titleTitleLabel.centerXAnchor.constraint(equalTo: questionContainerView.centerXAnchor).isActive = true
//        titleTitleLabel.widthAnchor.constraint(equalTo: questionContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
//
//        questionContainerView.addSubview(titleTextContainerView)
//        titleTextContainerView.topAnchor.constraint(equalTo: titleTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
//        titleTextContainerView.centerXAnchor.constraint(equalTo: questionContainerView.centerXAnchor).isActive = true
//        titleTextContainerView.widthAnchor.constraint(equalTo: questionContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
//
//        titleTextContainerView.addSubview(titleTextField)
//        titleTextField.topAnchor.constraint(equalTo: titleTextContainerView.topAnchor, constant: SPACE_XS).isActive = true
//        titleTextField.leadingAnchor.constraint(equalTo: titleTextContainerView.leadingAnchor, constant: SPACE_S).isActive = true
//        titleTextField.trailingAnchor.constraint(equalTo: titleTextContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
//        titleTextField.bottomAnchor.constraint(equalTo: titleTextContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        questionContainerView.addSubview(contentsTitleLabel)
        contentsTitleLabel.topAnchor.constraint(equalTo: questionContainerView.topAnchor, constant: SPACE_XXL).isActive = true
        contentsTitleLabel.centerXAnchor.constraint(equalTo: questionContainerView.centerXAnchor).isActive = true
        contentsTitleLabel.widthAnchor.constraint(equalTo: questionContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        questionContainerView.addSubview(contentsTextContainerView)
        contentsTextContainerView.topAnchor.constraint(equalTo: contentsTitleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        contentsTextContainerView.centerXAnchor.constraint(equalTo: questionContainerView.centerXAnchor).isActive = true
        contentsTextContainerView.widthAnchor.constraint(equalTo: questionContainerView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        contentsTextContainerView.addSubview(contentsTextView)
        contentsTextView.topAnchor.constraint(equalTo: contentsTextContainerView.topAnchor, constant: SPACE_XS).isActive = true
        contentsTextView.leadingAnchor.constraint(equalTo: contentsTextContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        contentsTextView.trailingAnchor.constraint(equalTo: contentsTextContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        contentsTextView.heightAnchor.constraint(equalTo: contentsTextContainerView.widthAnchor, multiplier: 0.5).isActive = true
        contentsTextView.bottomAnchor.constraint(equalTo: contentsTextContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        // MARK: ConfigureView - History
        view.addSubview(historyContainerView)
        historyContainerView.topAnchor.constraint(equalTo: tabSpaceBottomLine.bottomAnchor).isActive = true
        historyContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        historyContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        historyContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        historyContainerView.addSubview(historyScrollView)
        historyScrollView.topAnchor.constraint(equalTo: historyContainerView.topAnchor).isActive = true
        historyScrollView.leadingAnchor.constraint(equalTo: historyContainerView.leadingAnchor).isActive = true
        historyScrollView.trailingAnchor.constraint(equalTo: historyContainerView.trailingAnchor).isActive = true
        historyScrollView.widthAnchor.constraint(equalTo: historyContainerView.widthAnchor).isActive = true
        historyScrollView.bottomAnchor.constraint(equalTo: historyContainerView.bottomAnchor).isActive = true
        
        historyScrollView.addSubview(historyStackView)
        historyStackView.topAnchor.constraint(equalTo: historyScrollView.topAnchor, constant: SPACE_XXL).isActive = true
        historyStackView.leadingAnchor.constraint(equalTo: historyScrollView.leadingAnchor).isActive = true
        historyStackView.trailingAnchor.constraint(equalTo: historyScrollView.trailingAnchor).isActive = true
        historyStackView.widthAnchor.constraint(equalTo: historyScrollView.widthAnchor).isActive = true
        historyStackView.bottomAnchor.constraint(equalTo: historyScrollView.bottomAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func tabTapped(sender: UIButton) {
        dismissKeyboard()
        
        if sender.tag == 1 {
            tabQuestionButton.tintColor = .mainColor
            tabHistoryButton.tintColor = .systemGray2
            questionContainerView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.historyContainerView.alpha = 0
                self.questionContainerView.alpha = 1
            }, completion: { (_) in
                self.historyContainerView.isHidden = true
            })
            
        } else {
            getQuestionsRequest.fetch(vc: self, paramDict: [:])
            
            tabQuestionButton.tintColor = .systemGray2
            tabHistoryButton.tintColor = .mainColor
            historyContainerView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.questionContainerView.alpha = 0
                self.historyContainerView.alpha = 1
            }, completion: { (_) in
                self.questionContainerView.isHidden = true
            })
        }
    }
    
    @objc func addQuestionTapped() {
        dismissKeyboard()
        
//        guard let _title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        let contents = contentsTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
//        if _title.count < 5 || _title.count > 20 {
//            let alert = UIAlertController(title: nil, message: "제목은 5-20자 까지 입력 가능합니다.\n\n\(_title.count)/20", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
//            present(alert, animated: true)
//            return
//        }
        
        if contents.count < 10 || contents.count > 200 {
            let alert = UIAlertController(title: nil, message: "내용은 10-200자 까지 입력 가능합니다.\n\n\(contents.count)/20", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        addQuestionRequest.fetch(vc: self, paramDict: ["contents": contents])
    }
}


// MARK: HTTP - AddQuestion
extension QuestionViewController: AddQuestionRequestProtocol {
    func response(addQuestion status: String) {
        print("[HTTP RES]", addQuestionRequest.apiUrl, status)
        
        if status == "OK" {
            let alert = UIAlertController(title: "문의하기", message: "문의하기가 완료되었습니다. 빠른 시일 내에 답변을 드리겠습니다. 감사합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true)
        }
    }
}

// MARK: HTTP - GetQuestions
extension QuestionViewController: GetQuestionsRequestProtocol {
    func response(questionList: [Question]?, getQuestions status: String) {
        print("[HTTP RES]", getQuestionsRequest.apiUrl, status)
        
        if status == "OK" {
            guard let questionList = questionList else { return }
            historyStackView.removeAllChildView()
            
            for question in questionList {
                let qv = QuestionView()
                qv.question = question
                qv.delegate = self
                
                historyStackView.addArrangedSubview(qv)
                qv.centerXAnchor.constraint(equalTo: historyStackView.centerXAnchor).isActive = true
                qv.widthAnchor.constraint(equalTo: historyStackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
            }
        }
    }
}

// MARK: QuestionView
extension QuestionViewController: QuestionViewProtocol {
    func selectQuestion(question: Question) {
        let questionDetailVC = QuestionDetailViewController()
        questionDetailVC.question = question
        questionDetailVC.delegate = self
        present(UINavigationController(rootViewController: questionDetailVC), animated: true, completion: nil)
    }
}

// MARK: QuestionDetailViewController
extension QuestionViewController: QuestionDetailViewControllerProtocol {
    func removeQuestion() {
        getQuestionsRequest.fetch(vc: self, paramDict: [:])
    }
}
