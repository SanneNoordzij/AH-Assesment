//
//  ItemLoadingCollectionViewCell.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation
import UIKit
import SnapKit

class ItemLoadingCollectionViewCell: UICollectionViewCell {
    let activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
}
