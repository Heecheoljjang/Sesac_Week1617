//
//  NumbersView.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/24.
//

import UIKit
import SnapKit

final class NumbersView: UIView {
    
    let firstTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.backgroundColor = .lightGray
        
        return textField
    }()
    let secondTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.backgroundColor = .lightGray
        return textField
    }()
    let thirdTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.backgroundColor = .lightGray

        return textField
    }()
    
    let plusLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.backgroundColor = .lightGray
        return label
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
        [firstTextField, secondTextField, thirdTextField, plusLabel, lineView, resultLabel].forEach {
            addSubview($0)
        }
        backgroundColor = .white
    }
    
    func setUpConstraints() {
        firstTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(200)
            
        }
        secondTextField.snp.makeConstraints { make in
            make.top.equalTo(firstTextField.snp.bottom).offset(12)
            make.size.equalTo(firstTextField)
            make.centerX.equalTo(firstTextField)
        }
        thirdTextField.snp.makeConstraints { make in
            make.top.equalTo(secondTextField.snp.bottom).offset(12)
            make.size.equalTo(firstTextField)
            make.centerX.equalTo(firstTextField)

        }
        plusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(thirdTextField)
            make.trailing.equalTo(thirdTextField.snp.leading).offset(-12)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(thirdTextField.snp.bottom).offset(12)
            make.leading.equalTo(plusLabel)
            make.trailing.equalTo(thirdTextField)
            make.height.equalTo(1)
        }
        resultLabel.snp.makeConstraints { make in
            make.width.equalTo(lineView)
            make.leading.equalTo(lineView)
            make.top.equalTo(lineView.snp.bottom).offset(12)
        }
    }
}
