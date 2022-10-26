//
//  SubjectViewModel.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/25.
//

import Foundation
import RxSwift
import RxCocoa

struct Contact {
    var name: String
    var age: Int
    var number: String
}

class SubjectViewModel {
    
    var contactData = [
        Contact(name: "aaaa", age: 11, number: "123123213"),
        Contact(name: "bbbb", age: 142, number: "010999999"),
        Contact(name: "cccc", age: 21, number: "01022123"),
    ]
    
    //var list = PublishSubject<[Contact]>()
    var list = PublishRelay<[Contact]>()
    
    func fetchData() {
//        list.onNext(contactData)
        list.accept(contactData)
    }
    
    func resetData() {
//        list.onNext([])
        list.accept(contactData)
    }
    
    func newData() {
        let new = Contact(name: "new", age: 123, number: "124e10943")
        contactData.append(new)
//        list.onNext(contactData)
        list.accept(contactData)
    }
    
    func filterData(query: String) {
        if query != "" {
//            list.onNext(contactData.filter{ $0.name.contains(query) })
            list.accept(contactData.filter{ $0.name.contains(query) })
        } else {
//            list.onNext(contactData)
            list.accept(contactData)
        }
        
    }
}
