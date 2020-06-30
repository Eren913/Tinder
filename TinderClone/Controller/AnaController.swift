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
        AltButonlarStackView.btnBegen.addTarget(self, action: #selector(btnBegenPressed), for: .touchUpInside)
        AltButonlarStackView.btnKapat.addTarget(self, action: #selector(btnKapatPressed), for: .touchUpInside)
        layoutDuzuenle()
        //kullaniciProfilleriAyarlaFirestore()
        //kulanniciVerileriGetirFS()
        
        // denemeLogin()
        gecerlikullaniciyiGetir()
        
    }
    @objc fileprivate func btnKapatPressed(){
        profilGecisAnimasyon(translation: -800, angle: -18)
    }
    var gorunenEnUstProfilView : ProfilView?
    @objc fileprivate func btnBegenPressed(){
        profilGecisAnimasyon(translation: 800, angle: 18)
        
    }
    fileprivate func profilGecisAnimasyon(translation : CGFloat,angle : CGFloat){
        
        let basicAnimation = CABasicAnimation(keyPath: "position.x")
        basicAnimation.toValue = translation
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        //Animasyon sonucunu ekran dışında saklayıp geri gelmemesni sağlıyoruz
        basicAnimation.isRemovedOnCompletion = false
        
        
        let dondurmeAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        dondurmeAnimation.toValue = CGFloat.pi * angle / 180
        dondurmeAnimation.duration = 1
        let ustpView = gorunenEnUstProfilView
        gorunenEnUstProfilView = ustpView?.sonrakiProfilView
        
        CATransaction.setCompletionBlock {
            ustpView?.removeFromSuperview()
        }
        ustpView?.layer.add(basicAnimation, forKey: "anime")
        ustpView?.layer.add(dondurmeAnimation, forKey: "dondurme")
        CATransaction.commit()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil{
            
            let kayitController = KayitController()
            kayitController.delegate = self
            
            let nav = UINavigationController(rootViewController: kayitController)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
    }
    fileprivate var gecerliKullanici : Kullanici?
    fileprivate func gecerlikullaniciyiGetir(){
        profilDizini.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        Firestore.firestore().gecerliKullaniciyiGetir { (kullanici, error) in
            if let error = error{
                print("...kullanici bilgileri getirilirken hata oluştu\(error.localizedDescription)")
                return
            }
            self.gecerliKullanici = kullanici
            self.kulanniciVerileriGetirFS()
        }
    }
    fileprivate func denemeLogin(){
        Auth.auth().signIn(withEmail: "q@q.com", password: "123456", completion: nil)
        print("Oturum açıldı")
    }
    @objc func btnYenilePressed(){
        if gorunenEnUstProfilView == nil {
            kulanniciVerileriGetirFS()
        }
    }
    @objc func btnAyarlarPressed(){
        
        let ayarlarController = AyarlarController()
        ayarlarController.Delegate = self
        let navController = UINavigationController.init(rootViewController: ayarlarController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    var sonGetirilenKullanici : Kullanici?
    
    fileprivate func kulanniciVerileriGetirFS(){
        
        //  guard let arananMinYas = gecerliKullanici?.ArananMinYas , let arananMaxYas = gecerliKullanici?.ArananMaxYas else {return}
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Profiller Getiriliyor"
        hud.show(in: view)
        
        let arananMinYas = gecerliKullanici?.ArananMinYas ?? AyarlarController.varsayilanArananMinYas
        let arananMaxYas = gecerliKullanici?.ArananMaxYas ?? AyarlarController.varsayilanArananMaxYas
        
        let sorgu = Firestore.firestore().collection("Kullanicilar")
            .whereField("Yasi", isGreaterThan: arananMinYas)
            .whereField("Yasi", isLessThanOrEqualTo: arananMaxYas)
        gorunenEnUstProfilView = nil
        sorgu.getDocuments { (snapshot, error) in
            hud.dismiss()
            if let hata = error{
                print("Kullanıcılar getirilirken hata oluştu \(hata.localizedDescription)")
                return
            }else{
                var oncekiProfilView : ProfilView?
                snapshot?.documents.forEach({ (dSnapshot) in
                    let kullaniciVeri = dSnapshot.data()
                    //Çektiğimiz verileri Kullanıcı initi içerisindeki verilere atıyoruz
                    let kulanici = Kullanici(bilgiler: kullaniciVeri)
                    if kulanici.kullaniciID != self.gecerliKullanici?.kullaniciID{
                        let pView = self.kullanicidanProfilOlustur(kullanici: kulanici)
                        
                        if self.gorunenEnUstProfilView == nil{
                            self.gorunenEnUstProfilView = pView
                        }
                        oncekiProfilView?.sonrakiProfilView = pView
                        oncekiProfilView = pView
                    }
                })
                //Çektiğimiz verileri func sayesinde yanstıyoruyz
            }
        }
    }
    fileprivate func kullanicidanProfilOlustur(kullanici: Kullanici) -> ProfilView{
        let pView = ProfilView(frame: .zero)
        pView.delegate = self
        pView.kullaniciViewModel = kullanici.kullaniciProfilViewModelOlustur()
        profilDizini.addSubview(pView)
        profilDizini.sendSubviewToBack(pView)
        pView.doldurSuperView()
        return pView
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
extension AnaController : AyarlarControllerDelegate{
    func ayarlarKaydedildi() {
        print("Ayarlar kaydedildi haberim var")
        gecerlikullaniciyiGetir()
    }
}
extension AnaController : OturumControllerDelegate{
    func OturumAcmaBitis() {
        gecerlikullaniciyiGetir()
    }
}
extension AnaController : ProfilViewDelegate{
    
    func ProfiliSıradanÇıkar(profil: ProfilView) {
        self.gorunenEnUstProfilView?.removeFromSuperview()
        self.gorunenEnUstProfilView = self.gorunenEnUstProfilView?.sonrakiProfilView
    }
    
    func detayliBilgiPressed(kullaniciVM: KullaniciProfilViewModel) {
        let kullaniciDetaylari = KullaniciDetaylariController()
        kullaniciDetaylari.modalPresentationStyle = .fullScreen
        kullaniciDetaylari.kullaniciViewModel = kullaniciVM
        present(kullaniciDetaylari, animated: true, completion: nil)
    }
}

