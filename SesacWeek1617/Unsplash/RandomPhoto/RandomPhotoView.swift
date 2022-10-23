//
//  RandomPhotoView.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/23.
//

import UIKit
import SnapKit

final class RandomPhotoView: UIView {
    
    let changePhotoButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.title = "사진 바꾸기"
        
        button.configuration = configuration
        return button
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        configure()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [changePhotoButton, imageView].forEach {
            addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        changePhotoButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.width.equalTo(imageView)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
    }
    
}
