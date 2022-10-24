//
//  RXCocoaExampleViewController.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift

class RXCocoaExampleViewController: UIViewController {
    
    @IBOutlet weak var simpleTableView: UITableView!
    @IBOutlet weak var simplePickerView: UIPickerView!
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var simpleSwitch: UISwitch!
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setTableView()
//        setPickerView()
//        setSwitch()
//        setSign()
//        setOperator()
        defferedTest()
    }
    
    func defferedTest() {
        var count = 1
        
        let deferredSequence = Observable<String>.deferred {
            print("Creating \(count)")
            count += 1
            
            return Observable.create { observer in
                print("Emitting...")
                observer.onNext("🐶")
                observer.onNext("🐱")
                observer.onNext("🐵")
                return Disposables.create()
            }
        }
        
        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    func generateTest() {
        Observable.generate(
                initialState: 10,
                condition: { $0 < 15 },
                iterate: { $0 + 1 }
            )
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    func rangeTest() {
        Observable.range(start: 1, count: 10)
            .subscribe { print($0) }
            .disposed(by: disposeBag)
    }
    
    func setOperator() {
        
        Observable.repeatElement("123") //특정 요소 반복. 빌드하지말기. take로 반복수 조절가능
            .take(1) //약간 몇번 시도하고 안되면 에러로 보내는등 행동할수있음
            .subscribe { value in
                print("repeat - \(value)")
            } onError: { error in
                print("repeat - \(error)")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }
            .disposed(by: disposeBag)
        
        //화면전환돼도 얘는 계속 살아있기떄문에 수동으로 dispose가 동작하게 해야함. complete나 error가 뜨면 자동으로 호출되는데 안뜨면 수동으로해야함
        let intervalOb = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            //.disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            intervalOb.dispose()
        }
        
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]
        
        Observable.just(itemsA) //element에 대한걸 하나만 받을 수 있음
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        Observable.of(itemsA, itemsB) //of는 여러개를 묶어서 전달가능. 그래서 객체가 하나면 just와 차이업승ㅁ
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.from(itemsA) //하나씩 순환
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
    }
    
    func setSign() {
        //ex. 텍스트필드1, 2 -> 레이블에 보여줌(옵저버블은 텍스트필드, 옵저버는 레이블) 두 가지를 관찰해서 하나의 레이블에 표시. 레이블은 실패할일없으니까 bind
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in //rx에서 알려주느 text는ㄴ 옵셔널타입. orEmpty는 옵셔널해제되고 nil일때는 emptyString으로 반환
            "name은 \(value1)이고, 이메일은 \(value2)입니다."
        } //소스중에 하나라도 바뀌면 이벤트 감지, collection에는 소스 넣으면되는듯
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        signName.rx.text.orEmpty //여기까진 string. 데이터의 흐름 stream을 바꾼다 => UITextField -> Reactive -> String? -> String -> Int -> bool
            .map { $0.count } //int형으로 변환
            .map { $0 < 4 } //Bool타입으로
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden) // isHidden이 bool타입이라. 옵저버 여러개 가능
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap //tap은 touchupinside라고 생각
            .subscribe { _ in //bind가 아닌이유는 탭이라고 호출하면 컨트롤이벤트가 Void라서 bind해줄만한건 따로없음. 즉, 데이터 스트림을 바꾸지않는이상 bind를 해주지않음
                self.showAlert()
            }
            .disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "dd", message: "dd", preferredStyle: .alert)
        let ok = UIAlertAction(title: "123", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func setTableView() {
        
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])
        
        items
            .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            
            .disposed(by: disposeBag)
        
        //modelSelected는 didselected라고 생각
        simpleTableView.rx.modelSelected(String.self) //이상태에서는 에러나 컴플리트 발생할 수 없음
        //섭스크라이브는 성공한 케이스, onNext라는 매개변수가 생략된거, dispose는 메모리 삭제할때
        //            .subscribe { value in
        //                print(value)
        //            } onError: { error in
        //                print("error")
        //            } onCompleted: {
        //                print("completed")
        //            } onDisposed: {
        //                print("disposed")
        //            }
        //            .disposed(by: disposeBag)
            .map { data in
                "\(data)를 클릭"
            }
            .bind(to: simpleLabel.rx.text) //onNext이벤트밖에 없는거
            .disposed(by: disposeBag)
    }
    func setPickerView() {
        let items = Observable.just([
            "영화",
            "애니메이션",
            "드라마",
            "기타"
        ])
        
        items
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
        //bind로 했을때는 배열로 들어가는걸 확인해야함
//            .map { "\($0)"}
//            .subscribe(onNext: { value in
//                print(value)
//            })
//            .disposed(by: disposeBag)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setSwitch() {
        //just와 of으 ㅣ결과는 같음
        //just와 of는 오퍼레이턴데 비교하기좋음
        Observable.of(false) // 빌드시 값 false로 주는거
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
}
