//
//  CommentsOverlayVC.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-02-12.
//

import Foundation
import UIKit

class CommentsOverlayVC:OverlayViewController {
    weak var item:Item?
    
    init(item:Item?) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Comments", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleDismiss))
        navigationController?.navigationBar.tintColor = UIColor.theme.label
    }
}
