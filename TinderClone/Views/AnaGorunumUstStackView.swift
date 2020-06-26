//
//  AnaGorunumUstStackView.swift
//  TinderClone
//
//  Created by lil ero on 26.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class AnaGorunumUstStackView: UIStackView {
    
    let imgAlev = UIImageView(image: #imageLiteral(resourceName: "alev"))
    let btnmesaj = UIButton(type: .system)
    let btnAyarlar = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imgAlev.contentMode = .scaleAspectFit
        btnmesaj.setImage(#imageLiteral(resourceName: "mesaj").withRenderingMode(.alwaysOriginal), for: .normal)
        btnAyarlar.setImage(#imageLiteral(resourceName: "profil").withRenderingMode(.alwaysOriginal), for: .normal)
        [btnAyarlar,UIView(),imgAlev,UIView(),btnmesaj].forEach { (b) in
            addArrangedSubview(b)
        }
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 10, bottom: 0 , right:  10)
    }
    required init(coder: NSCoder) {
        fatalError()
    }

}
