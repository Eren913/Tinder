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
    var kullaniciID : String
    var goruntuURL1 : String?
    var goruntuURL2 : String?
    var goruntuURL3 : String?
    
    var ArananMinYas : Int?
    var ArananMaxYas : Int?
    
    
    //İnit olusuturup kullanıcı 
    init(bilgiler : [String : Any]){
        self.kullaniciAdi = bilgiler["Adi_Soyadi"] as? String ?? ""
        self.yasi = bilgiler["Yasi"] as? Int
        self.meslek = bilgiler["Meslek"] as? String
        self.goruntuURL1 = bilgiler["Goruntu_URL"] as? String
        self.goruntuURL2 = bilgiler["Goruntu_URL2"] as? String
        self.goruntuURL3 = bilgiler["Goruntu_URL3"] as? String
        self.kullaniciID = bilgiler["KullaniciID"] as? String ?? ""
        
        self.ArananMinYas = bilgiler["ArananMinYas"] as? Int
        self.ArananMaxYas = bilgiler["ArananMaxYas"] as? Int
        
    }
    func kullaniciProfilViewModelOlustur() -> KullaniciProfilViewModel {
        //Gelecek datalara göre verinin tipini düzenliyoruz ve view modela göre yapıyoruz bunu
        let attrText = NSMutableAttributedString(string: kullaniciAdi ?? "", attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .heavy)])
        let yasStr = yasi != nil ? " \(yasi!)" : "***"
            attrText.append(NSAttributedString(string: " \(yasStr)", attributes: [.font : UIFont.systemFont(ofSize: 23, weight: .regular)]))
        let meslekStr = meslek != nil ? "\(meslek!)" : "***"
            attrText.append(NSAttributedString(string: "\n\(meslekStr)", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        var goruntulerUrl = [String]()
        if let url = goruntuURL1 , !url.isEmpty{goruntulerUrl.append(url)}
        if let url = goruntuURL2 , !url.isEmpty{goruntulerUrl.append(url)}
        if let url = goruntuURL3 , !url.isEmpty{goruntulerUrl.append(url)}
        return KullaniciProfilViewModel(attrString: attrText, goruntuAdlari: goruntulerUrl, bilgiKonumu: .left)
    }
}
