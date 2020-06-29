//
//  OturumController.swift
//  TinderClone
//
//  Created by lil ero on 29.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

import JGProgressHUD
class OturumController: UIViewController {
    
    var delegate : OturumControllerDelegate?
    
    fileprivate let oturumVM = OturumViewModel()
    fileprivate let oturumHD = JGProgressHUD(style: .light)
    
    
    let txtEmailAdressi : OzelTextField = {
        let txt = OzelTextField(padding: 24, yukseklik: 55)
        txt.backgroundColor = .white
        txt.keyboardType = .emailAddress
        txt.placeholder = "Email Adresinizi giriniz..."
        txt.addTarget(self, action: #selector(textDegisiklikKontrol), for: .editingChanged)
        return txt
    }()
    let txtParola : OzelTextField = {
        let txt = OzelTextField(padding: 24, yukseklik: 55)
        txt.backgroundColor = .white
        txt.placeholder = "Parola"
        txt.isSecureTextEntry = true
        txt.addTarget(self, action: #selector(textDegisiklikKontrol), for: .editingChanged)
        return txt
    }()
    let btnOturumAc : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Oturum Aç", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 23
        btn.backgroundColor = .lightGray
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.isEnabled = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        btn.addTarget(self, action: #selector(btnOturumAcPressed), for: .touchUpInside)
        return btn
    }()
    fileprivate let btnGerigit : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Kayıt Sayfasına git", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.addTarget(self, action: #selector(btnGerigitPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var  dikeyStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            txtEmailAdressi,
            txtParola,
            btnOturumAc
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindableolustur()
        arkaplanGradientAyarla()
        layoutDuzenle()
    }
    @objc fileprivate func btnGerigitPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func btnOturumAcPressed(){
        oturumVM.oturumAc { (hata) in
            if let hata = hata{
                self.oturumHD.dismiss()
                print("...Oturum açılırken hata meydana geldi \(hata.localizedDescription)")
                return
            }
            print("..Basarıyla Oturum Acıldı")
            self.dismiss(animated: true, completion: nil)
            self.delegate?.OturumAcmaBitis()
            
        }
    }
    @objc fileprivate func textDegisiklikKontrol(textField: UITextField){
        if textField == txtEmailAdressi{
            oturumVM.emailAdresi = textField.text
        }else{
            oturumVM.parola = textField.text
        }
        
    }
    fileprivate func bindableolustur(){
        oturumVM.formGecerli.degerAta { (formGecerlimi) in
            guard let formGecerlimi = formGecerlimi else {return}
            self.btnOturumAc.isEnabled = formGecerlimi
            
            if formGecerlimi{
                self.btnOturumAc.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
                self.btnOturumAc.setTitleColor(.white, for: .normal)
            }else{
                self.btnOturumAc.backgroundColor = .lightGray
                self.btnOturumAc.setTitleColor(.darkGray, for: .disabled)
            }
            
        }
        oturumVM.oturumAciliyor.degerAta { (oturumAcılıyot) in
            if oturumAcılıyot == true{
                self.oturumHD.textLabel.text = "Oturum Acılıyor"
                self.oturumHD.show(in: self.view)
            }else{
                self.oturumHD.dismiss()
            }
        }
    }
    
    
    let gradientLAyer = CAGradientLayer()
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLAyer.frame = view.bounds
    }
    private func arkaplanGradientAyarla(){
        let ustRenk = #colorLiteral(red: 0.6392156863, green: 0.8, blue: 0.9568627451, alpha: 1)
        let altRenk = #colorLiteral(red: 0.1215686275, green: 0.1490196078, blue: 0.737254902, alpha: 1)
        gradientLAyer.colors = [ustRenk.cgColor , altRenk.cgColor]
        gradientLAyer.locations = [0.1]
        view.layer.addSublayer(gradientLAyer)
    }
    
    fileprivate func layoutDuzenle(){
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(dikeyStackView)
        _ = dikeyStackView.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, traling: view.trailingAnchor,padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        dikeyStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(btnGerigit)
        _ = btnGerigit.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, traling: view.trailingAnchor)
        
    }
}
protocol OturumControllerDelegate {
    func OturumAcmaBitis()
}
