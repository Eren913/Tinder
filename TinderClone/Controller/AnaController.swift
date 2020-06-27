//
//  ViewController.swift
//  TinderClone
//
//  Created by lil ero on 21.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import Firebase
class AnaController: UIViewController {

    let profilDizini = UIView()
    let topStackView = AnaGorunumUstStackView()
    let butonlar = AnaGorunumAltStackView()
    
    
    //Profil View Modela göre bir veri yapısı oluşturuyoruz
    var kullanicilarProfilViewModel = [KullaniciProfilViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        topStackView.btnAyarlar.addTarget(self, action: #selector(btnAyarlarPressed), for: .touchUpInside)
        layoutDuzuenle()
        gorunumuAyarla()
        KulanniciVerileriGetirFS()
    }
    @objc func btnAyarlarPressed(){
    
        let kayıtControoler = KayitController()
        present(kayıtControoler, animated: true, completion: nil)
    }
    
    fileprivate func KulanniciVerileriGetirFS(){
        Firestore.firestore().collection("Kullanicilar").getDocuments { (snapshot, error) in
            if let hata = error{
                print("Kullanıcılar getirilirken hata oluştu \(hata.localizedDescription)")
                return
            }else{
                snapshot?.documents.forEach({ (dSnapshot) in
                    let kullaniciVeri = dSnapshot.data()
                    //Çektiğimiz verileri Kullanıcı initi içerisindeki verilere atıyoruz
                    let kulanici = Kullanici(bilgiler: kullaniciVeri)
                    self.kullanicilarProfilViewModel.append(kulanici.kullaniciProfilViewModelOlustur())
                })
                //Çektiğimiz verileri func sayesinde yanstıyoruyz
                self.gorunumuAyarla()
            }
        }
    }
    //MARK: Layout düzenyeen fonksiyon
    func layoutDuzuenle(){
        view.backgroundColor = .white
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

