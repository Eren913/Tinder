//
//  YasAralıkCell.swift
//  TinderClone
//
//  Created by lil ero on 28.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class YasAralikCell: UITableViewCell {
    
    let minSlider : UISlider = {
       let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 90
        return slider
    }()
    let maxSlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 90
        return slider
    }()
    let lblMin : UILabel = {
        let lbl = YasAralıkLabel()
        lbl.text = "Min 18"
        return lbl
    }()
    let lblMax : UILabel = {
        let lbl = YasAralıkLabel()
        lbl.text = "Min 18"
        return lbl
    }()
    class YasAralıkLabel : UILabel{
        //labela bir nevi extensin yazdık ve label sınırları için yanlardan boşluk veridik
        override var intrinsicContentSize: CGSize{
            return .init(width: 80, height: 0)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let genelStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [lblMin,minSlider]),
            UIStackView(arrangedSubviews: [lblMax,maxSlider])
        ])
        genelStackView.axis = .vertical
        genelStackView.spacing = 16
        addSubview(genelStackView)
        _ = genelStackView.anchor(top: topAnchor,
                                  bottom: bottomAnchor,
                                  leading: leadingAnchor,
                                  traling: trailingAnchor,
                                  padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
