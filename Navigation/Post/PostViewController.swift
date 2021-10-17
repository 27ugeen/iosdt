//
//  PostViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import UIKit

class PostViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGreen
        self.title = "Black Cat"
        
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: UIBarButtonItem.Style.done, target: self, action: #selector(postTapped))
        
        self.navigationItem.setRightBarButtonItems([button], animated: true)
    }
    
    @objc func postTapped() {
        let vc = InfoViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
}
