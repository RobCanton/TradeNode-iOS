//
//  DescriptionCell.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-26.
//

import Foundation
import UIKit

class DetailDescriptionCell:UITableViewCell {
    var descriptionLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.theme.secondaryBackground
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        contentView.addSubview(descriptionLabel)
        descriptionLabel.textColor = UIColor.theme.secondaryLabel
        descriptionLabel.constraintToSuperview(12, 12, 12, 12, ignoreSafeArea: true)
        descriptionLabel.text = "Bitcoin is a decentralized digital currency that enables instant payments to anyone, anywhere in the world. Bitcoin uses peer-to-peer technology to operate with no central authority: transaction management and money issuance are carried out collectively by the network."
    }
}
