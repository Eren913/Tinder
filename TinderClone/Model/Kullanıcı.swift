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
    var kullaniciAdi : String?
    var meslek : String?
    var yasi : Int?
    var goruntuURL1 : String
    var kullaniciID : String
    
    //İnit olusuturup kullanıcı 
    init(bilgiler : [String : Any]){
        self.kullaniciAdi = bilgiler["Adi_Soyadi"] as? String ?? ""
        self.yasi = bilgiler["Yasi"] as? Int
        self.meslek = bilgiler["Meslek"] as? String
        self.goruntuURL1 = bilgiler["Goruntu_URL"] as? String ?? ""
        self.kullaniciID = bilgiler["KullaniciID"] as? String ?? ""
        
    }
    func kullaniciProfilViewModelOlustur() -> KullaniciProfilViewModel {
        //Gelecek datalara göre verinin tipini düzenliyoruz ve view modela göre yapıyoruz bunu
        let attrText = NSMutableAttributedString(string: kullaniciAdi ?? "", attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .heavy)])
        let yasStr = yasi != nil ? " \(yasi!)" : "***"
            attrText.append(NSAttributedString(string: " \(yasStr)", attributes: [.font : UIFont.systemFont(ofSize: 23, weight: .regular)]))
        let meslekStr = meslek != nil ? "\(meslek!)" : "***"
            attrText.append(NSAttributedString(string: "\n\(meslekStr)", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        return KullaniciProfilViewModel(attrString: attrText, goruntuAdlari: [goruntuURL1], bilgiKonumu: .left)
    }
}
