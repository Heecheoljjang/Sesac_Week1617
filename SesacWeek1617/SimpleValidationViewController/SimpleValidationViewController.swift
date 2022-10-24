//
//  SimpleValidationViewController.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SimpleValidationViewController: UIViewController {
    
    var mainView = SimpleValidationView()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.usernameTextField.rx.text.orEmpty
            .map { $0.count >= 5 }
            .bind(to: mainView.pwTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        mainView.usernameTextField.rx.text.orEmpty
            .map { $0.count >= 5 }
            .bind(to: mainView.nameValidationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        mainView.pwTextField.rx.text.orEmpty
            .map { $0.count >= 5 }
            .bind(to: mainView.pwValidationLabel.rx.isHidden, mainView.button.rx.isEnabled)
            .disposed(by: disposeBag)
        mainView.button.rx.tap
            .subscribe(onNext: {
                print("check")
            })
            .disposed(by: disposeBag)
    }
}
