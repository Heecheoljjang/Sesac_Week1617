//
//  SimpletPickerView.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/24.
//

import UIKit
import SnapKit

final class SimplePickerView: UIView {
    
    let firstPickerView: UIPickerView = {
        let view = UIPickerView()
        
        return view
    }()
    let secondPickerView: UIPickerView = {
        let view = UIPickerView()
        
        return view
    }()
    let thirdPickerView: UIPickerView = {
        let view = UIPickerView()
        
        return view
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
        [firstPickerView, secondPickerView, thirdPickerView].forEach {
            addSubview($0)
        }
        backgroundColor = .white
    }
    
    func setUpConstraints() {
        firstPickerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(250)
        }
        secondPickerView.snp.makeConstraints { make in
            make.top.equalTo(firstPickerView.snp.bottom).offset(10)
            make.height.equalTo(250)
            make.horizontalEdges.equalToSuperview()
        }
        thirdPickerView.snp.makeConstraints { make in
            make.top.equalTo(secondPickerView.snp.bottom).offset(10)
            make.height.equalTo(250)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
}
