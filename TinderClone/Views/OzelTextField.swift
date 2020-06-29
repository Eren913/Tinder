//
//  OzelTextField.swift
//  TinderClone
//
//  Created by lil ero on 26.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class OzelTextField : UITextField{
    
    let padding : CGFloat
    let yukseklik : CGFloat
    init(padding: CGFloat,yukseklik : CGFloat) {
        self.padding = padding
        self.yukseklik = yukseklik
        super.init(frame: .zero)
        layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Textin veri girilmemiş halinde boşluklarını ayarlıyor
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    //Veri girilirken ki hali
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        //içerilerden boşluk bırak demek
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    //Text Fiealda yükseklik değeri atıyoruz
    override var intrinsicContentSize: CGSize{
        return .init(width: 0, height: yukseklik)
    }
}
