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
        }
    }
    
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataSource = self

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
        view.addSubview(imageView)
        imageView.doldurSuperView()
    }
}
