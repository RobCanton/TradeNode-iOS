//
//  ScreenerVC.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-14.
//

import Foundation
import UIKit
import SwiftSpreadsheet

class ScreenerViewController:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = nil//"Market Open"
        
        view.backgroundColor = UIColor.theme.secondaryBackground
        
        navigationController?.navigationBar.barTintColor = UIColor.theme.background//Theme.background
        navigationController?.navigationBar.backgroundColor = UIColor.theme.background//Theme.background//UIColor.theme.//UIColor.systemBackground
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.label//(hex: "02D277")
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Screener"
        
        self.extendedLayoutIncludesOpaqueBars = true
        
    }
}
