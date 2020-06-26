//
//  Kullanıcı.swift
//  TinderClone
//
//  Created by lil ero on 26.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import Foundation
import UIKit
struct Kullanici  : ProfilViewModelOlustur {
    //kullanıcı bilgilerinin saklaınıdığı yer
    let kullaniciAdi : String
    let meslek : String
    let yasi : Int
    let goruntuAdlari : [String]
    
    
    func kullaniciProfilViewModelOlustur() -> KullaniciProfilViewModel {
        //Gelecek datalara göre verinin tipini düzenliyoruz ve view modela göre yapıyoruz bunu
        let attrText = NSMutableAttributedString(string: kullaniciAdi, attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .heavy)])
            attrText.append(NSAttributedString(string: " \(yasi)", attributes: [.font : UIFont.systemFont(ofSize: 23, weight: .regular)]))
            attrText.append(NSAttributedString(string: "\n\(meslek)", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        return KullaniciProfilViewModel(attrString: attrText, goruntuAdlari: goruntuAdlari, bilgiKonumu: .left)
    }
}
