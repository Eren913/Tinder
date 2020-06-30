//
//  KullaniciDetaylariController.swift
//  TinderClone
//
//  Created by lil ero on 29.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class KullaniciDetaylariController: UIViewController {
    
    var kullaniciViewModel : KullaniciProfilViewModel!{
        didSet{
            fotoGecisController.kullaniciViewModel = kullaniciViewModel
            lblbilgi.attributedText = kullaniciViewModel.attrString
            
            
            
        }
    }
    lazy var scroolView : UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        //olduğu yerde tut herhangi bir padding değeri atama
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()

    let fotoGecisController = FotoGecisController()
    let lblbilgi : UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    let btnDetayKapat : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "detaykapat").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(tapGestureKapat), for: .touchUpInside)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        layoutDüzenle()
        blurEfektiOlustur()
        altbutonlarKonumAyarla()
    }
    fileprivate let ekYukseklik : CGFloat = 90
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let fotoGecisView = fotoGecisController.view!
        fotoGecisView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + ekYukseklik)
    }
    @objc fileprivate func tapGestureKapat(){
        self.dismiss(animated: true, completion: nil)
    }
    fileprivate func layoutDüzenle() {
        
        let fotoGecisView = fotoGecisController.view!
        scroolView.addSubview(fotoGecisView)
        fotoGecisView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        view.addSubview(scroolView)
        scroolView.doldurSuperView()
        
        scroolView.addSubview(lblbilgi)
        _ = lblbilgi.anchor(top: fotoGecisView.bottomAnchor, bottom: nil, leading: scroolView.leadingAnchor, traling: scroolView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        view.addSubview(btnDetayKapat)
        _ = btnDetayKapat.anchor(top: fotoGecisView.bottomAnchor, bottom: nil, leading: nil, traling: view.trailingAnchor,padding: .init(top: -25, left: 0, bottom: 0, right: 25),boyut: .init(width: 50, height: 50))
    }
    fileprivate func blurEfektiOlustur(){
        let blurEfekt = UIBlurEffect(style: .regular)
        let effektView = UIVisualEffectView(effect: blurEfekt)
        view.addSubview(effektView)
        _ = effektView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, traling: view.trailingAnchor)
        
    }
    fileprivate func butonOlustur(image: UIImage,selector : Selector)->UIButton{
        let buton = UIButton(type: .system)
        buton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        buton.addTarget(self, action: selector, for: .touchUpInside)
        buton.imageView?.contentMode = .scaleAspectFill
        return buton
    }
    lazy var btndislike = self.butonOlustur(image:#imageLiteral(resourceName: "kapat") , selector: #selector(dislikePressed))
    lazy var btnSuperlike = self.butonOlustur(image:#imageLiteral(resourceName: "superLike") , selector: #selector(superlikePressed))
    lazy var btnlike = self.butonOlustur(image:#imageLiteral(resourceName: "like") , selector: #selector(likePressed))
    
    
    @objc fileprivate func dislikePressed(){
        
    }
    @objc fileprivate func superlikePressed(){
        
    }
    @objc fileprivate func likePressed(){
        
    }
    
    fileprivate func altbutonlarKonumAyarla(){
        let sv = UIStackView(arrangedSubviews: [btnlike,btnSuperlike,btndislike])
        sv.distribution = .fillEqually
        view.addSubview(sv)
        _ = sv.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: nil, traling: nil ,padding:.init(top: 0, left: 0, bottom: 0, right: 0),boyut: .init(width: 310, height: 85))
        sv.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
extension KullaniciDetaylariController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yfark = scrollView.contentOffset.y
        var width = view.frame.width - 2*yfark
        width = max(view.frame.width, width)
        let fotoFrame = fotoGecisController.view!
        fotoFrame.frame = CGRect(x: min(0, yfark), y: min(0,yfark), width: width , height: width + ekYukseklik)
    }
}
