//
//  Extensions+UIView.swift
//  TinderClone
//
//  Created by lil ero on 21.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit


struct  AnchorConstraints {
    //İşimize yarayacak temel constraintlerin verilerini tutacak
    var top : NSLayoutConstraint?
    var bottom : NSLayoutConstraint?
    var trailing : NSLayoutConstraint?
    var leading : NSLayoutConstraint?
    var width : NSLayoutConstraint?
    var height : NSLayoutConstraint?
}
extension UIColor{
    //Renkleri tutacak bir static func yazdık
    static func rgb(red : CGFloat,blue: CGFloat,green: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
extension UIView{
    func anchor(top : NSLayoutYAxisAnchor?,
                bottom  : NSLayoutYAxisAnchor?,
                leading : NSLayoutXAxisAnchor?,
                traling : NSLayoutXAxisAnchor?,
                padding : UIEdgeInsets = .zero,
                boyut : CGSize = .zero) -> AnchorConstraints{
        translatesAutoresizingMaskIntoConstraints = false
        var aConstraint = AnchorConstraints()
        
        if let top = top{
            aConstraint.top = topAnchor.constraint(equalTo: top,constant: padding.top)
        }
        if let bottom = bottom{
            aConstraint.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        if let leading = leading{
            aConstraint.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        if let trailing = traling{
            aConstraint.trailing  = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        if boyut.width != 0{
            aConstraint.width = widthAnchor.constraint(equalToConstant: boyut.width)
        }
        if boyut.height != 0{
            aConstraint.height = heightAnchor.constraint(equalToConstant: boyut.height)
        }
        [aConstraint.top,aConstraint.bottom,aConstraint.trailing,aConstraint.leading,aConstraint.height,aConstraint.width].forEach{ $0?.isActive = true}
        
        return aConstraint
}
    
    func doldurSuperView(padding : UIEdgeInsets = .zero){
        translatesAutoresizingMaskIntoConstraints = false

        if let sTop = superview?.topAnchor{
            topAnchor.constraint(equalTo: sTop, constant: padding.top).isActive = true
        }
        if let sBottom = superview?.bottomAnchor{
            bottomAnchor.constraint(equalTo: sBottom, constant: -padding.bottom).isActive = true
        }
        if let sLeading = superview?.leadingAnchor{
            leadingAnchor.constraint(equalTo: sLeading, constant: padding.left).isActive = true
        }
        if let sTrailing = superview?.trailingAnchor{
            trailingAnchor.constraint(equalTo: sTrailing, constant: -padding.right).isActive = true
        }
    }
    func merkezKonumlandırSuperView(boyut: CGSize = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let merkezX = superview?.centerXAnchor{
            centerXAnchor.constraint(equalTo: merkezX).isActive = true
        }
        if let merkezY = superview?.centerYAnchor{
            centerYAnchor.constraint(equalTo: merkezY).isActive = true
        }
        if boyut.width != 0 {
            widthAnchor.constraint(equalToConstant: boyut.width).isActive = true
        }
        if boyut.height != 0 {
            heightAnchor.constraint(equalToConstant: boyut.height).isActive = true
        }
        
    }
    
    
}
