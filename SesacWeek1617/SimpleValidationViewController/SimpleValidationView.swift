//
//  SimpleValidationView.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/24.
//

import UIKit
import SnapKit

final class SimpleValidationView: UIView {
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        
        return label
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .lightGray
        
        return textField
    }()
    
    let nameValidationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "Username has to be at least 5 characters"
        
        return label
    }()
    
    let pwLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        
        return label
    }()
    
    let pwTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .lightGray
        return textField
    }()
    
    let pwValidationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "Password has to be at least 5 characters"
        
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Do something"
        configuration.baseForegroundColor = .black
        configuration.baseBackgroundColor = .systemMint
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configure() {
        [userNameLabel, usernameTextField, nameValidationLabel, pwLabel, pwTextField, pwValidationLabel, button].forEach {
            addSubview($0)
        }
        backgroundColor = .white
    }
    
    func setUpConstraints() {
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        nameValidationLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        pwLabel.snp.makeConstraints { make in
            make.top.equalTo(nameValidationLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(pwLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        pwValidationLabel.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(pwValidationLabel.snp.bottom).offset(20)
            make.width.equalTo(pwValidationLabel)
            make.centerX.equalTo(pwValidationLabel)
            make.height.equalTo(60)
        }
    }
    
}
