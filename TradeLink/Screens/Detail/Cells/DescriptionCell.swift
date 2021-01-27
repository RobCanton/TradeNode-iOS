//
//  DescriptionCell.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-26.
//

import Foundation
import UIKit

class DetailHeaderCell:UITableViewCell {
    var symbolLabel:UILabel!
    var nameLabel:UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.Theme.background2
        symbolLabel = UILabel()
        symbolLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        //symbolLabel.text = "AAPL"
        contentView.addSubview(symbolLabel)
        symbolLabel.constraintToSuperview(12, 12, nil, nil, ignoreSafeArea: true)
    }
}
