//
//  DetailActionsCell.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-02-10.
//


import Foundation
import UIKit

enum MarketItemAction {
    case watch
    case addAlert
    case addNote
    case share
}

protocol DetailActionsDelegate:class {
    func detailActions(didSelect action:MarketItemAction)
}

class DetailActionsCell: UITableViewCell {
    
    var stackView:UIStackView!
    
    let actions:[MarketItemAction] = [
        .watch, .addAlert, .addNote, .share
    ]
    
    var watchButton:DetailActionButton!
    var alertButton:DetailActionButton!
    var noteButton:DetailActionButton!
    var shareButton:DetailActionButton!
    
    
    
    weak var delegate:DetailActionsDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.theme.secondaryBackground
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        contentView.addSubview(stackView)
        stackView.constraintToSuperview(8, 0, 12, 0, ignoreSafeArea: true)
        //stackView.constraintHeight(to: 74)
        
        watchButton = DetailActionButton()
        watchButton.image = UIImage(named: "Plus")
        watchButton.title = "Watch"
        watchButton.addTarget(target: self, action: #selector(handleButton), for: .touchUpInside)
        watchButton.iconButton.tag = 0
        //watchButton.constraintHeight(to: 64)
        
        
        
        alertButton = DetailActionButton()
        alertButton.image = UIImage(named: "Alert")
        alertButton.title = "Add Alert"
        alertButton.addTarget(target: self, action: #selector(handleButton), for: .touchUpInside)
        alertButton.iconButton.tag = 1
        
        noteButton = DetailActionButton()
        noteButton.image = UIImage(named: "Add Document")
        noteButton.title = "Add Note"
        noteButton.addTarget(target: self, action: #selector(handleButton), for: .touchUpInside)
        noteButton.iconButton.tag = 2
        
        shareButton = DetailActionButton()
        shareButton.image = UIImage(named: "Position")
        shareButton.title = "Add Position"
        shareButton.addTarget(target: self, action: #selector(handleButton), for: .touchUpInside)
        shareButton.iconButton.tag = 3

        stackView.addArrangedSubview(watchButton)
        stackView.addArrangedSubview(alertButton)
        stackView.addArrangedSubview(shareButton)
        stackView.addArrangedSubview(noteButton)
        
    }
    
    @objc func handleButton(_ button:UIButton) {
        let action = actions[button.tag]
        
        delegate?.detailActions(didSelect: action)
    }
    
}


class DetailActionButton:UIView {
    
    private(set) var iconButton:UIButton!
    private(set) var titleLabel:UILabel!
    
    //var tag:Int = 0
    
    var title:String? {
        didSet {
            self.titleLabel?.text = title
        }
    }
    
    var image:UIImage? {
        didSet {
            self.iconButton?.setImage(image, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.constraintToSuperview(nil, 0, 1, 0, ignoreSafeArea: true)
        titleLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        titleLabel.textColor = UIColor.theme.label
        titleLabel.textAlignment = .center
        
        iconButton = UIButton(type: .system)
        self.addSubview(iconButton)
        iconButton.constraintToSuperview(0, 0, 18, 0, ignoreSafeArea: true)
        iconButton.contentMode = .scaleAspectFill
        iconButton.tintColor = UIColor.theme.label
        //iconButton.constraintWidth(to: 36)
        //iconButton.constraintHeight(to: 36)
    }
    
    func addTarget(target: Any?, action: Selector, for event:UIControl.Event) {
        iconButton.addTarget(target, action: action, for: event)
    }
}
















public extension UIButton
  {

    func alignTextBelow(spacing: CGFloat = 6.0)
    {
        if let image = self.imageView?.image
        {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
}


