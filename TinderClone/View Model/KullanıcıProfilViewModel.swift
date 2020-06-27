//
//  Kullanıcı View Model.swift
//  TinderClone
//
//  Created by lil ero on 26.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import Foundation
import UIKit
class KullaniciProfilViewModel {
    
    let attrString : NSAttributedString
    let goruntuAdlari : [String]
    let bilgiKonumu : NSTextAlignment
    
    init(attrString : NSAttributedString,goruntuAdlari : [String],bilgiKonumu : NSTextAlignment){
        self.attrString = attrString
        self.goruntuAdlari = goruntuAdlari
        self.bilgiKonumu = bilgiKonumu
    }
    
    fileprivate var goruntuIndex = 0{
        didSet{
            //alcağı değerler
            let goruntuURL = goruntuAdlari[goruntuIndex]
            //komut
            goruntuIndexGozlemci?(goruntuIndex,goruntuURL)
        }
    }
    var goruntuIndexGozlemci : ((Int ,String?) -> ())?
    
    func sonrakiGoruntuyeGit(){
        //goruntu indexi goruntü adlarından büyükse 0. elemana getir eüer değilse 1 arttırmaya devam et
        goruntuIndex = goruntuIndex + 1 >= goruntuAdlari.count ? 0 : goruntuIndex + 1
        }
    func oncekiGoruntuyeGit(){
        //Eğere görüntü indexi 0 dan küçükse en son fotorafa git eğer değilse azaltmaya devam et
        goruntuIndex = goruntuIndex - 1 < 0 ? goruntuAdlari.count - 1 : goruntuIndex - 1
    }
    
}
//Protokol uygulanan nesne bu fonksiyonu uygulamak zorunda kalcak
protocol ProfilViewModelOlustur {
    func kullaniciProfilViewModelOlustur() -> KullaniciProfilViewModel
}
