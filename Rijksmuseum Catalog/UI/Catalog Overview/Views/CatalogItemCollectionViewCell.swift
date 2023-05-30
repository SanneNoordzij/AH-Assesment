//
//  CatalogItemCollectionViewCell.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class CatalogItemCollectionViewCell: UICollectionViewCell {
    private let wrapView = UIView()
    private var imageView = UIImageView()
    private let title = UILabel()
    private var currentItemId = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(catalogItem item: CatalogItem?) {
        guard let item = item, currentItemId != item.id else { return }
        currentItemId = item.id
        title.text = item.title
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with: item.imageURL, placeholderImage: UIImage(named: "noImageFound"))
    }
    
    func setupView() {
        contentView.addSubview(wrapView)
        wrapView.addSubview(imageView)
        wrapView.addSubview(title)
        
        title.numberOfLines = 0
        
        wrapView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(12)
            make.trailing.bottom.equalToSuperview().offset(-12)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
    }
    
}
