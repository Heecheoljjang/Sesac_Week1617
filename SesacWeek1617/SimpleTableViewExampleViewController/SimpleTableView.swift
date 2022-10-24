//
//  SimpleTableView.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/24.
//

import UIKit
import SnapKit

final class SimpleTableView: UIView {
    
    let tableView: UITableView = {
        let view = UITableView()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
