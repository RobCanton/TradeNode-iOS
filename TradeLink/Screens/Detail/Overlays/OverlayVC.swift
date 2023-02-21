//
//  OverlayVC.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-02-12.
//

import Foundation
import UIKit

enum OverlayType {
    case alert
    case chat
}

protocol OverlayDelegate {
    func overlayDidDismiss()
}

class OverlayViewController:UIViewController {
    
    var delegate:OverlayDelegate?
    
    //var navBar:OverlayNavBar!
    var contentView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.theme.secondaryBackground
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.theme.secondaryBackground
        contentView = UIView()
        view.addSubview(contentView)
        contentView.constraintToSuperview(0, 0, 0, 0, ignoreSafeArea: false)
//        /contentView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
    }
    
    @objc func handleDismiss() {
        delegate?.overlayDidDismiss()
    }
}
