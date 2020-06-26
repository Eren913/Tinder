//
//  AnaGorunumAltStackView.swift
//  TinderClone
//
//  Created by lil ero on 26.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class AnaGorunumAltStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let altSubView = [#imageLiteral(resourceName: "yenile"),#imageLiteral(resourceName: "kapat"),#imageLiteral(resourceName: "superLike"),#imageLiteral(resourceName: "like"),#imageLiteral(resourceName: "boost"),].map { (goruntu) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(goruntu.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        altSubView.forEach { (v) in
            addArrangedSubview(v)
        }
        
    }
    required init(coder: NSCoder) {
        fatalError("init")
    }
}
