//
//  NoticeView.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/16.
//

import UIKit


protocol NoticeViewProtocol {
    func selectNotice(notice: Notice)
}


class NoticeView: UIView {
    
    // MARK: Property
    var delegate: NoticeViewProtocol?
    var notice: Notice? {
        didSet {
            guard let notice = self.notice else { return }
            titleLabel.text = notice.title
            contentsLabel.text = notice.contents
            dateLabel.text = String(notice.createdDate.split(separator: " ")[0])
        }
    }
    
    
    // MARK: View
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var contentsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var line: LineView = {
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
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: SPACE).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(contentsLabel)
        contentsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        contentsLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentsLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: contentsLabel.bottomAnchor, constant: SPACE_XS).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SPACE).isActive = true
        
        addSubview(line)
        line.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        line.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func selfTapped() {
        guard let notice = self.notice else { return }
        delegate?.selectNotice(notice: notice)
    }
}
