//
//  QuestionView.swift
//  PetProject
//
//  Created by 서원영 on 2021/03/16.
//

import UIKit


protocol QuestionViewProtocol {
    func selectQuestion(question: Question)
}


class QuestionView: UIView {
    
    // MARK: Property
    var delegate: QuestionViewProtocol?
    var question: Question? {
        didSet {
            guard let question = self.question else { return }
            
            contentsLabel.text = question.contents
            dateLabel.text = String(question.createdDate.split(separator: " ")[0])
            
            statusLabel.text = (question.status == "Q") ? "답변대기" : "답변완료"
            statusLabel.textColor = (question.status == "Q") ? .systemGray : .mainColor
        }
    }
    
    
    // MARK: View
    lazy var contentsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        configureView()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(contentsLabel)
        contentsLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentsLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentsLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: contentsLabel.bottomAnchor, constant: SPACE_S).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        addSubview(statusLabel)
        statusLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(bottomLine)
        bottomLine.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func selfTapped() {
        guard let question = self.question else { return }
        delegate?.selectQuestion(question: question)
    }
}
