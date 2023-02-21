//
//  WatchlistHeaderView.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-25.
//

import Foundation
import UIKit

class WatchlistHeaderView:UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var collectionView:UICollectionView!
    var tags = ["tech", "longterm", "crypto", "travel", "pennny", "dividend"]
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 0
        
        let sortButton = UIButton()
        //sortButton.setTitle("My Sort", for: .normal)
        sortButton.setImage(UIImage(named: "StarSmall"), for: .normal)
        sortButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        sortButton.tintColor = UIColor.secondaryLabel
        self.addSubview(sortButton)
        sortButton.backgroundColor = UIColor.theme.secondaryBackground
        sortButton.constraintWidth(to: 32)
        sortButton.constraintHeight(to: 32)
        sortButton.constraintToSuperview(12, 12, 12, nil, ignoreSafeArea: true)
        //sortButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        sortButton.layer.cornerRadius = 32/2
        sortButton.clipsToBounds = true
//        layout.estimatedItemSize = CGSize(width: 32, height: 100)
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        self.addSubview(collectionView)
        collectionView.constraintToSuperview(12, nil, 12, 0, ignoreSafeArea: true)
        collectionView.leadingAnchor.constraint(equalTo: sortButton.trailingAnchor, constant: 0).isActive = true
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(SortCell.self, forCellWithReuseIdentifier: "sortCell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.reloadData()
//        self.backgroundColor = UIColor.red
//        sortButton = UIButton(type: .system)
//        sortButton.setTitle("My Sort", for: .normal)
//        sortButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
//        sortButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
//        sortButton.setTitleColor(UIColor.secondaryLabel, for: .normal)
//        sortButton.contentHorizontalAlignment = .
//
//        self.addSubview(sortButton)
//        sortButton.constraintToSuperview(12, 12, 12, nil, ignoreSafeArea: true)
        
        let divider = UIView()
        self.addSubview(divider)
        divider.constraintHeight(to: 1.0)
        divider.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
        divider.backgroundColor = UIColor.black.withAlphaComponent(0.15)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TagCell
        cell.textLabel.text = tags[indexPath.item]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = tags[indexPath.item]
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0, weight: .regular)
        ])
        return CGSize(width: itemSize.width + 26, height: 32)
    }
}

class SortCell:UICollectionViewCell {
    
    var iconView:UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        contentView.backgroundColor = UIColor.theme.background
        iconView = UIImageView()
        contentView.addSubview(iconView)
        
        iconView.image = UIImage(systemName: "arrow.up.arrow.down")
        iconView.constraintToCenter(axis: [.x, .y])
        
        contentView.layer.cornerRadius = 32/2
        contentView.clipsToBounds = true
    }
}


class TagCell:UICollectionViewCell {
    
    var textLabel:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        contentView.backgroundColor = UIColor.theme.background
        textLabel = UILabel()
        textLabel.textColor = .secondaryLabel
        contentView.addSubview(textLabel)
        
        textLabel.font = .systemFont(ofSize: 15.0, weight: .regular)
        textLabel.constraintToCenter(axis: [.x, .y])
        
        contentView.layer.cornerRadius = 32/2
        contentView.clipsToBounds = true
    }
}
