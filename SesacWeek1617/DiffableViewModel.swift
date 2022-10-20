//
//  DiffableViewModel.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/20.
//

import Foundation

class DiffableViewModel {
    
    var photoList: CObservable<SearchPhoto> = CObservable(SearchPhoto(total: 0, totalPages: 0, results: []))
    
    func requestSearchPhoto(query: String) {
        APIService.searchPhoto(query: query) { [weak self] photo, statusCode, error in
            guard let photo = photo else { return }
            self?.photoList.value = photo
        }
    }
    
}
