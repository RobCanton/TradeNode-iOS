//
//  DetailVC+UITableView.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-26.
//

import Foundation
import UIKit

extension DetailViewController:UITableViewDelegate, UITableViewDataSource {
    
    func setupTable() {
        //tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.theme.separator
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.register(DetailDescriptionCell.self, forCellReuseIdentifier: "descriptionCell")
        tableView.register(DetailStatsCell.self, forCellReuseIdentifier: "statsCell")
        tableView.register(DetailActionsCell.self, forCellReuseIdentifier: "actionsCell")
        tableView.register(CommentsPreviewCell.self, forCellReuseIdentifier: "commentsCell")
        tableView.register(DetailNewsCell.self, forCellReuseIdentifier: "newsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 72
    
            
        default:
            return UITableView.automaticDimension
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return news.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath) as! DetailStatsCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "actionsCell", for: indexPath) as! DetailActionsCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentsPreviewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! DetailNewsCell
            cell.setup(with: news[indexPath.row])
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 3:
            let dto = news[indexPath.row]
            self.dismiss(animated: true) {
                let viewController = NewsReaderViewController(news: dto)
                self.rootDelegate?.rootPush(viewController, animated: true)
            }
            break
        default:
            break
        }
    }
}
