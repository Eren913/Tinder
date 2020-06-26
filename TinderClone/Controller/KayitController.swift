//
//  KayıtController.swift
//  TinderClone
//
//  Created by lil ero on 26.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class KayitController: UIViewController {
//MARK: Objeler
    let btnFotorafsec : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("FotoSeç", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        
        btn.layer.cornerRadius = 15
        btn.heightAnchor.constraint(equalToConstant: 280).isActive = true
        return btn
    }()
    let txtEmailAdrsi : UITextField = {
        let txt = OzelTextField(padding : 15)
        txt.backgroundColor = .white
        txt.placeholder = "Email Adress"
        txt.keyboardType = .emailAddress
        return txt
    }()
    
    let txtAdiSyoadi : UITextField = {
        let txt = OzelTextField(padding : 15)
        txt.backgroundColor = .white
        txt.placeholder = "Ad ve Soyad"
        return txt
    }()
    let txtParola : UITextField = {
        let txt = OzelTextField(padding : 15)
        txt.backgroundColor = .white
        txt.placeholder = "Parola"
        txt.isSecureTextEntry = true
        return txt
    }()
    let btnKayitol : UIButton = {
        let btn  = UIButton(type: .system)
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.layer.cornerRadius = 22
        btn.setTitle("Kayıt ol", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        btn.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        return btn
    }()
    //MARK: Değişkenler
    lazy var kayitStackView = UIStackView(arrangedSubviews: [
    btnFotorafsec,
    txtEmailAdrsi,
    txtAdiSyoadi,
    txtParola,
    btnKayitol
    ])
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        arkaplanGradientAyarla()
        layoutDuzenle()
        olusturNotificationObserver()
        ekleTapGesture()
    }
    override func viewDidDisappear(_ animated: Bool) {
        //Sayfa kaybolurken Notification verilerini siliyor
        super.viewWillAppear(true)
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: Fonksiyonlar
    fileprivate func ekleTapGesture(){
        //Vievın tamamına gestıre ekliyoruz
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(klavyeKapat)))
    }
    @objc fileprivate func klavyeKapat(){
        //Klavyeyi animasyonlu bir şekilde kapatıyor
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        }, completion: nil)
    }
    fileprivate func olusturNotificationObserver(){
        //klavye için observer ekiyoruz
        NotificationCenter.default.addObserver(self, selector: #selector(klavyeGosterimiYakala), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(klavyeGizlenmesiniYakala), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc fileprivate func klavyeGizlenmesiniYakala(){
        //Klavye gizlenirken ne olacağını hesaplıyor
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        self.view.transform = .identity
        }, completion: nil)
    }
    @objc fileprivate func klavyeGosterimiYakala(notifaction : Notification){
        //Klavye çıkınca ekranın ne kadar yukarı kayacağını hesaplıyoruz
        //User info bize tüm değerleri veriyor
        guard  let klaveBitisDegeri = notifaction.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        //aldığımız bitiş değerini CGRect rürüne çeviriyoruz
        let klavyebitisFrame = klaveBitisDegeri.cgRectValue
        //Enalttaki butonun ekranın sonu ile olan aradaki boşluk miktarı
        let altBoslukMiktarı = view.frame.height - (kayitStackView.frame.origin.y + kayitStackView.frame.height)
        //klavyenin yüksekliği ile boşluk mitarı arasındaki fark
        let hatapayı = klavyebitisFrame.height - altBoslukMiktarı
        self.view.transform = CGAffineTransform(translationX: 0, y: -hatapayı - 10 )
    }
    //Objelerin viewdaki yerini düzenliyor
    fileprivate func layoutDuzenle(){
        self.navigationController?.navigationBar.isHidden = true
        view.addSubview(kayitStackView)
        kayitStackView.axis = .vertical
        kayitStackView.spacing = 10
        _ = kayitStackView.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, traling: view.trailingAnchor,padding: .init(top: 0, left: 45, bottom: 0, right: 45))
        kayitStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    //Ekranın arka plandaki greadient rengini ayarlıyor
    private func arkaplanGradientAyarla(){
        let gradient = CAGradientLayer()
        let ustRenk = #colorLiteral(red: 0.6392156863, green: 0.8, blue: 0.9568627451, alpha: 1)
        let altRenk = #colorLiteral(red: 0.1215686275, green: 0.1490196078, blue: 0.737254902, alpha: 1)
        gradient.colors = [ustRenk.cgColor , altRenk.cgColor]
        gradient.locations = [0.1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.bounds
        
    }
}
