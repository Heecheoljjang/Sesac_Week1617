//
//  RandomPhotoViewModel.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/23.
//

import Foundation

final class RandomPhotoViewModel {
    
    var photo: CObservable<RandomPhoto> = CObservable(RandomPhoto(urls: nil))
    
    func requestRandomPhoto() {
        APIService.requestRandomPhoto { [weak self] photo in
            guard let photo = photo else { return }
            self?.photo.value = photo
        }
    }
}
