//
//  ValidationViewModel.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/27.
//

import Foundation
import RxSwift
import RxCocoa

class ValidationViewModel {
    
    let validText = BehaviorRelay(value: "닉네임은 최소 8자 이상 필요해요") //UI에 더 관련있다고해서 이걸로 선언
    
}
