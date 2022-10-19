//
//  DiffableCollectionViewController.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/19.
//

import UIKit

private let reuseIdentifier = "Cell"

class DiffableCollectionViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var list = ["아이폰", "애플워치", "에어팟", "아이패드", "맥북"]//이미존재하는 스트링배열 등은 이미 hashable을 채택하고있기때문에 가느
        
    //뒤의 string은 list의 string 데이터에 대한 정보, Int는 섹션에 대한 정보
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        collectionView.delegate = self //delegate는 필요
        searchBar.delegate = self
    }

}

extension DiffableCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //아래처럼하면 추가된 데이터는 리스트에 없기떄문에 인덱스에러남
        //스냅샷에 추가할때 리스트에도 추가하면되긴하는데 좋은 방법은 아님 -> 스냅샷을 쓰는 의미가없음
//        let title = list[indexPath.item]
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return } //itemIdentifier를 기반으로 데이터를 꺼냄
        
        let alert = UIAlertController(title: item, message: "클릭", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

extension DiffableCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var snapshot = dataSource.snapshot() //기존 스냅샵을 가져옴
        snapshot.appendItems([searchBar.text!]) //아이템을 담아줌. 한 번에 여러 아이템도 들어갈 수 있어서 배열 형태임. 섹션은 이미 0번이 추가되어있어서 따로안씀
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension DiffableCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func configureDataSource() {
        //지역변수로 바꿔주면서 위에서 타입을 명시해줬던게 사라지면서 타입을 같이 명시해줘야함
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String>(handler: { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier
            content.secondaryText = "\(itemIdentifier.count)"
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.strokeWidth = 2
            background.strokeColor = .brown
            cell.backgroundConfiguration = background
        })
        
        //collectionView.dataSource = self => 이부분을 아래 collectionView부분이라고 생각
        //cellForItemAt, numberOfItemsInSection 대신 아래의 메서드를 구현
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
                                    
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
            
        })
        //아직까진 list에 대한 정보가 어디에 들어가는지에 대한 정보가 없음
        //Initial
        //위의 dataSource와 타입 맞춤
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0]) //0번 섹션애
        snapshot.appendItems(list) //list를 넣겟따
        dataSource.apply(snapshot)
    }
}
