//
//  SimpleCollectionViewController.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/18.
//

import UIKit

//커스텀으로 만드는 모든 모델에 대해서는 디퍼블을 쓰기위해 Hashable을 채택해야함
//누구를 아이덴티파이어로 쓸건지 정해야함
//만약 struct가 아닌 class라면 Equatable도 채택해서 누가 같은지 다 체크를해야함
struct User: Hashable {
    let id = UUID().uuidString //눈에는 보이지는 않지만 구별해주는거. 추가해주면 list에 내용이 가틍ㄴ 데이터가 있어도 id가 다르기때문에 잘 등록됨
    let name: String //Hashable
    let age: Int //Hashable
    
    // 세 가지가 다 같으면 해쉬어블하다고 보기어려움. 근데 UUID는 무조건 다르기때문에 ㄱㅊ
}

class SimpleCollectionViewController: UICollectionViewController {

    //var list = ["가가각가", "나나나난", "다다닫다", "라라라랄", "마마마맘마", "바바밥바", "사사사사"] string기반이었으므로 CellRegistration에서 타입이 string이었음.
    
    //얘는 User로 타입을 설정하면됨
    var list = [
        User(name: "아아아", age: 12),
        User(name: "아아아", age: 12),
        User(name: "바바바", age: 145),
        User(name: "보보보", age: 11)
    ]
    
    //cellRegistration은 cellforitemat전에 만들어져있어야하므로 보통 cellForItemAt밖에다 만들어서 사용 => register코드와 유사한 역할
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = createLayout()
                
        //cellregistration 초기화
        //cell은 어떤 컬렉션뷰 셀 쓸건지 -> 디스플레이가 될 셀에 대한 정보
        //indexPath는 말그대로 indexPath
        //itemIdentifier는 들어올 데이터를 의미. cellForItemAt에서의 item과 연관
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            print("cellRegistration")
            //셀 틴트컬러같이 셀 내의 설정 바꾸는것은 여기서. 데이터들도 여기서 다 함
            //생성 비용도 이전보다 저렴하다고함
            
            var content = UIListContentConfiguration.valueCell()//cell.defaultContentConfiguration() 이거는 기본적인거고 UIListContentConfiguration에 이것저것 있음
            
            //text 길이가 늘어나면 알아서 셀이 늘어남
//            content.text = itemIdentifier //[indexPath]안쓰는 이유는 이미 indexPath 값이 전달된 것을 사용하기때문
            content.text = itemIdentifier.name
            
            //인덱스패스값도 주기때문에 조건문도 가능
//            content.image = indexPath.item < 3 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star.fill")
            content.image = itemIdentifier.age > 13 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star.fill")
            content.textProperties.color = .red
            content.imageProperties.tintColor = .gray
            
            content.secondaryText = "\(itemIdentifier.age)살"
            content.prefersSideBySideTextAndSecondaryText = false //false인 경우 세컨더리텍스트가 텍스트 아래로감
            content.textToSecondaryTextVerticalPadding = 20 //세컨더리텟스트와의 padding설정 가능
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell() //스타일은 여러 개 제공해줌
            backgroundConfig.backgroundColor = .tintColor
            backgroundConfig.cornerRadius = 10
            backgroundConfig.strokeColor = .red
            backgroundConfig.strokeWidth = 2
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot)
    }

    //디퍼블쓰면 안써도됨
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return list.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        //여기선 따로 동작이 없고, viewDidLoad에서 다 함
//
//        let item = list[indexPath.item]
//
//        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item) //listconfiguration객체와 사용. item은 셀에 보여질 데이터. CellRegistration은 제네릭인데 1. 어떤 종류의 셀을 쓸건지 2. 이 셀에 어떤 데이터를 들어갈지. 어떤 셀인지 모르고 item에 어떤 타입이 들어올지 모르므로 제네릭으로
//
//        return cell
//    }
    
}

extension SimpleCollectionViewController {
    
    //collectionViewLayout이 UICOllectionViewLayout이기때문에 타입 맞춰줌
    private func createLayout() -> UICollectionViewLayout {
        //14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능(List Configuration). 전반적인 설정 담당
        //컬렉션뷰 스타일이랑 관련있고 셀이랑은 관련이 없음
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        configuration.backgroundColor = .brown
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
}
