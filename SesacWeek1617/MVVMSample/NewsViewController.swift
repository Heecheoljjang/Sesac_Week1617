//
//  NewsViewController.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/20.
//

import UIKit
import RxSwift
import RxCocoa

class NewsViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    
    var viewModel = NewsViewModel()
    
    let disposeBag = DisposeBag()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, News.NewsItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //bind를 dataSource보다 먼저쓰면 오류가남 -> dataSource를 쵝화하지않고 사용해서
        configureHierarchy()
        configreDataSource()
        
        //numberTextFieldChanged()
        
        bindData()
        
        //configureViews()
        
    }
    
    func bindData() {
        //numberTextField.text = "3000"
//        viewModel.pageNumber.bind { [weak self] value in
//            self?.numberTextField.text = value
//        }
//        viewModel.pageNumber
//            .bind(to: numberTextField.rx.text)
//            .disposed(by: disposeBag)
        
        viewModel.pageNumber
            .bind(onNext: { [weak self] value in
                print(value)
                self?.numberTextField.text = value
            })
            .disposed(by: disposeBag)

        numberTextField.rx.text.orEmpty
            .subscribe(onNext: { [weak self] value in
                self?.viewModel.changePageNumberFormat(text: value)
            })
            .disposed(by: disposeBag)
        
        //데이터가 추가돼도 실행, 없어져도 실행
//        viewModel.sample.bind { [weak self] item in
//            var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
//            snapshot.appendSections([0])
//            snapshot.appendItems(item)
//            self?.dataSource.apply(snapshot, animatingDifferences: false)
//        }
        viewModel.sampleNewsList
            .subscribe(onNext: { [weak self] item in
                var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
                snapshot.appendSections([0])
                snapshot.appendItems(item)
                self?.dataSource.apply(snapshot, animatingDifferences: false)
            })
            .disposed(by: disposeBag)
        
        
        //MARK: 버튼
        
        resetButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (vc ,_) in
                vc.viewModel.resetSample()
            })
            .disposed(by: disposeBag)
        
        loadButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.loadSample()
            })
            .disposed(by: disposeBag)
        
    }
    
//    func configureViews() {
//        numberTextField.addTarget(self, action: #selector(numberTextFieldChanged), for: .editingChanged)
//        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
//        loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
//
//    }
    
//    @objc private func numberTextFieldChanged() {
//        guard let text = numberTextField.text else { return }
//        viewModel.changePageNumberFormat(text: text)
//    }
//    @objc private func resetButtonTapped() {
//        print("123")
//        viewModel.resetSample()
//    }
//    @objc private func loadButtonTapped() {
//        print("34")
//        viewModel.loadSample()
//    }
}

extension NewsViewController {
    //코드베이스로 컬렉션뷰 등록할 때 addSubView, collectionView init, snapkit layout 등등
    func configureHierarchy() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .lightGray
    }
    //셀등록 등
    func configreDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem> { cell,indexPath,itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.body
            
            cell.contentConfiguration = content
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func createLayout() -> UICollectionViewLayout{
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}
