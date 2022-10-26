//
//  SubscribeViewController.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/26.
//

import UIKit
import RxCocoa
import RxSwift

class SubscribeViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //탭 -> 레이블에 "안녕 반가워"보여주기
        
        //        1
        button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.label.text = "안녕 반가워"
            })
            .disposed(by: disposeBag)
        
        //        2
        button.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (vc, _) in
                vc.label.text = "안녕 반가워"
            })
            .disposed(by: disposeBag)
        
        //        3 지금은 UI가 바뀌는거니까 메인스레드. 근데 네트워크 통신이나 파일다운로드같이 백그라운드 작업일 수도 있음
        button.rx.tap
            .map { }
            .map { }
            .map { } //여기까지는 글로벌쓰레드
            .observe(on: MainScheduler.instance) //이후의 구독하는 것에 대해서는 메인스레드에서 동작하게끔
            .map { }//여기부터는 위에서 메인스레드로 지정했으므로 메인스레드
            .map { }
            .map { }
            .subscribe(onNext: { [weak self] _ in
                self?.label.text = "안녕 반가워"
            })
            .disposed(by: disposeBag)
        
        button.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.label.text = "안녕 반가워"
            })
            .disposed(by: disposeBag)
        
        //4 bind: subscribe, mainScheduler, error x
        button.rx.tap
            .bind { [weak self] _ in
                self?.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        
        //5 operator로 데이터의 stream 조작
        button
            .rx
            .tap
            .map { "안녕 반가워" }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        //6 driver traits: bind + stream 공유(리소스 낭비 방지, share())
        button.rx.tap
            .map { "안녕 반가워" }
            .asDriver(onErrorJustReturn: "") //다른 타입으로 변경. 에러 발생할때 어떤 문자열을 쓸건지
            .drive(label.rx.text)
            .disposed(by: disposeBag)
    }
}
