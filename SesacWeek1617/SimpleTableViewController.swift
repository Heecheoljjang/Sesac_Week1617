//
//  ViewController.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/18.
//

import UIKit

class SimpleTableViewController: UITableViewController {

    let list = ["아아아앙", "오오오오오", "히히히힣", "헤헤헤"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = list[indexPath.row]
        content.secondaryText = "하이" //detailTextLabel
        cell.contentConfiguration = content
        
        return cell
    }
}
