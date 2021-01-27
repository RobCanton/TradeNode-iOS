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
    var headerBackDrop:UIView!
    var minibarView:MinibarView!
    
    var contentView:UIView!
    var closeButton:UIButton!
    
    static let headerHeight:CGFloat = 220
    
    var headerHeightAnchor:NSLayoutConstraint!
    var headerTrailingAnchor:NSLayoutConstraint!
    
    var tableView:UITableView!
    
    weak var item:Item?
    init(item:Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        //view.layer.borderWidth = 0.5
        //view.layer.borderColor = UIColor.red.cgColor
        
        headerBackDrop = UIView()
        headerBackDrop.backgroundColor = UIColor.Theme.background
        view.addSubview(headerBackDrop)
        headerBackDrop.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: false)
        headerBackDrop.heightAnchor.constraint(equalToConstant: Self.headerHeight).isActive = true
        
        minibarView = MinibarView()
        minibarView.isUserInteractionEnabled = false
        
        minibarView.backgroundColor = UIColor.clear
        view.addSubview(minibarView)
        minibarView.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: false)
        if let item = item {
            minibarView.setup(item: item)
        }
        
        minibarView.updateChart = false
        minibarView.updatePrices = false
        
        headerView = DetailHeaderView()
    
        view.addSubview(headerView)
        headerView.constraintToSuperview(0, 0, nil, nil, ignoreSafeArea: false)
        //headerView.constraintHeight(to: Self.headerHeight)
        headerTrailingAnchor = headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        headerTrailingAnchor.isActive = true
        headerHeightAnchor = headerView.heightAnchor.constraint(equalToConstant: Self.headerHeight)
        headerHeightAnchor.isActive = true
        if let item = item {
            headerView.setup(item: item)
        }
        
        contentView = UIView()
        view.addSubview(contentView)
        contentView.backgroundColor = UIColor.Theme.background2
        contentView.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
        contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        
        tableView = UITableView(frame: .zero, style: .plain)
        contentView.addSubview(tableView)
        tableView.backgroundColor = UIColor.Theme.background2
        tableView.separatorStyle = .none
        tableView.constraintToSuperview()
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.register(DetailHeaderCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
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
        //let newHeight = max((Self.headerHeight - MinibarView.height) * (reverseProgress) + MinibarView.height, MinibarView.height)
        //self.headerHeightAnchor.constant = newHeight
        //self.headerView.backdrop.alpha = 1 - (progress * progress)
        
        if progress > 0.75 {
            let halfProgress = min((progress - 0.75) / 0.25, 1.0)
            headerTrailingAnchor.constant = -(view.bounds.width * (2/3) * halfProgress)
            self.headerHeightAnchor.constant = MinibarView.height
            self.closeButton.alpha = 0.0
            self.minibarView.alpha = halfProgress * halfProgress
            self.headerBackDrop.alpha = 1.0 - 0.15 * halfProgress
            self.headerView.contentView.alpha = 0
            self.minibarView.updatePrices = true
            
        } else {
            let halfProgress = progress / 0.75
            self.closeButton.alpha = 1 - halfProgress
            
            headerTrailingAnchor.constant = 0
            
            let newHeight = max((Self.headerHeight - MinibarView.height) * (1 - halfProgress) + MinibarView.height, MinibarView.height)
            self.headerHeightAnchor.constant = newHeight
            self.headerView.contentView.alpha = 1 - halfProgress
            self.minibarView.alpha = 0.0
            self.headerBackDrop.alpha = 1.0
            self.minibarView.updatePrices = false
        }
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
