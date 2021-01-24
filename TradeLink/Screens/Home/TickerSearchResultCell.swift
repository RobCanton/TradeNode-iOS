//
//  Test.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-13.
//

import Foundation
import UIKit

class TickerSearchResultCell: UITableViewCell {
    
    var titleLabel:UILabel!
    var subtitleLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 15.0, weight: .medium)
        titleLabel.textColor = UIColor.secondaryLabel
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(12, 16, nil, 12, ignoreSafeArea: true)
        //titleLabel.constraintToCenter(axis: [.y])
        
        subtitleLabel = UILabel()
        subtitleLabel.font = .systemFont(ofSize: 18.0, weight: .regular)
        subtitleLabel.textColor = UIColor.label
        contentView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        //subtitleLabel.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor).isActive = true
        //subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12).isActive = true
        //subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        subtitleLabel.constraintToSuperview(nil, 16, 12, nil, ignoreSafeArea: true)
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0).isActive = true
        subtitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
        subtitleLabel.textAlignment = .left
        
        
        let button = UIButton(type: .system)
        contentView.addSubview(button)
        //button.constraintToCenter(axis: [.y])
        button.constraintToSuperview(0, nil, 0, 0, ignoreSafeArea: true)
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        button.setImage(UIImage(named: "Plus"), for: .normal)
        button.tintColor = UIColor(hex: "FFD945")//label
        
        /*
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        subtitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        subtitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        */
    }
    
}
