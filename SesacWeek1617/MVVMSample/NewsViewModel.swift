//
//  NewsViewModel.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/20.
//

import Foundation
import RxCocoa
import RxSwift

class NewsViewModel {
    
//    var pageNumber: CObservable<String> = CObservable("3000")
//
//    var sample: CObservable<[News.NewsItem]> = CObservable(News.items)
//
  
    var pageNumber = BehaviorSubject(value: "10000")
    
    var sampleNewsList = PublishSubject<[News.NewsItem]>()


    func changePageNumberFormat(text: String) {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        let text = text.replacingOccurrences(of: ",", with: "")
//        guard let number = Int(text) else { return }
//        let result = numberFormatter.string(for: number)!
//        pageNumber.value = result
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else { return }
        let result = numberFormatter.string(for: number)!
        pageNumber.onNext(result)
    }

    func resetSample() {
//        sample.value = []
        sampleNewsList.onNext([])
    }
    
    func loadSample() {
//        sample.value = News.items
        sampleNewsList.onNext(News.items)
    }
}
