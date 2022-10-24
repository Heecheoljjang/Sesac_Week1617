//
//  SimpleTableViewController.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift

final class SimpleTableViewExampleController: UIViewController {
    
    var mainView = SimpleTableView()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just((0..<20).map { "\($0)" })
        
        items
            .bind(to: mainView.tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = element + "\(row)"
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(String.self)
            .subscribe { value in
                print(value)
            }
            .disposed(by: disposeBag)
        mainView.tableView.rx.itemAccessoryButtonTapped
            .subscribe { indexPath in
                print("\(indexPath) indexPath")
            }
            .disposed(by: disposeBag)
    }
    
}
