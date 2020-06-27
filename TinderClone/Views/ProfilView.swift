//
//  ProfilView.swift
//  TinderClone
//
//  Created by lil ero on 26.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import SDWebImage
class ProfilView: UIView {
    //Kullanıcı view modeldaki verileri tek bir veriye eşitliyoruz
    var kullaniciViewModel : KullaniciProfilViewModel! {
        didSet{
            let goruntuAdi = kullaniciViewModel.goruntuAdlari.first ?? ""
            if let url = URL(string: goruntuAdi){
                imgProfil.sd_setImage(with: url)
            }
            lblKullanicibilgileri.attributedText = kullaniciViewModel.attrString
            lblKullanicibilgileri.textAlignment = kullaniciViewModel.bilgiKonumu
            
            (0..<kullaniciViewModel.goruntuAdlari.count).forEach { (_) in
                let bView = UIView()
                //Bütün elemanlara gri rengini veriyoru
                bView.backgroundColor = secilOlmayanRenk
                goruntuBarStackView.addArrangedSubview(bView)
            }
            //seçili olan ilk elemana beyaz rengini veriyoruz
            goruntuBarStackView.arrangedSubviews.first?.backgroundColor = .white
            ayarlaGoruntundexGozlemci()
            
        }
    }
    
    fileprivate func ayarlaGoruntundexGozlemci(){
        
        kullaniciViewModel.goruntuIndexGozlemci = { (index,goruntuURL) in
            self.goruntuBarStackView.arrangedSubviews.forEach { (sView) in
                sView.backgroundColor = self.secilOlmayanRenk
            }
            self.goruntuBarStackView.arrangedSubviews[index].backgroundColor = .white
            
            if let url = URL(string: goruntuURL ?? ""){
                self.imgProfil.sd_setImage(with: url)
            }
        }
    }
    
    
    fileprivate let imgProfil = UIImageView()
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let lblKullanicibilgileri = UILabel()
    fileprivate let sinirDegeri : CGFloat = 120
    fileprivate let secilOlmayanRenk = UIColor(white: 0, alpha: 0.2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        duzenleLayout()
        
        //Tutup sürüklemek için kullanılan gesture Recognizer
        let panG = UIPanGestureRecognizer(target: self, action: #selector(profilPanYakala))
        addGestureRecognizer(panG)
        let tapG = UITapGestureRecognizer(target: self, action: #selector(yakalaTapGestureRecognizer))
        addGestureRecognizer(tapG)
    }
    fileprivate func duzenleLayout(){
        layer.cornerRadius = 15
        clipsToBounds = true
        imgProfil.contentMode = .scaleAspectFill
        addSubview(imgProfil)
        imgProfil.doldurSuperView()
        olsusturBarstackView()
        olusturGradientLayer()
        addSubview(lblKullanicibilgileri)
        _ = lblKullanicibilgileri.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, traling: trailingAnchor, padding: .init(top: 0, left: 15, bottom: 15, right: 15))
        lblKullanicibilgileri.textColor = .white
        lblKullanicibilgileri.numberOfLines = 0
    }
    @objc fileprivate func yakalaTapGestureRecognizer(tapG : UITapGestureRecognizer){
        //Basılan konumun değerini alıyoruz
        let konum = tapG.location(in: nil)
        //basılan konum genişliği frame değerinden büyükse true döndür değilse false döndür
        let sonrakiGoruntuGecis = konum.x > frame.width / 2 ? true : false
        if sonrakiGoruntuGecis{
            kullaniciViewModel.sonrakiGoruntuyeGit()
        }else {
            kullaniciViewModel.oncekiGoruntuyeGit()
        }
    }
    fileprivate let goruntuBarStackView = UIStackView()
    fileprivate func olsusturBarstackView(){
        addSubview(goruntuBarStackView)
        _ = goruntuBarStackView.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, traling: trailingAnchor,padding:.init(top: 8, left: 8, bottom: 0, right: 8),boyut: .init(width: 0, height: 4))
        //Elemanlar arasında 4 boşluk bırakıyor
        goruntuBarStackView.spacing = 4
        goruntuBarStackView.distribution = .fillEqually
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func olusturGradientLayer(){
        //Siyah renkte bir gradient oluştuyoruz
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        //Renk geçiş değerlerini veriryoruz
        gradientLayer.locations = [0.4,1.4]
        //layer katmanına eklyiroruz
        layer.addSublayer(gradientLayer)
        
    }
    override func layoutSubviews() {
        //gradient değelerini bütün katmana yayıyor ve ekstradan bu fonksiyon bütün layer değerlerini veriyor
        gradientLayer.frame = self.frame
    }
    
    @objc func profilPanYakala(panGesture : UIPanGestureRecognizer){
        switch panGesture.state {
        case .began :
            //çekmeye başladığımızda bütün animasyonları kaldırıyor
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            //çekmeye başladığımızda
            degisiklikPanyakala(panGesture)
        case .ended:
            //çekmeyi bıraktığımızda
            bitisPanAnimasyon(panGesture)
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        default:
            break
        }
    }
    
    fileprivate func bitisPanAnimasyon( _ panGesture : UIPanGestureRecognizer) {
        //Kullanıcının hareket ettirebilceği bir sınır değeri giriyoruz
        //sinirdegeri
        //eğer x değeri pozitif ise(?) negatif ise(:) -1
        let translationYonu : CGFloat = panGesture.translation(in: nil).x > 0 ? 1 : -1
        //Burda eğer kullanıcıın hareket değeri.x sınır değerin üstünde olursa true oluyor  ve mutlak değere çeviriyoruz abs ile
        let profilKaybet : Bool = abs(panGesture.translation(in: nil).x) > sinirDegeri
        UIView.animate(withDuration: 0.8, delay: 0, /* Resmin Yaylanma çzelliğini ifade ediyor*/ usingSpringWithDamping: 0.5, /*Animasyonun hızı */initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            //animasyonun amacını yazıyoruz
            if profilKaybet {
                //burda ise profil remisini x düzlemind e900 birim fırlatıyoruz değer true ise
                let ekranDisi = self.transform.translatedBy(x: 900*translationYonu, y: 0)
                self.transform = ekranDisi
            }else{
                //false dönünce değer eski yerine dönmesini sağlıutz
                self.transform = .identity
            }
            
        }) { (_) in
            //Kart Geri gelince yazılan yazı ve geri gelince frame de durcak yerini belirliyoruz
            print("Animasyon Bitti Kart Geliyor")
            self.transform = .identity
            if profilKaybet{
                //Giden resmi kaybediyor ortadan
                self.removeFromSuperview()
            }
        }
    }
    
    fileprivate func degisiklikPanyakala(_ panGesture: UIPanGestureRecognizer) {
        
        //kullanıcının mouse hareketinin kordinatını aldık
        let translation = panGesture.translation(in: nil)
        //dereceyi translation a göre  radyan açıya çeviriyoruz
        let derece : CGFloat = translation.x / 17
        let radyanAci = (derece * .pi) / 180
        
        //Resmi açılı bir şekilde hareket ettiriyoruz
        let dondurmeTransform = CGAffineTransform(rotationAngle: radyanAci)
        //var olan CGA objesinden yeni bir tane yaratıyor x ve y eksenine göre
        self.transform = dondurmeTransform.translatedBy(x: translation.x, y: translation.y)
        
    }
}
