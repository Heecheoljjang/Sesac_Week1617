//
//  RandomPhotoViewController.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/23.
//

import UIKit
import Kingfisher

final class RandomPhotoViewController: UIViewController {
    
    var mainView = RandomPhotoView()
    
    var viewModel = RandomPhotoViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        bind()
    }
    
    private func configure() {
        mainView.changePhotoButton.addTarget(self, action: #selector(changeImage), for: .touchUpInside)
    }
    
    private func bind() {
        viewModel.photo.bind { [weak self] photo in
            DispatchQueue.global().async {
                guard let url = URL(string: photo.urls?.thumb ?? ""), let data = try? Data(contentsOf: url) else { return }
                DispatchQueue.main.async {
                    self?.mainView.imageView.image = UIImage(data: data)
                }
            }
        }
    }
    @objc private func changeImage() {
        viewModel.requestRandomPhoto()
    }
}
