//
//  SimplePickerViewController.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SimplePickerViewController: UIViewController {
    
    var mainView = SimplePickerView()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Observable.just([1, 2, 3])
//            .bind(to: mainView.firstPickerView.rx.itemTitles) { _, item in
//                return "\(item)"
//            }
//            .disposed(by: disposeBag)
//
//        mainView.firstPickerView.rx.modelSelected(Int.self)
//            .subscribe(onNext: { models in
//                print("models selected 1: \(models)")
//            })
//            .disposed(by: disposeBag)
//
//        Observable.just([1, 2, 3])
//            .bind(to: mainView.secondPickerView.rx.itemAttributedTitles) { _, item in
//                return NSAttributedString(string: "\(item)",
//                                          attributes: [
//                                            NSAttributedString.Key.foregroundColor: UIColor.cyan,
//                                            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue
//                                          ])
//            }
//            .disposed(by: disposeBag)
//
//        mainView.secondPickerView.rx.modelSelected(Int.self)
//            .subscribe(onNext: { models in
//                print("models selected 2: \(models)")
//            })
//            .disposed(by: disposeBag)
//
//        Observable.just([UIColor.red, UIColor.green, UIColor.blue])
//            .bind(to: mainView.thirdPickerView.rx.items) { _, item, _ in
//                let view = UIView()
//                view.backgroundColor = item
//                return view
//            }
//            .disposed(by: disposeBag)
//
//        mainView.thirdPickerView.rx.modelSelected(UIColor.self)
//            .subscribe(onNext: { models in
//                print("models selected 3: \(models)")
//            })
//            .disposed(by: disposeBag)
        
        let firstItems = Observable.just([1, 2, 3])
        
        firstItems
            .bind(to: mainView.firstPickerView.rx.itemTitles) { intValue, item in
                print("intValue: \(intValue)")
                return "\(item)sdfadsfdsaf"
            }
            .disposed(by: disposeBag)
        
        mainView.firstPickerView.rx.modelSelected(Int.self)
            .map { "\($0) 히히" }
            .subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)
//            .map { "\($0)"}
//            .subscribe(onNext: { value in
//                print(value)
//            })
//
//            .disposed(by: disposeBag)
        
        let secondItems = Observable.just([1, 2, 3])
        
        secondItems.bind(to: mainView.secondPickerView.rx.itemAttributedTitles) { _, item in
            return NSAttributedString(string: "\(item)", attributes: [
                .foregroundColor: UIColor.brown,
                .backgroundColor: UIColor.blue,
                .underlineStyle: NSUnderlineStyle.double.rawValue
            ])
        }
        .disposed(by: disposeBag)
        
        mainView.secondPickerView.rx.modelSelected(Int.self)
            .map { $0[0] }
            .subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)
        
        let thirdItems = Observable.just([UIColor.red, UIColor.green, UIColor.blue])
            .bind(to: mainView.thirdPickerView.rx.items) { intValue, item, view in
                print(intValue, item, view)
                
                let view = UIView()
                view.backgroundColor = item
                return view
            }
            .disposed(by: disposeBag)
        
        mainView.thirdPickerView.rx.modelSelected(UIColor.self)
            .subscribe(onNext: { model in
                print("model: \(model)")
            })
            .disposed(by: disposeBag)
            
    }
}

