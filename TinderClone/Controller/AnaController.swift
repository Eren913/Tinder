//
//  ViewController.swift
//  TinderClone
//
//  Created by lil ero on 21.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
class AnaController: UIViewController {
    
    let profilDizini = UIView()
    let topStackView = AnaGorunumUstStackView()
    let AltButonlarStackView = AnaGorunumAltStackView()
    
    
    //Profil View Modela göre bir veri yapısı oluşturuyoruz
    var kullanicilarProfilViewModel = [KullaniciProfilViewModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        topStackView.btnAyarlar.addTarget(self, action: #selector(btnAyarlarPressed), for: .touchUpInside)
        AltButonlarStackView.btnYenile.addTarget(self, action: #selector(btnYenilePressed), for: .touchUpInside)
        layoutDuzuenle()
        kullaniciProfilleriAyarlaFirestore()
        kulanniciVerileriGetirFS()
        
       denemeLogin()
        
        
    }
    fileprivate func denemeLogin(){
        Auth.auth().signIn(withEmail: "q@q.com", password: "123456", completion: nil)
        print("Oturum açıldı")
    }
    @objc func btnYenilePressed(){
        kulanniciVerileriGetirFS()
    }
    @objc func btnAyarlarPressed(){
        
        let ayarlarController = AyarlarController()
        let navController = UINavigationController.init(rootViewController: ayarlarController)
        present(navController, animated: true, completion: nil)
    }
    var sonGetirilenKullanici : Kullanici?
    
    fileprivate func kulanniciVerileriGetirFS(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Profiller Getiriliyor"
        hud.show(in: view)
        
        let sorgu = Firestore.firestore().collection("Kullanicilar")
            .order(by: "KullaniciID")
            .start(after: [sonGetirilenKullanici?.kullaniciID ?? ""])
            .limit(to: 2)
        sorgu.getDocuments { (snapshot, error) in
            hud.dismiss()
            if let hata = error{
                print("Kullanıcılar getirilirken hata oluştu \(hata.localizedDescription)")
                return
            }else{
                snapshot?.documents.forEach({ (dSnapshot) in
                    let kullaniciVeri = dSnapshot.data()
                    //Çektiğimiz verileri Kullanıcı initi içerisindeki verilere atıyoruz
                    let kulanici = Kullanici(bilgiler: kullaniciVeri)
                    self.kullanicilarProfilViewModel.append(kulanici.kullaniciProfilViewModelOlustur())
                    self.sonGetirilenKullanici = kulanici
                    self.kullanicidanProfilOlustur(kullanici: kulanici)
                })
                //Çektiğimiz verileri func sayesinde yanstıyoruyz
            }
        }
    }
    fileprivate func kullanicidanProfilOlustur(kullanici: Kullanici){
        let pView = ProfilView(frame: .zero)
        pView.kullaniciViewModel = kullanici.kullaniciProfilViewModelOlustur()
        profilDizini.addSubview(pView)
        pView.doldurSuperView()
    }
    //MARK: Layout düzenyeen fonksiyon
    func layoutDuzuenle(){
        view.backgroundColor = .white
        let genelStackView = UIStackView(arrangedSubviews: [topStackView,profilDizini,AltButonlarStackView])
        genelStackView.axis = .vertical
        view.addSubview(genelStackView)
        genelStackView.doldurSuperView()
        //StackVievin düzenlenme izni ve yanlardan boşluk verme fonksiyonu
        genelStackView.isLayoutMarginsRelativeArrangement = true
        genelStackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        //en öne getirmek istediğimiz sub viewi giriyoruz
        genelStackView.bringSubviewToFront(profilDizini)
        
    }
    func kullaniciProfilleriAyarlaFirestore(){
        //Yuakrda oluşturduğumuz veriyi view da gösteryiyorzu
        kullanicilarProfilViewModel.forEach { (kullaniciM) in
            let profilView = ProfilView(frame: .zero)
            profilView.kullaniciViewModel = kullaniciM
            profilDizini.addSubview(profilView)
            profilView.doldurSuperView()
            
        }
    }
}

