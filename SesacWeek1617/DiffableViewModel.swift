//
//  DiffableViewModel.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/20.
//

import Foundation
import RxSwift
import RxCocoa

enum SearchError: Error {
    case noPhoto
    case serverError
}

class DiffableViewModel {
    
//    var photoList: CObservable<SearchPhoto> = CObservable(SearchPhoto(total: 0, totalPages: 0, results: []))
    
    //검색한 다음에 결과나오므로
//    var photoList = PublishSubject<SearchPhoto>()
    var photoList = PublishRelay<SearchPhoto>()
    
    func requestSearchPhoto(query: String) {
        APIService.searchPhoto(query: query) { [weak self] photo, statusCode, error in
            
//            guard let statusCode = statusCode, statusCode == 200 else {
//                self?.photoList.onError(SearchError.serverError)
//                return
//            }
//
//            guard let photo = photo else {
//                self?.photoList.onError(SearchError.noPhoto)
//                return
//            }
////            self?.photoList.value = photo
//            self?.photoList.onNext(photo)
            
            guard let statusCode = statusCode, statusCode == 200, let photo = photo else { return }
            
            self?.photoList.accept(photo)
            
        }
    }
    
}
