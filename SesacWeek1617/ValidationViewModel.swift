//
//  ValidationViewModel.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/27.
//

import Foundation
import RxSwift
import RxCocoa

//데이터를 처리하는 비즈니스 로직을 뷰컨트롤러에서 숨기기 위해 인풋아웃풋
class ValidationViewModel {
    
    let validText = BehaviorRelay(value: "닉네임은 최소 8자 이상 필요해요") //UI에 더 관련있다고해서 이걸로 선언
    
    //인풋, 아웃풋은 구조체 이름
    struct Input {
        let text: ControlProperty<String?> // validation 부분의 텍스트. 최종적으로는 Observable의 bool타입
        let tap: ControlEvent<Void> //stepButton.rx.tap
    }
    
    struct Output {
        let validation: Observable<Bool>
        let tap: ControlEvent<Void> //현재 탭의 경우엔 연산 내용이 없기때문에 인풋아웃풋 같음
        let text: Driver<String> //validText에서 asDriver로 바꾸고 있어서 위의 validText를 Driver로 선언
    }
    
    //인풋으로 들어온 요소를 아웃풋으로 바꿔줘야하는ㄴ데 타입을 바꿔주는 시퀀스를 담당하는 메서드
    func transform(input: Input) -> Output {
        let valid = input.text
            .orEmpty
            .map { $0.count >= 8 }
            .share()
        
        let text = validText.asDriver()
        
        return Output(validation: valid, tap: input.tap, text: text)
    }
}
