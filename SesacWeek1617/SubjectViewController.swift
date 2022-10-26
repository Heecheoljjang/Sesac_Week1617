//
//  SubjectViewController.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/25.
//

import UIKit
import RxSwift
import RxCocoa

class SubjectViewController: UIViewController {
    
    let publish = PublishSubject<Int>() //초기값이 없는 빈 상태
    let behavior = BehaviorSubject(value: 100)//퍼블리쉬랑 똑같은데 초기값이 무조건 있음 -> 옵셔널처리같은거 필요없는듯, element타입으로 타입추론. 적어준 값에 따라 타입 결정
    let replay = ReplaySubject<Int>.create(bufferSize: 3) //buffersize에 작성이된 이벤트 개수만큼 메모리에서 이벤트를 가지고 있다가 subscribe할때 한 번에 이벤트를 전달 => 다람쥐가 도토리 입에 넣고 있다가 한 번에 뱉음
    let async = AsyncSubject<Int>() //거의 안씀
    
    let disposeBag = DisposeBag()
    
    let viewModel = SubjectViewModel()
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        publishSubject()
        //        behaviorSubject()
        //        replaySubject()
        //        asyncSubject()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
//
        viewModel.list
            .bind(to: tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.name), \(element.age), \(element.number)"
            }
            .disposed(by: disposeBag)

//        viewModel.list
//            .bind(onNext: { [weak self] value in
//                self?.tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self).
//            })
//            .disposed(by: disposeBag)
//
        
        //        addButton.rx.tap
        //            .withUnretained(self)
        //            .subscribe { (vc, _) in
        //                vc.viewModel.fetchData()
        //            }
        //            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.fetchData()
            })
            .disposed(by: disposeBag)
        
        //        resetButton.rx.tap
        //            .withUnretained(self)
        //            .subscribe { (vc, _) in
        //                vc.viewModel.resetData()
        //            }
        //            .disposed(by: disposeBag)
        resetButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.resetData()
            })
            .disposed(by: disposeBag)
        
        //        newButton.rx.tap
        //            .subscribe { [weak self] _ in
        //                self?.viewModel.newData()
        //            }
        //            .disposed(by: disposeBag)
        newButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.newData()
            })
            .disposed(by: disposeBag)
        
        //딜리게이트 필요없음
        //입력할때마다 서브스크라이브가 됨
        //        searchBar.rx.text.orEmpty
        //            .withUnretained(self)
        //            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) //한글자 입력할떄마다 하는건 너무 빡셈. 네트워크 통신같은경우엔 콜수 너무 많아지므로 입력하고 1초뒤에 검색하도록 해줌. 타자입력하고 잠시 뒤에 호출하도록. 입력 끝나고 1초
        ////            .distinctUntilChanged() //같은 값을 받지 않는 오퍼레이터.
        //            .subscribe { (vc, value) in
        //                print("구독구독")
        //                vc.viewModel.filterData(query: value)
        //            }
        //            .disposed(by: disposeBag)
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] value in
                self?.viewModel.filterData(query: value)
            })
            .disposed(by: disposeBag)
        
    }
    

}

extension SubjectViewController {
    //가장 기본적으로 사용됨
    //구독하기 전에는 이벤트 무시
    func publishSubject() {
        //초기값이 없는 빈상태, subscribe 전/ error/ complete notification 이후의 이벤트는 무시
        //subscribe후에 대한 이벤트는 다 처리
        
        publish.onNext(1)
        publish.onNext(2)
        
        publish
            .subscribe { value in
                print("publish - \(value)")
            } onError: { error in
                print("publish - \(error)")
            } onCompleted: {
                print("publish completed")
            } onDisposed: {
                print("publish ondisposed")
            }
            .disposed(by: disposeBag)
        
        //        publish = 9 //이런 형태는 쓰지않음
        publish.onNext(3)
        publish.onNext(4)
        publish.on(.next(10)) //이것도 같은의미
        
        publish.onCompleted()
        
        publish.onNext(6)
        publish.onNext(7)
    }
    
    //구독했더라도 초기값이 있음
    //구독 전에 가장 최근 값을 같이 emit하기때문 -> 아무것도 없을떈 값 방출 필요하므로 초기값은 필수 => 플레이스홀더 느낌?
    func behaviorSubject() {
        behavior.onNext(1) //얘는 무쓸모
        behavior.onNext(2)
        
        behavior
            .subscribe { value in
                print("behavior - \(value)")
            } onError: { error in
                print("behavior - \(error)")
            } onCompleted: {
                print("behavior completed")
            } onDisposed: {
                print("behavior ondisposed")
            }
            .disposed(by: disposeBag)
        
        behavior.onNext(3)
        behavior.onNext(4)
        behavior.on(.next(10))
        
        behavior.onCompleted()
        
        behavior.onNext(6)
        behavior.onNext(7)
    }
    
    //초기값을 여러개 가지고싶을때 사용하면 되는듯
    //쇼핑몰에서 첫 다섯개 보여주는 등
    func replaySubject() {
        //버퍼사이즈를 엄청 큰 숫자를 함 -> 결국 메모리에 가지고 있음, 만약 배열, 이미지같이 용량이 큰 요소들은 메모리에 부하를 줄 수 있음
        
        //버퍼사이즈가 3이라서 300, 400, 500dl  cnffur
        replay.onNext(100)
        replay.onNext(200)
        replay.onNext(300)
        replay.onNext(400)
        replay.onNext(500)
        
        replay
            .subscribe { value in
                print("replay - \(value)")
            } onError: { error in
                print("replay - \(error)")
            } onCompleted: {
                print("replay completed")
            } onDisposed: {
                print("replay ondisposed")
            }
            .disposed(by: disposeBag)
        
        replay.onNext(3)
        replay.onNext(4)
        replay.on(.next(10))
        
        replay.onCompleted() //이 이후는 무시
        
        replay.onNext(6)
        replay.onNext(7)
    }
    
    //completed가 일어나기 전 마지막 하나를 보여줌
    //completed가 없으면 아무것도 출력 x
    //next로 아무리 열심히해봤자 무시됨. 즉, complete가 전달되어야만 실행되는데 바로 전 것만 출력
    func asyncSubject() {
        async.onNext(100)
        async.onNext(200)
        async.onNext(300)
        async.onNext(400)
        async.onNext(500)
        
        async
            .subscribe { value in
                print("async - \(value)")
            } onError: { error in
                print("async - \(error)")
            } onCompleted: {
                print("async completed")
            } onDisposed: {
                print("async ondisposed")
            }
            .disposed(by: disposeBag)
        
        async.onNext(3)
        async.onNext(4)
        async.on(.next(10))
        
        async.onCompleted() //이 이후는 무시
        
        async.onNext(6)
        async.onNext(7)
    }
}
