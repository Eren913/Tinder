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
    
    var sonrakiProfilView: ProfilView?
    
    var delegate : ProfilViewDelegate?
    
    //Kullanıcı view modeldaki verileri tek bir veriye eşitliyoruz
    var kullaniciViewModel : KullaniciProfilViewModel! {
        didSet{
            //let goruntuAdi = kullaniciViewModel.goruntuAdlari.first ?? ""
            fotoGecisController.kullaniciViewModel = kullaniciViewModel
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
            
            
        }
    }
    
    
    //fileprivate let imgProfil = UIImageView()
    fileprivate let fotoGecisController = FotoGecisController(kullaniciViewModelmi: true)
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
    fileprivate let btnDetayliBilgi : UIButton = {
        let btn = UIButton(type: .system)
        btn.setBackgroundImage(#imageLiteral(resourceName: "detay").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(btnDetayliBilgiPressed), for: .touchUpInside)
        return btn
    }()
    @objc fileprivate func btnDetayliBilgiPressed(){
        
        delegate?.detayliBilgiPressed(kullaniciVM: kullaniciViewModel)
    }
    fileprivate func duzenleLayout(){
        layer.cornerRadius = 15
        clipsToBounds = true
        let fotogecisView = fotoGecisController.view!
        addSubview(fotogecisView)
        fotogecisView.doldurSuperView()
        olusturGradientLayer()
        addSubview(lblKullanicibilgileri)
        _ = lblKullanicibilgileri.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, traling: trailingAnchor, padding: .init(top: 0, left: 15, bottom: 15, right: 15))
        lblKullanicibilgileri.textColor = .white
        lblKullanicibilgileri.numberOfLines = 0
        addSubview(btnDetayliBilgi)
        _ = btnDetayliBilgi.anchor(top: nil, bottom: bottomAnchor, leading: nil , traling: trailingAnchor , padding: .init(top: 0, left: 0, bottom: 17, right: 17 ),boyut: .init(width: 45, height: 45))
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
        //eğer x değeri pozitif ise(?) negatif ise(:) -1 //1 sağa -1 sola
        let translationYonu : CGFloat = panGesture.translation(in: nil).x > 0 ? 1 : -1
        //Burda eğer kullanıcıın hareket değeri.x sınır değerin üstünde olursa true oluyor  ve mutlak değere çeviriyoruz abs ile
        let profilKaybet : Bool = abs(panGesture.translation(in: nil).x) > sinirDegeri
        if profilKaybet{
            guard let anaController = self.delegate as? AnaController else{return}
                   if translationYonu == 1{
                       anaController.btnBegenPressed()
                   }else{
                       anaController.btnKapatPressed()
                   }
        }else{
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                self.transform = .identity
            })
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
protocol ProfilViewDelegate {
    func ProfiliSıradanÇıkar(profil : ProfilView)
    func detayliBilgiPressed(kullaniciVM: KullaniciProfilViewModel)
}

