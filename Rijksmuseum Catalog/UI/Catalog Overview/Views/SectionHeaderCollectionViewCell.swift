//
//  SectionHeaderCollectionViewCell.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 30/05/2023.
//

import Foundation
import UIKit
import SnapKit

class SectionHeaderCollectionViewCell: UICollectionReusableView {
    let title = UI.title()

     override init(frame: CGRect) {
         super.init(frame: frame)

         addSubview(title)

         title.snp.makeConstraints { make in
             make.leading.equalToSuperview().offset(20)
             make.trailing.equalToSuperview().offset(-20)
             make.centerY.equalToSuperview()
         }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private enum UI {
        static func title() -> UILabel {
            let label: UILabel = UILabel()
            label.textColor = .systemPink
            label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            return label
        }
    }
}
