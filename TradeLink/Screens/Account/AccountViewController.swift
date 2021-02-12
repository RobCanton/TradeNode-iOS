//
//  ProfileSettingsViewController.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-18.
//

import Foundation
import UIKit
import Firebase

class AccountViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        self.navigationController?.navigationBar.tintColor = UIColor.label
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Close"), style: .plain, target: self, action: #selector(handleClose))
        view.backgroundColor = UIColor.theme.secondaryBackground
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.theme.secondaryBackground
        view.addSubview(tableView)
        tableView.constraintToSuperview(0, 0, 0, 0, ignoreSafeArea: false)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    
    @objc func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Sign Out"
        cell.textLabel?.tintColor = UIColor.systemRed
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        try? Auth.auth().signOut()
    }
    
    
}


