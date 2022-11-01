//
//  SubjectViewModel.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/25.
//

import Foundation
import RxSwift
import RxCocoa

//associated type -> 제네릭과 유사함.
protocol CommonViewModel {
    
    //뷰모델마다 다 구조가 다르기때문에 associatedtype으로 해야됨
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

protocol Test {
    
    associatedtype TestA: Codable
    associatedtype TestB: Codable
}

class bvm: CommonViewModel {
    
    func transform(input: Input) -> Output {
        <#code#>
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
}

struct Contact {
    var name: String
    var age: Int
    var number: String
}

class SubjectViewModel: CommonViewModel {
    
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
    
    struct Input {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        let searchText: ControlProperty<String?>
    }
    
    struct Output {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        let list: Driver<[Contact]>
        let searchText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let list = list.asDriver(onErrorJustReturn: [])
        let text = input.searchText.orEmpty.debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
        
        return Output(addTap: input.addTap, resetTap: input.resetTap, newTap: input.newTap, list: list, searchText: text)
    }
    
}
