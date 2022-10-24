//
//  NumbersViewController.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift

final class NumbersViewController: UIViewController {
    
    var mainView = NumbersView()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.combineLatest(mainView.firstTextField.rx.text.orEmpty, mainView.secondTextField.rx.text.orEmpty, mainView.thirdTextField.rx.text.orEmpty) { firstText, secondText, thirdText in
            
            "\((Int(firstText) ?? 0) + (Int(secondText) ?? 0) + (Int(thirdText) ?? 0))"
            
        }
        .bind(to: mainView.resultLabel.rx.text)
        .disposed(by: disposeBag)
        
    }
}
