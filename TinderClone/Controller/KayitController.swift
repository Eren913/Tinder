//
//  KayıtController.swift
//  TinderClone
//
//  Created by lil ero on 26.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

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
        
        btn.addTarget(self, action: #selector(btnFotorafSecPressed), for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        return btn
    }()
    let txtEmailAdrsi : UITextField = {
        let txt = OzelTextField(padding : 15)
        txt.backgroundColor = .white
        txt.placeholder = "Email Adress"
        txt.keyboardType = .emailAddress
        txt.addTarget(self, action: #selector(yakalaTextFieldDeğişim), for: .editingChanged)
        return txt
    }()
    
    let txtAdiSyoadi : UITextField = {
        let txt = OzelTextField(padding : 15)
        txt.backgroundColor = .white
        txt.placeholder = "Ad ve Soyad"
        txt.addTarget(self, action: #selector(yakalaTextFieldDeğişim), for: .editingChanged)
        return txt
    }()
    let txtParola : UITextField = {
        let txt = OzelTextField(padding : 15)
        txt.backgroundColor = .white
        txt.placeholder = "Parola"
        txt.isSecureTextEntry = true
        txt.addTarget(self, action: #selector(yakalaTextFieldDeğişim), for: .editingChanged)
        return txt
    }()
    let btnKayitol : UIButton = {
        let btn  = UIButton(type: .system)
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.layer.cornerRadius = 22
        btn.setTitle("Kayıt ol", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        //btn.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        btn.backgroundColor = .lightGray
        btn.setTitleColor(.darkGray, for: .disabled)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(btnKayitOlPressed), for: .touchUpInside)
        return btn
    }()
    //MARK:- Değişkenler
    lazy var kayitStackView = UIStackView(arrangedSubviews: [
        btnFotorafsec,
        dikeySV
    ])
    //Telefonun dikey stack view da olacak fonksyionlar
    lazy var dikeySV : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            txtEmailAdrsi,
            txtAdiSyoadi,
            txtParola,
            btnKayitol
        ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 10
        return sv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        arkaplanGradientAyarla()
        layoutDuzenle()
        olusturNotificationObserver()
        ekleTapGesture()
        olusturKayitViewModelObsorver()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        //Sayfa kaybolurken Notification verilerini siliyor
        super.viewWillAppear(true)
        NotificationCenter.default.removeObserver(self)
    }
    //MARK:- Fonksiyonlar
    
    //Telefon eklanı yön değiştirdiği  zaman tetiklenecek fonksiyon
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact{
            kayitStackView.axis = .horizontal
        }else{
            kayitStackView.axis = .vertical
        }
    }
    //Bir nesne türettik KayitViewModel dan
    let kayitViewModel = KayitViewModel()
    fileprivate func olusturKayitViewModelObsorver(){
        //kayıtlı olan modelin observırna değer koyduk
        kayitViewModel.bindableKayitVerileriGecerli.degerAta { (gecerli) in
            guard let gecerli = gecerli else {return}
            if gecerli{
                //fieldlar eğer dolu ise
                self.btnKayitol.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
                self.btnKayitol.setTitleColor(.white, for: .normal)
                self.btnKayitol.isEnabled = true
            }else{
                //Boş ise
                self.btnKayitol.backgroundColor = .lightGray
                self.btnKayitol.setTitleColor(.darkGray, for: .disabled)
                self.btnKayitol.isEnabled = false
            }
        }
        kayitViewModel.bindableimg.degerAta { (imgProfil) in
            self.btnFotorafsec.setImage(imgProfil?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        kayitViewModel.bindableKayitOluyor.degerAta { (kayıtoluyor) in
            
            if kayıtoluyor == true{
                self.kayitHud.textLabel.text = "Hesap Oluşturuluyor"
                self.kayitHud.show(in : self.view)
            }else {
                self.kayitHud.dismiss()
            }
        }
    }
    @objc fileprivate func yakalaTextFieldDeğişim(textfield: UITextField){
        //kayitViewModel nesneine değer atıyoruz
        if textfield == txtEmailAdrsi{
            kayitViewModel.emailAdresii = textfield.text
        }else if textfield == txtAdiSyoadi{
            kayitViewModel.adiSoyadi = textfield.text
        }else if textfield == txtParola{
            kayitViewModel.parola = textfield.text
        }
        
    }
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
        if hatapayı < 0 {
            return
        }
        self.view.transform = CGAffineTransform(translationX: 0, y: -hatapayı - 10 )
    }
    //Objelerin viewdaki yerini düzenliyor
    fileprivate func layoutDuzenle(){
        self.navigationController?.navigationBar.isHidden = true
        view.addSubview(kayitStackView)
        kayitStackView.axis = .vertical
        //Yatay düzeye geçtiği zaman fotoraf seç butonunun değerlerini giriyoruz-----
        btnFotorafsec.widthAnchor.constraint(equalToConstant: 260).isActive = true
        //---------
        kayitStackView.spacing = 10
        _ = kayitStackView.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, traling: view.trailingAnchor,padding: .init(top: 0, left: 45, bottom: 0, right: 45))
        kayitStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    //Ekran döndürmesi her gerçekleştiği sırada  bu meteod çaışıyor
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradient.frame = view.bounds
    }
    let gradient = CAGradientLayer()
    //Ekranın arka plandaki greadient rengini ayarlıyor
    private func arkaplanGradientAyarla(){
        let ustRenk = #colorLiteral(red: 0.6392156863, green: 0.8, blue: 0.9568627451, alpha: 1)
        let altRenk = #colorLiteral(red: 0.1215686275, green: 0.1490196078, blue: 0.737254902, alpha: 1)
        gradient.colors = [ustRenk.cgColor , altRenk.cgColor]
        gradient.locations = [0.1]
        view.layer.addSublayer(gradient)
    }
    fileprivate func hatabilgilendirmeHUD(hata : Error){
        //Ufak bir bilgilendirme kutucuğu oluşturuyor
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Kayıt işlemi başarısız"
        hud.detailTextLabel.text = hata.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2, animated: true)
        
    }
    @objc fileprivate func btnFotorafSecPressed(){
        let imgPickerController = UIImagePickerController()
        imgPickerController.delegate = self
        present(imgPickerController, animated: true, completion: nil)
    }
    //MARK: -FireBase
    let kayitHud = JGProgressHUD(style: .dark)
    @objc fileprivate func btnKayitOlPressed(){
        self.klavyeKapat()
        //Kayıt view model içerisen yazıyoruz 
        kayitViewModel.kullaniciKayitGerceklesti { (hata) in
            if let hata = hata{
                self.hatabilgilendirmeHUD(hata: hata)
                return
            }
        }
    }
}
extension KayitController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imgSecilen = info[.originalImage] as? UIImage
        kayitViewModel.bindableimg.deger = imgSecilen
        dismiss(animated: true, completion: nil)
    }
}

