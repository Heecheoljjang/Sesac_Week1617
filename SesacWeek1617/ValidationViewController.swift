//
//  ValidationViewController.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/27.
//

import UIKit
import RxCocoa
import RxSwift

class ValidationViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    let disposeBag = DisposeBag()
    let viewModel = ValidationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //bind()
        
        observableVSSubject()
    }
    
    private func bind() {

        viewModel.validText
            .asDriver()
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        //validation 두번실행됨. 각각 시퀀스가 실행됨. 네트워킹같은거는 문제가 생길 수 있음. 불필요한 리소스낭비
        let validation = nameTextField.rx.text
            .orEmpty
            .map { $0.count >= 8 }
            .share() // Subject, Relay 내부적으로. 그래서 Subject랑 Relay쓸때 share따로 쓰는거아님. 실제로 썼을때랑 안썼을때랑 브레이크포인트 잡아놓고 보면 차이남 => 빼고 드라이브 써도됨

       validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)

        //컬러는 bindto못쓸거임
        validation
            .bind(onNext: { [weak self] value in
                let color: UIColor = value ? .systemPink : .lightGray
                self?.stepButton.backgroundColor = color
            })
            .disposed(by: disposeBag)

        stepButton.rx.tap
            .bind { _ in
                print("show alert")
            }

    }
    
    private func observableVSSubject() {
        
        //드라이브를 사용하면 브레이크포인트 한 번만 잡힘 -> 스트림을 공유하기때문
        let testA = stepButton.rx.tap
            .map { "하위" }
            .asDriver(onErrorJustReturn: "") //drive쓸 수 있는 객체로 바뀜
        
        testA
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        //요렇게 만들면 subject의 숫자는 모두 같은 수가 나옴
        // 즉 share가 포함되어있다는의미 -> 스트림을 공유한다!
        let sampleInt = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        
        //브레이크 포인트걸면 한 번만 걸리고 동시에 출력됨
        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 1...100))
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
    }
}
