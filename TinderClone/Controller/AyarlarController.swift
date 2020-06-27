//
//  AyarlarController.swift
//  TinderClone
//
//  Created by lil ero on 27.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class AyarlarController: UITableViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func butonOlustur(selector : Selector) -> UIButton{
        let buton = UIButton(type: .system)
        buton.layer.cornerRadius = 10
        buton.clipsToBounds = true
        buton.backgroundColor = .white
        buton.setTitle("Fotoraf Seç", for: .normal)
        
        buton.addTarget(self, action: selector, for: .touchUpInside)
        return buton
    }
    lazy var btnGoruntuSec1 = butonOlustur(selector: #selector(btngoruntusecPressed))
    lazy var btnGoruntuSec2 = butonOlustur(selector: #selector(btngoruntusecPressed))
    lazy var btnGoruntuSec3 = butonOlustur(selector: #selector(btngoruntusecPressed))
    
    
    @objc fileprivate func btngoruntusecPressed(buton : UIButton){
        let imagePicker = CustomImagePickerController()
        imagePicker.btnGoruntuSec = buton
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let secilenGoruntu = info[.originalImage] as? UIImage
        let btnGoruntuSec = (picker as? CustomImagePickerController)?.btnGoruntuSec
        btnGoruntuSec?.imageView?.contentMode = .scaleAspectFill
        btnGoruntuSec?.setImage(secilenGoruntu?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationOlustur()
        tableView.backgroundColor = UIColor(white: 0.92, alpha: 1)
        tableView.tableFooterView = UIView()
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let fotoAlan = UIView()
        fotoAlan.addSubview(btnGoruntuSec1)
        _ = btnGoruntuSec1.anchor(top: fotoAlan.topAnchor,
                                  bottom: fotoAlan.bottomAnchor,
                                  leading: fotoAlan.leadingAnchor,
                                  traling: fotoAlan.trailingAnchor,
                                  padding: .init(top: 15, left: 15, bottom: 15, right: 0))
        
        btnGoruntuSec1.widthAnchor.constraint(equalTo: fotoAlan.widthAnchor, multiplier: 0.42).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [btnGoruntuSec2,btnGoruntuSec3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        fotoAlan.addSubview(stackView)
        _ = stackView.anchor(top: fotoAlan.topAnchor,
                             bottom: fotoAlan.bottomAnchor,
                             leading: btnGoruntuSec1.trailingAnchor,
                             traling: fotoAlan.trailingAnchor,
                             padding: .init(top: 15, left: 15, bottom: 15, right: 15))
        return fotoAlan
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 320
    }
    fileprivate func navigationOlustur() {
        navigationItem.title = "Ayarlar"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "İptal", style: .plain, target: self, action: #selector(btnIptalPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Oturumu Kapat", style: .plain, target: self, action: #selector(btnOturumuKapat))
    }
    @objc fileprivate func btnIptalPressed(){
        dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func btnOturumuKapat(){
        
    }
}

class CustomImagePickerController : UIImagePickerController {
    var btnGoruntuSec : UIButton?
}
