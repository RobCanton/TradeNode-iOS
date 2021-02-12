//
//  DetailNewsCell.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-02-12.
//

import Foundation
import UIKit

class DetailNewsCell:UITableViewCell {
    var previewImageView:UIImageView!
    var titleLabel:UILabel!
    var subtitleLabel:UILabel!
    var tickerLabel:UILabel!
    
    var newsDTO:NewsDTO?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        contentView.backgroundColor = UIColor.theme.secondaryBackground
        previewImageView = UIImageView()
        //previewImageView.backgroundColor = UIColor.theme.background
        contentView.addSubview(previewImageView)
        previewImageView.constraintWidth(to: 96)
        previewImageView.constraintHeight(to: 96)
        previewImageView.constraintToSuperview(nil, nil, nil, 12, ignoreSafeArea: false)
        previewImageView.constraintToCenter(axis: [.y])
        previewImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 16).isActive = true
        previewImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16).isActive = true
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
        //previewImageView.layer.cornerRadius = 8.0
        //previewImageView.clipsToBounds = true
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        contentView.addSubview(stackView)
        stackView.constraintToSuperview(16, 16, 16, nil, ignoreSafeArea: false)
        stackView.trailingAnchor.constraint(equalTo: previewImageView.leadingAnchor, constant: -12).isActive = true
        
        tickerLabel = UILabel()
        tickerLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        tickerLabel.text = "BTC-USD +0.37%"
        tickerLabel.numberOfLines = 0
        tickerLabel.textColor = UIColor.theme.positiveLabel
        stackView.addArrangedSubview(tickerLabel)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.text = ""
        titleLabel.numberOfLines = 0
        stackView.addArrangedSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        subtitleLabel.text = ""
        subtitleLabel.numberOfLines = 0
        
        stackView.addArrangedSubview(subtitleLabel)

    }
    
    func setup(with dto:NewsDTO) {
        self.newsDTO = dto
        titleLabel.text = dto.title
        self.previewImageView.image = nil
        self.previewImageView.alpha = 0.0
        if let imageURL = dto.imageURL {
            ImageManager.fetchImage(from: imageURL) { url, fileSource, image in
                if url == self.newsDTO?.imageURL {
                    self.previewImageView?.image = image
                    if fileSource == .cache {
                        self.previewImageView.alpha = 1.0
                    } else {
                        UIView.animate(withDuration: 0.45, animations: {
                            self.previewImageView.alpha = 1.0
                        }, completion: nil)
                    }
                }
            }
        }
        
        subtitleLabel.text = "\(dto.dateFormatted) · \(dto.source_name)"
        
    }
}
