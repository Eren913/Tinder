//
//  KullaniciDetaylariController.swift
//  TinderClone
//
//  Created by lil ero on 29.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class KullaniciDetaylariController: UIViewController {
    
    
    lazy var scroolView : UIScrollView = {
        let sv = UIScrollView()
        
        sv.alwaysBounceVertical = true
        //olduğu yerde tut herhangi bir padding değeri atama
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    let imgProfil : UIImageView = {
        let img = UIImageView(image:#imageLiteral(resourceName: "kisi1-2") )
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    let lblbilgi : UILabel = {
        let lbl = UILabel()
        lbl.text = "Sibel kara 50\nÖğretmen\nÖğrencilerimi severim "
        lbl.numberOfLines = 0
        return lbl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureKapat)))
        
        
        scroolView.addSubview(imgProfil)
        imgProfil.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        view.addSubview(scroolView)
        scroolView.doldurSuperView()
        
        scroolView.addSubview(lblbilgi)
        _ = lblbilgi.anchor(top: imgProfil.bottomAnchor, bottom: nil, leading: scroolView.leadingAnchor, traling: scroolView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
    }
    @objc fileprivate func tapGestureKapat(){
        self.dismiss(animated: true, completion: nil)
    }
}
extension KullaniciDetaylariController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yfark = scrollView.contentOffset.y
        print("y Fark : \(yfark)")
        var width = view.frame.width - 2*yfark
        width = max(view.frame.width, width)
        imgProfil.frame = CGRect(x: min(0, yfark), y: min(0,yfark), width: width , height: width)
    }
}
