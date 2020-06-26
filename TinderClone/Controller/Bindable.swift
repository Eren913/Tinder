//
//  Bindable.swift
//  TinderClone
//
//  Created by lil ero on 27.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import Foundation
//Tüm observerları bi çatı altında toplamak için bindable yapısını kullandık 
class Bindable <K> {
    var  deger : K?{
        didSet{
            gozlemci?(deger)
        }
    }
    var gozlemci : ((K?)-> ())?
    
    func degerAta (gozlemci : @escaping (K?) -> ()){
        self.gozlemci = gozlemci
    }
}
