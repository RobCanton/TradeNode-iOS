//
//  RootTabBarController.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-11.
//

import Foundation
import UIKit

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
        tabBar.backgroundColor = UIColor.Theme.background//Theme.background
        tabBar.barTintColor = UIColor.Theme.background//Theme.background
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.white
        
        miniBar = MinibarView()
        view.insertSubview(miniBar, belowSubview: tabBar)
        miniBar.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: true)
        miniBar.bottomAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        miniBar.isHidden = true
        miniBar.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openItem))
        miniBar.addGestureRecognizer(tap)
        
        
        RNSocketManager.shared.connect()
        
        //MarketManager.shared.observe()
        
        print("UserSession: \(userSession.user.username)")
    }
    
    
    @objc func openItem() {
        let detail = DetailViewController()
        detail.transitioningDelegate = transitionDelegate
        detail.modalPresentationStyle = .custom
        self.present(detail, animated: true, completion: nil)
    }
}
