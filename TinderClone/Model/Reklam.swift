//
//  Reklam.swift
//  TinderClone
//
//  Created by lil ero on 26.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit


struct Reklam : ProfilViewModelOlustur{
    
    let baslik : String
    let markaAdi : String
    let afisGoruntuAdi : String
    
     func kullaniciProfilViewModelOlustur() -> KullaniciProfilViewModel {
        let attrText = NSMutableAttributedString(string: baslik, attributes: [.font : UIFont.systemFont(ofSize: 35, weight: .heavy)])
        attrText.append(NSAttributedString(string: "\n\(markaAdi)", attributes: [.font : UIFont.systemFont(ofSize: 25, weight: .bold)]))
        return KullaniciProfilViewModel(attrString: attrText, goruntuAdlari: [afisGoruntuAdi], bilgiKonumu: .center)
    }
    
    
}
