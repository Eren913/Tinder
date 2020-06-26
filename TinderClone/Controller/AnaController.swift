//
//  ViewController.swift
//  TinderClone
//
//  Created by lil ero on 21.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class AnaController: UIViewController {

    let profilDizini = UIView()
    let topStackView = AnaGorunumUstStackView()
    let butonlar = AnaGorunumAltStackView()
    
    
    //Profil View Modela göre bir veri yapısı oluşturuyoruz
    var kullanicilarProfilViewModel : [KullaniciProfilViewModel] = {
       let profiller = [
           Kullanici(kullaniciAdi: "Sinem", meslek: "Kuafor", yasi: 25, goruntuAdlari: ["kisi1-1","kisi1-2","kisi1-3"]),
           Kullanici(kullaniciAdi: "murat", meslek: "dj", yasi: 22, goruntuAdlari: ["kisi2"]),
           Kullanici(kullaniciAdi: "Dialn", meslek: "avukat", yasi: 27, goruntuAdlari: ["kisi3"]),
           Reklam(baslik: "steve", markaAdi: "Apple", afisGoruntuAdi: "apple")
        //KUllanıcı profil View model içerisimdeki Protocola çevirdkik
       ] as [ProfilViewModelOlustur]
        //Dizide dönen değerler KullaniciProfilViewModel tipine eşitlencek
       let viewModeller = profiller.map({$0.kullaniciProfilViewModelOlustur()})
        return viewModeller
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.btnAyarlar.addTarget(self, action: #selector(btnAyarlarPressed), for: .touchUpInside)
        layoutDuzuenle()
        gorunumuAyarla()
        
    }
    @objc func btnAyarlarPressed(){
    
        let kayıtControoler = KayitController()
        present(kayıtControoler, animated: true, completion: nil)
    }
    //MARK: Layout düzenyeen fonksiyon
    func layoutDuzuenle(){
        let genelStackView = UIStackView(arrangedSubviews: [topStackView,profilDizini,butonlar])
        genelStackView.axis = .vertical
        view.addSubview(genelStackView)
        genelStackView.doldurSuperView()
        //StackVievin düzenlenme izni ve yanlardan boşluk verme fonksiyonu
        genelStackView.isLayoutMarginsRelativeArrangement = true
        genelStackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        //en öne getirmek istediğimiz sub viewi giriyoruz
        genelStackView.bringSubviewToFront(profilDizini)
        
    }
    func gorunumuAyarla(){
        //Yuakrda oluşturduğumuz veriyi view da gösteryiyorzu
        kullanicilarProfilViewModel.forEach { (kullaniciM) in
            let profilView = ProfilView(frame: .zero)
            profilView.kullaniciViewModel = kullaniciM
            profilDizini.addSubview(profilView)
            profilView.doldurSuperView()
            
        }
    }
}

