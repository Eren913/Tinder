//
//  FotoGecisController.swift
//  TinderClone
//
//  Created by lil ero on 29.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class FotoGecisController: UIPageViewController {
    
    
    var kullaniciViewModel : KullaniciProfilViewModel!{
        didSet{
            controllers = kullaniciViewModel.goruntuAdlari.map({goruntuURL -> UIViewController in
                let fotoController = Fotocontroller(goruntuURL: goruntuURL)
                return fotoController
                
            })
            setViewControllers([controllers.first!], direction: .forward, animated: true, completion: nil)
            barViewEkle()
        }
    }
    
    fileprivate func barViewEkle(){
        kullaniciViewModel.goruntuAdlari.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = seciliolamyanRenk
            barView.layer.cornerRadius = 3
            barStackView.addArrangedSubview(barView)
        }
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        view.addSubview(barStackView)
        _ = barStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, traling: view.trailingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 8),boyut: .init(width: 0, height: 4))
    }
    fileprivate let barStackView = UIStackView(arrangedSubviews: [])
    fileprivate let seciliolamyanRenk = UIColor(white: 0, alpha: 0.2)
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataSource = self
        delegate = self
        
        if kullaniciViewModelMi{
            fotoGecisIptal()
        }
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureFoto)))
    }
    @objc fileprivate func tapGestureFoto(gesture : UITapGestureRecognizer){
        let gorunencontroller = viewControllers!.first!
        
        if let index = controllers.firstIndex(of: gorunencontroller){
            
            barStackView.arrangedSubviews.forEach({$0.backgroundColor = seciliolamyanRenk})
            
            if gesture.location(in: self.view).x > view.frame.width / 2{
                let sonrakiIndex = min(controllers.count - 1,index + 1)
                let sonrakiController = controllers[sonrakiIndex]
                setViewControllers([sonrakiController], direction: .forward, animated: true)
                barStackView.arrangedSubviews[sonrakiIndex].backgroundColor = .white
                
            }else{
                let oncekiIndex = max(0, index - 1)
                let oncekiController = controllers[oncekiIndex]
                barStackView.arrangedSubviews[oncekiIndex].backgroundColor = .white
                setViewControllers([oncekiController], direction: .reverse, animated: true)
            }
        }
    }
    fileprivate func fotoGecisIptal(){
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView{
                v.isScrollEnabled = false
            }
        }
    }
    
    
    fileprivate let kullaniciViewModelMi : Bool
    
    init(kullaniciViewModelmi : Bool = false){
        self.kullaniciViewModelMi = kullaniciViewModelmi
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension FotoGecisController : UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 {return nil}
        return controllers[index - 1]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController}) ?? 0
        print("index değeri : \(index)")
        if index == controllers.count - 1 {return nil}
        return controllers[index + 1]
    }
    
    
}
extension FotoGecisController : UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let gosterilenFotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == gosterilenFotoController}){
            barStackView.arrangedSubviews.forEach({$0.backgroundColor = seciliolamyanRenk})
            barStackView.arrangedSubviews[index].backgroundColor = .white
        }
        
    }
}
class Fotocontroller : UIViewController{
    let imageView = UIImageView(image: #imageLiteral(resourceName: "kisi3"))
    
    init(goruntuURL : String){
        if let url = URL(string: goruntuURL){
            imageView.sd_setImage(with: url, completed: nil)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFill
        //Sınırları kırp nalamına geliyor 
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.doldurSuperView()
    }
}
