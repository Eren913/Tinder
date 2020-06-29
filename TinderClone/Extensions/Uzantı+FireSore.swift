//
//  Uzantı+FireSore.swift
//  TinderClone
//
//  Created by lil ero on 29.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import Foundation
import Firebase

extension Firestore{
    func gecerliKullaniciyiGetir(completion: @escaping (Kullanici?, Error?) -> ()){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("Kullanicilar").document(uid).getDocument { (snapshot, error) in
            if let error = error{
                completion(nil,error)
                return
            }
            
            
            
            guard let bilgiler = snapshot?.data() else {
                let hata = NSError(domain: "com.erencelik.TinderClone", code: 450, userInfo: [NSLocalizedDescriptionKey : "Kullanıcı bulunamadı"])
                completion(nil,hata)
                return
            }
            let kullanici = Kullanici(bilgiler: bilgiler)
            completion(kullanici,nil)
        }
    }
}
