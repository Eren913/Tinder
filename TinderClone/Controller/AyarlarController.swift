//
//  AyarlarController.swift
//  TinderClone
//
//  Created by lil ero on 27.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

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
        //ayarlar kısmında yüklenen veriyi firestore üzerine kayıt ediyoryz
        let goruntuAdi = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/Goruntuler/\(goruntuAdi)")
        guard let veri = secilenGoruntu?.jpegData(compressionQuality: 0.8) else {return}
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Görüntü Yükleniyor..."
        hud.show(in: view)
        ref.putData(veri, metadata: nil) { (nil, hata) in
            if let hata = hata{
                print("...Goruntu yüklenirken hata meydana geldi\(hata.localizedDescription)")
                hud.dismiss()
                return
            }
            ref.downloadURL { (url, hata) in
                hud.dismiss()
                if let hata = hata{
                    print("...Goruntu Url Alınamadı \(hata.localizedDescription)")
                }
                if btnGoruntuSec == self.btnGoruntuSec1{
                    self.gecerliKullanici?.goruntuURL1 = url?.absoluteString
                }else if btnGoruntuSec == self.btnGoruntuSec2{
                    self.gecerliKullanici?.goruntuURL2 = url?.absoluteString
                }else if btnGoruntuSec == self.btnGoruntuSec3{
                    self.gecerliKullanici?.goruntuURL3 = url?.absoluteString
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationOlustur()
        tableView.backgroundColor = UIColor(white: 0.92, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        kullaniciBilgileriniGetir()
    }
    var gecerliKullanici : Kullanici?
    fileprivate func kullaniciBilgileriniGetir(){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        Firestore.firestore().collection("Kullanicilar").document(uid).getDocument { (snapshot, error) in
            if let error = error{
                print(".Kullanici bilgileri Getiriliken hata meydana geldi  hatası \(error.localizedDescription)")
            }
            guard let bilgiler = snapshot?.data() else {return}
            self.gecerliKullanici = Kullanici(bilgiler: bilgiler)
            self.profilGoruntuleriniYukle()
            self.tableView.reloadData()
        }
        
    }
    fileprivate func profilGoruntuleriniYukle(){
        if let goruntuURL = gecerliKullanici?.goruntuURL1,let url = URL(string: goruntuURL) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (goruntu, _, _, _, _, _) in
                self.btnGoruntuSec1.setImage(goruntu?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let goruntuURL = gecerliKullanici?.goruntuURL2,let url = URL(string: goruntuURL) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (goruntu, _, _, _, _, _) in
                self.btnGoruntuSec2.setImage(goruntu?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let goruntuURL = gecerliKullanici?.goruntuURL3,let url = URL(string: goruntuURL) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (goruntu, _, _, _, _, _) in
                self.btnGoruntuSec3.setImage(goruntu?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    
    lazy var fotoAlan : UIView = {
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
    }()
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return fotoAlan
        }
        let lblBaslık = LabelBaslık()
        
        switch section {
        case  1:
            lblBaslık.text = "Adınızı girin "
        case 2 :
            lblBaslık.text = "Yas"
        case 3 :
            lblBaslık.text = "Meslek"
        case 4 :
            lblBaslık.text = "Hakkında"
        case 5:
            lblBaslık.text = "Yaş Aralığı"
        default:
            lblBaslık.text = "*****Hata****** "
        }
        lblBaslık.font = UIFont.boldSystemFont(ofSize: 14)
        
        return lblBaslık
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 320
        }
        return 40
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5 {
            let yasAralikCell = YasAralikCell(style: .default, reuseIdentifier: nil)
            yasAralikCell.minSlider.addTarget(self, action: #selector(minYasSliderChancged), for: .valueChanged)
            yasAralikCell.maxSlider.addTarget(self, action: #selector(maxYasSliderChancged(slider:)), for: .valueChanged)
            yasAralikCell.lblMin.text = "Min \(gecerliKullanici?.ArananMinYas ?? 18)"
            yasAralikCell.lblMax.text = "Max \(gecerliKullanici?.ArananMaxYas ?? 90)"
            yasAralikCell.minSlider.value = Float(gecerliKullanici?.ArananMinYas ?? 18)
            yasAralikCell.maxSlider.value = Float(gecerliKullanici?.ArananMaxYas ?? 90)
            return yasAralikCell
        }
        
        let cell = AyarlarCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Adınızı girin"
            cell.textField.text = gecerliKullanici?.kullaniciAdi
            cell.textField.addTarget(self, action: #selector(kullaniciAdiDegisiklikyakala), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Yaşınız"
            cell.textField.keyboardType = .numberPad
            if let yasi = gecerliKullanici?.yasi{
                cell.textField.text = String(yasi)
            }
            cell.textField.addTarget(self, action: #selector(yasiDegisiklikyakala), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Mesleğiniz"
            cell.textField.text = gecerliKullanici?.meslek
            cell.textField.addTarget(self, action: #selector(meslekDegisiklikyakala), for: .editingChanged)
        case 4:
            cell.textField.placeholder = "Kendinizden bahsedin"
        default:
            cell.textField.placeholder = "**Hata**"
        }
        return cell
    }
    @objc fileprivate func kullaniciAdiDegisiklikyakala(textField: UITextField){
        self.gecerliKullanici?.kullaniciAdi = textField.text
    }
    @objc fileprivate func yasiDegisiklikyakala(textField: UITextField){
        self.gecerliKullanici?.yasi = Int(textField.text ?? "")
    }
    @objc fileprivate func meslekDegisiklikyakala(textField: UITextField){
        self.gecerliKullanici?.meslek = textField.text
    }
    @objc fileprivate func minYasSliderChancged(slider: UISlider){
        minMaxAyarla()
    }
    @objc fileprivate func maxYasSliderChancged(slider: UISlider){
        minMaxAyarla()
    }
    fileprivate func minMaxAyarla(){
        //5. section 0.row
        guard let yasAralıkCell = tableView.cellForRow(at: [5,0]) as? YasAralikCell else{return}
        let minDeger = Int(yasAralıkCell.minSlider.value)
        var maxDeger = Int(yasAralıkCell.maxSlider.value)
        
        maxDeger = max(minDeger,maxDeger)
        yasAralıkCell.maxSlider.value = Float(maxDeger)
        
        yasAralıkCell.lblMin.text = "Min \(minDeger)"
        yasAralıkCell.lblMax.text = "Max \(maxDeger)"
        
        gecerliKullanici?.ArananMinYas = minDeger
        gecerliKullanici?.ArananMaxYas = maxDeger
        
    }
    fileprivate func navigationOlustur() {
        navigationItem.title = "Ayarlar"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "İptal", style: .plain, target: self, action: #selector(btnIptalPressed))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Kaydet", style: .plain, target: self, action: #selector(btnKaydetPressed)),
            UIBarButtonItem(title: "Çıkış", style: .plain, target: self, action: #selector(btnCikisPressed))
        ]
    }
    @objc fileprivate func btnKaydetPressed(){
        print("...Veriler Kaydediliyor")
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let veriler : [String :  Any] = [
            "KullaniciID" : uid,
            "Adi_Soyadi" : gecerliKullanici?.kullaniciAdi ?? "",
            "Goruntu_URL" : gecerliKullanici?.goruntuURL1 ?? "",
            "Goruntu_URL2" : gecerliKullanici?.goruntuURL2 ?? "",
            "Goruntu_URL3" : gecerliKullanici?.goruntuURL3 ?? "",
            "Meslek" : gecerliKullanici?.meslek ?? "",
            "Yasi" : gecerliKullanici?.yasi ?? -1,
            "ArananMinYas" : gecerliKullanici?.ArananMinYas ?? -1,
            "ArananMaxYas" : gecerliKullanici?.ArananMaxYas ?? -1
        ]
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Bilgilereniz Kaydediliyor"
        hud.show(in: view)
        Firestore.firestore().collection("Kullanicilar").document(uid).setData(veriler) { (error) in
            if let hata = error{
                print("...Kullanıcı Bilgilerini kayıt Ederken hata meydana geldi \(hata.localizedDescription)")
            }
            hud.dismiss()
            print("...Kullanıcı verileri kaydedildi")
        }
    }
    
    @objc fileprivate func btnCikisPressed(){
        print(".Oturum kapatılacak")
        
    }
    @objc fileprivate func btnIptalPressed(){
        dismiss(animated: true, completion: nil)
    }
}

class CustomImagePickerController : UIImagePickerController {
    var btnGoruntuSec : UIButton?
}

class LabelBaslık : UILabel{
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 15, dy: 0))
    }
    
}
