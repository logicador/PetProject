//
//  PetInputView.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


protocol PetInputViewProtocol {
    func action(actionMode: String)
    func textChanged()
}


class PetInputView: UIView {
    
    // MARK: Property
    var delegate: PetInputViewProtocol?
    var actionMode: String? = nil
    
    
    // MARK: View
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 20)
        tf.textColor = .mainColor
        tf.textAlignment = .right
        tf.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var bottomLine: LineView = {
        let lv = LineView()
        return lv
    }()
    
    
    // MARK: Init
    init(labelText: String, placeholder: String, isSelectMode: Bool = false, actionMode: String? = nil) {
        super.init(frame: CGRect.zero)
        
        label.text = labelText
        textField.placeholder = placeholder
        
        if isSelectMode {
            textField.isEnabled = false
            self.actionMode = actionMode
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
        }
        
        configureView()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Function
    func configureView() {
        addSubview(textContainerView)
        textContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        textContainerView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: textContainerView.topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: textContainerView.bottomAnchor, constant: -SPACE_S).isActive = true
        
        textContainerView.addSubview(label)
        label.topAnchor.constraint(equalTo: textContainerView.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        
        addSubview(bottomLine)
        bottomLine.topAnchor.constraint(equalTo: textContainerView.bottomAnchor).isActive = true
        bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func selfTapped() {
        guard let actionMode = self.actionMode else { return }
        delegate?.action(actionMode: actionMode)
    }
    
    @objc func textFieldChanged() {
        delegate?.textChanged()
    }
}
