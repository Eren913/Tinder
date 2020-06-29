//
//  OturumViewModel.swift
//  TinderClone
//
//  Created by lil ero on 29.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import Foundation
import Firebase

class OturumViewModel{
    var oturumAciliyor = Bindable<Bool>()
    var formGecerli = Bindable<Bool>()
    
    var emailAdresi : String?{
        didSet{
            formGecerliKontrol()
        }
    }
    var parola : String?{
        didSet{
            formGecerliKontrol()
        }
    }
    fileprivate func formGecerliKontrol(){
        let gecerli = emailAdresi?.isEmpty == false && parola?.isEmpty == false
        formGecerli.deger = gecerli
    }
    func oturumAc(completion: @escaping (Error?) -> ()){
        guard let emailAdresi = emailAdresi,let parola = parola else{return}
        
        oturumAciliyor.deger = true
        Auth.auth().signIn(withEmail: emailAdresi, password: parola) { (_, error) in
            completion(error)
        }
    }
    
}
