//
//  DetailVC.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-13.
//

import Foundation
import UIKit

class DetailViewController:UIViewController {
    
    var headerView:DetailHeaderView!
    var contentView:UIView!
    var closeButton:UIButton!
    
    static let headerHeight:CGFloat = 220
    
    var headerHeightAnchor:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        //view.layer.borderWidth = 0.5
        //view.layer.borderColor = UIColor.red.cgColor
        
        headerView = DetailHeaderView()
        view.addSubview(headerView)
        headerView.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: false)
        //headerView.constraintHeight(to: Self.headerHeight)
        headerHeightAnchor = headerView.heightAnchor.constraint(equalToConstant: Self.headerHeight)
        headerHeightAnchor.isActive = true
        
        contentView = UIView()
        view.addSubview(contentView)
        contentView.backgroundColor = UIColor.Theme.background2
        contentView.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
        contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        
        let divider = UIView()
        divider.backgroundColor = UIColor.separator
        //divider.alpha =
        contentView.addSubview(divider)
        divider.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: true)
        divider.constraintHeight(to: 0.5)
        
        closeButton = UIButton(type: .system)
        
        let imageConfig = UIImage.SymbolConfiguration(weight: .light)
        closeButton.setImage(UIImage(systemName: "chevron.down", withConfiguration: imageConfig), for: .normal)
        view.addSubview(closeButton)
        closeButton.constraintWidth(to: 44)
        closeButton.constraintHeight(to: 44)
        closeButton.constraintToSuperview(0, nil, nil, 12, ignoreSafeArea: false)
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        closeButton.tintColor = UIColor.label
    }
    
    @objc func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBlackout()
    }
    
    func animateBlackout() {
        UIView.animate(withDuration: 0.10, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = .black
        }, completion: nil)
    }
}

extension DetailViewController:InteractiveModalDelegate {
    func transitionDidUpdate(progress: CGFloat) {
        print("Progress: \(progress)")
        
        let reverseProgress = 1 - progress
        let newHeight = max((Self.headerHeight - MinibarView.height) * (reverseProgress) + MinibarView.height, MinibarView.height)
        self.headerHeightAnchor.constant = newHeight
        self.headerView.backdrop.alpha = 1 - (progress * progress)
        self.closeButton.alpha = reverseProgress * reverseProgress
        //self.contentView.alpha = 0.5 + 0.5 * reverseProgress
        if progress > 0 {
            self.view.backgroundColor = .clear
        } else {
            //animateBlackout()
        }
        self.view.layoutIfNeeded()
    }
    
    func transitionDidPresent() {
        animateBlackout()
    }
    
    func transitionDidDismiss() {
        
    }
    
    
}
