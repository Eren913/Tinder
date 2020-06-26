//
//  KayitViewModel.swift
//  TinderClone
//
//  Created by lil ero on 26.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class KayitViewModel{
    var emailAdresii : String?{
        didSet{
            //Özelliklere değer atadığımız zaman  veriGecerliKontrol() fonksiyonu çalışıyor ve kayitVerileriGeceliObsorver tetikleniyor
            veriGecerliKontrol()
        }
    }
    var adiSoyadi : String?{
        didSet{
            veriGecerliKontrol()
        }
    }
    var parola : String?{
        didSet{
            veriGecerliKontrol()
        }
    }
    
    fileprivate func veriGecerliKontrol(){
        let gecerli = emailAdresii?.isEmpty == false && adiSoyadi?.isEmpty == false && parola?.isEmpty == false
        kayitVerileriGeceliObsorver?(gecerli)
    }
    
    var kayitVerileriGeceliObsorver : ((Bool) -> ())?
}
