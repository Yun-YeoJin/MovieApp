//
//  BaseViewController.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/27.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .white
        } else {
            view.backgroundColor = .white
        }
        
    }
    
    func configureUI() { }
    
    func setConstraints() { }
    
}
