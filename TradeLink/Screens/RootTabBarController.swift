//
//  RootTabBarController.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-11.
//

import Foundation
import UIKit

protocol RootTabBarDelegate:class {
    func rootPush(_ viewController:UIViewController, animated:Bool)
}

class RootTabBarController: UITabBarController {
    
    var miniBar:MinibarView!
    
    let userSession:UserSession
    let marketSession:MarketSession
    let transitionDelegate = InteractiveModalTransitionDelegate()
    
    
    var homeVC: ViewController!
    var screenerVC: ScreenerViewController!
    var newsVC: ScreenerViewController!
    var alertsVC: ScreenerViewController!
    
    init(userData: UserDTO) {
        self.userSession = UserSession(userData: userData)
        self.marketSession = MarketSession(userItems: userData.items ?? [])
        super.init(nibName: nil, bundle: nil)
        homeVC = ViewController(session: userSession, marketSession: marketSession)
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem.image = UIImage(named: "Home")
        homeNav.tabBarItem.title = "Home"
        
        
        screenerVC = ScreenerViewController()
        let screenerNav = UINavigationController(rootViewController: screenerVC)
        screenerNav.tabBarItem.image = UIImage(named: "Screener")
        screenerNav.tabBarItem.title = "Screener"
        
        newsVC = ScreenerViewController()
        let newsNav = UINavigationController(rootViewController: newsVC)
        newsNav.tabBarItem.image = UIImage(named: "News")
        newsNav.tabBarItem.title = "News"
        
        alertsVC = ScreenerViewController()
        let alertsNav = UINavigationController(rootViewController: alertsVC)
        alertsNav.tabBarItem.image = UIImage(named: "Alert")
        alertsNav.tabBarItem.title = "Alerts"
        
        setViewControllers([
            homeNav,
            screenerNav,
            newsNav,
            alertsNav
        ], animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tabBar.backgroundColor = UIColor.theme.secondaryBackground//Theme.background
        tabBar.barTintColor = UIColor.theme.secondaryBackground//Theme.background
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.theme.label
        
        
        miniBar = MinibarView()
        view.insertSubview(miniBar, belowSubview: tabBar)
        miniBar.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: true)
        miniBar.bottomAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        miniBar.dismiss()
        
        
        RNSocketManager.shared.connect()
        
        //MarketManager.shared.observe()
        
        print("UserSession: \(userSession.user.username)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openItem), name: Notification.Name("open-item"), object: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }

    @objc func handleTap() {
        
    }
    
    
    @objc func openItem(_ notification:Notification) {
        guard let item = notification.userInfo?["item"] as? Item else { return }
        guard let _item = marketSession.itemsDict[item.symbol] else { return }
        print("item: \(item.symbol)")
        let detail = DetailViewController(item: _item)
        detail.transitioningDelegate = transitionDelegate
        detail.modalPresentationStyle = .custom
        detail.rootDelegate = self
        self.present(detail, animated: true, completion: nil)
        
        miniBar.setup(item: _item)
        miniBar.isHidden = true
    }
}

extension RootTabBarController: RootTabBarDelegate {
    func rootPush(_ viewController: UIViewController, animated: Bool) {
        print("rootPush")
        DispatchQueue.main.async {
            guard let selected = self.selectedViewController as? UINavigationController else { return }
            selected.pushViewController(viewController, animated: animated)
        }
    }
}
