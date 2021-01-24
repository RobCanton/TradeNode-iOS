//
//  LoadingVC.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-18.
//

import Foundation
import UIKit
import Lottie


class LoadingViewController: UIViewController {
    
    var loadingView:LoadingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.constraintToSuperview()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
            self.loadingView.alpha = 1.0
        }, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func fadeout(completion: @escaping()->()) {
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: {
            self.loadingView.alpha = 0.0
        }, completion: { _ in
            completion()
        })
    }
}
