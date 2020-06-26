//
//  KayıtController.swift
//  TinderClone
//
//  Created by lil ero on 26.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class KayitController: UIViewController {

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        arkaplanGradientAyarla()
        
        let kayitStackView = UIStackView(arrangedSubviews: [
        btnFotorafsec,
        txtEmailAdrsi,
        txtAdiSyoadi,
        txtParola,
        btnKayitol
        ])
        view.addSubview(kayitStackView)
        
        kayitStackView.axis = .vertical
        kayitStackView.spacing = 10
        _ = kayitStackView.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, traling: view.trailingAnchor,padding: .init(top: 0, left: 45, bottom: 0, right: 45))
        kayitStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
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
