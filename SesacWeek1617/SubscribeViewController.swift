//
//  SubscribeViewController.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/26.
//

import UIKit
import RxCocoa
import RxSwift
import RxAlamofire
import RxDataSources

class SubscribeViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: { dataSource, tableView, indexPath, item in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(item)"
        return cell
        
    }) //title은 String, item이 int
    
    private func testRxAlamofire() {
        //Success와 Error 두 가지 케이스밖에 없음. => <Single>로 하면 네트워크를 Rx쪽으로 더 잘 활용가능. 네트워크 객체랑 자주 쓰임
        let url = APIKey.searchURL + "apple"
        //에러가 발생하면 subscribe의 onError로 감.
        request(.get, url, headers: ["Authorization": APIKey.authorization])
            .data() //데이터 타입으로 바꿈
            .decode(type: SearchPhoto.self, decoder: JSONDecoder()) //오퍼레이터로 디코딩 제공
            .subscribe(onNext: { value in
                print(value.results[0].likes) //onNext 사용하면 바로 접근 가능
            })
        //            .subscribe { value in
//                print(value) //element로 접근 가능
//            }
            .disposed(by: disposeBag)
    }
    
    private func testRxDataSource() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //이 코드는 bind보다 위에 있어야함
        dataSource.titleForHeaderInSection = { dataSource, index in //index는 각 섹션에 대한 인덱스정보
            
            return dataSource.sectionModels[index].model
        }
        
        Observable.just([
            SectionModel(model: "title1", items: [1, 2, 3]), //타이틀이 헤더가 되고 item이 셀의 정보가됨
            SectionModel(model: "title2", items: [1, 2, 3]),
            SectionModel(model: "title3", items: [1, 2, 3])
        ])
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testRxAlamofire()
        
        
        testRxDataSource()
        
        
        //데이터 연산이 많으면 원했던 형태로 나오지 않을 수 있고 이걸 체크하기 어려움. 이때 중간에 debug사용
        Observable.of(1,2,3,4,5,6,7,8,9,10)
            .skip(3) //세개의 이벤트 무시하고 4부터 전달됨
            .debug()
            .filter { $0 % 2 == 0 } //짝수만
            .debug()
            .map { $0 * 2 }
            .debug()
            .subscribe { value in
                
            }
            .disposed(by: disposeBag)
        
        
        
        //탭 -> 레이블에 "안녕 반가워"보여주기
        
        //        1
        //UIButton -> UIButton을 제네릭 형태로 갖는 리액티브 형태로 변경 -> tap까지 붙이면 ControlEvent<Void>
        
        let sample = button.rx.tap
        
        sample
        //어떤 로직을 구현할지 옵저버를 통해서 구현
            .subscribe(onNext: { [weak self] _ in
                self?.label.text = "안녕 반가워" //UI업데이트는 메인스레드에서하는데 안될수도 있으므로 옵저브온 으로ㅓ 해결
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
        button.rx.tap //bind랑 비슷한데 옵저브온같은 코드도 필요없고 에러 이벤트도 안받아서 UI이벤트에 최적화
            .bind { [weak self] _ in
                self?.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        
        //5 operator로 데이터의 stream 조작
        button
            .rx
            .tap
            //.debug() //데이터 스트림 변경중에는 시각적으로 확인할 수가 없음. 그래서 debug요소가 있음. 즉, 출시할땐 없어도됨. print로 생각. 어느 위치에 두는지에 따라 결과가 다름.
            .map { "안녕 반가워" } //버튼에서 String값으로
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
