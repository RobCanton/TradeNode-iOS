//
//  ViewController.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-04.
//

import UIKit
import SwiftUI
import Combine

class ViewController: UIViewController {
    
    var searchController: UISearchController!
    
    let transitionDelegate = InteractiveModalTransitionDelegate()
    
    
    let userSession:UserSession
    let marketSession:MarketSession
    
    var tableView: UITableView!
    var items:[Item]
    
    init(session:UserSession, marketSession:MarketSession) {
        self.userSession = session
        self.marketSession = marketSession
        self.items = marketSession.userWatchlist
        super.init(nibName: nil, bundle: nil)
        self.marketSession.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = nil//"Market Open"
        
        view.backgroundColor = UIColor.Theme.background
        
        navigationController?.navigationBar.barTintColor = UIColor.Theme.background2//Theme.background
        navigationController?.navigationBar.backgroundColor = UIColor.Theme.background2//Theme.background//UIColor.theme.//UIColor.systemBackground
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.label//(hex: "02D277")
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "After Hours"
        
//        self.extendedLayoutIncludesOpaqueBars = true
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Market Open", style: .plain, target: nil, action: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "User Profile"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(openAccount))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "Search"),
                            style: .plain,
                            target: self,
                            action: #selector(openSearch))
        ]
        
        let bgView = UIView()
        view.addSubview(bgView)
        bgView.constraintToSuperview(insets: .zero, ignoreSafeArea: true)
        
        bgView.backgroundColor = UIColor.Theme.background2//(hex: "141728")
        
        let headerView = WatchlistHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 56))
    
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.constraintToSuperview()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MinibarView.height, right: 0)
        tableView.separatorColor = UIColor.separator.withAlphaComponent(0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        tableView.showsVerticalScrollIndicator = false
        tableView.register(StockCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.reloadData()
        
        /*
        stocksView = StocksView(user: userSession.user,
                                handler: handleButtonLink)
        let viewCtrl = UIHostingController(rootView: stocksView)
        
        view.addSubview(viewCtrl.view)
        viewCtrl.view.constraintToSuperview(insets: .zero, ignoreSafeArea: false)
        viewCtrl.view.backgroundColor = UIColor.clear//(hex: "141728")
        */

        let name = Notification.Name(rawValue: "user.items.updated")
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: name, object: nil)
    }
    
    @objc func reload() {
        self.tableView.reloadData()
    }
    
    @objc func openSearch() {
        let searchVC = SearchViewController()
        searchVC.delegate = self
        searchVC.modalPresentationStyle = .fullScreen
        self.present(searchVC, animated: false, completion: nil)
    }
    
    @objc func openAccount() {
        let accountVC = AccountViewController()
        let nav = UINavigationController(rootViewController: accountVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }

    @objc func handleButtonLink() {
       
    }
    
}

extension ViewController:MarketSessionDelegate {
    func userItemsUpdated(shouldReload:Bool) {
        self.items = marketSession.userWatchlist
        if shouldReload {
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = UIColor.red
//        return view
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockCell
        cell.setup(item: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //handleButtonLink()
        NotificationCenter.default.post(Notification(name: Notification.Name("open-item"), object: nil, userInfo: ["item": items[indexPath.row]]))
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            items.remove(at: indexPath.row)
            marketSession.requestRemoveItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        marketSession.requestMoveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension ViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
    
    
}

extension ViewController:SymbolSearchDelegate {
    func symbolSearchDidSelect(_ symbol: SymbolSearchResult) {
        print("DidSelect: \(symbol)")
        
        marketSession.requestAddItem(with: symbol.s)
//        if let item = MarketItem.parse(from: symbol) {
//            MarketManager.shared.addItem(item)
//        }
        
    }
}
