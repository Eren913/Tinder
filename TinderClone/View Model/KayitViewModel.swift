//
//  KayitViewModel.swift
//  TinderClone
//
//  Created by lil ero on 26.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import Firebase

class KayitViewModel{
    
    var bindableimg = Bindable<UIImage>()
    var bindableKayitVerileriGecerli = Bindable<Bool>()
    var bindableKayitOluyor = Bindable<Bool>()
    
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
    
     func veriGecerliKontrol(){
        let gecerli = emailAdresii?.isEmpty == false && adiSoyadi?.isEmpty == false && parola?.isEmpty == false && bindableimg.deger != nil
        bindableKayitVerileriGecerli.deger = gecerli
    }
    
    //MARK: FireStore ----------
    //Kullancıyı kayıt edip verilerini data base üzerine atıyoruz
    func kullaniciKayitGerceklesti(completion : @escaping (Error?) ->()){
        guard let emailAdresi = emailAdresii, let parola = parola else {return}
        
        bindableKayitOluyor.deger = true
        Auth.auth().createUser(withEmail: emailAdresi, password: parola) { (sonuc, hata) in
            if let hata = hata{
                print("Kullanıcı Kayıt olurken hata meydana geldi \(hata.localizedDescription)")
                completion(hata)
            }else{
                print("Kullanıcı Kaydı başarılı \(sonuc!.user.uid)")
                self.goruntuFirebaseKaydet(completion: completion)
            }
        }
    }
    fileprivate func goruntuFirebaseKaydet (completion : @escaping (Error?)->()){
        let goruntuAdi = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/Goruntuler/\(goruntuAdi)")
        let goruntuData = self.bindableimg.deger?.jpegData(compressionQuality: 0.8) ?? Data()
        ref.putData(goruntuData, metadata: nil) { (_, error) in
            if let hata = error{
                completion(hata)
                return
            }
            print("...Goruntu Basarı ile upload edildi")
            ref.downloadURL { (url, error) in
                if let hata = error{
                    completion(hata)
                    return
                }
                //Kullanıcı kayıt işlemi başarılı
                self.bindableKayitOluyor.deger = false
                let goruntuURL = url?.absoluteString ?? ""
                self.kullaniciBilgileriniFireStoreKaydet(goruntUrl: goruntuURL, completion: completion)
            }
        }
    }
    fileprivate func kullaniciBilgileriniFireStoreKaydet(goruntUrl : String ,completion : @escaping (Error?)->()){
        let kullaniciID = Auth.auth().currentUser?.uid ?? ""
        let eklenecekVeri = ["Adi_Soyadi" : adiSoyadi ?? "AD YOK",
                             "Goruntu_URL": goruntUrl,
                             "KullaniciID" :kullaniciID,
                             "Yas" : 18,
                             "ArananMinYas" : AyarlarController.varsayilanArananMinYas,
                             "ArananMaxYas" : AyarlarController.varsayilanArananMaxYas
            ] as [String : Any]
        Firestore.firestore().collection("Kullanicilar").document(kullaniciID).setData(eklenecekVeri) { (hata) in
            if let hata = hata{
                completion(hata)
                return
            }
            completion(nil)
        }
    }
}
