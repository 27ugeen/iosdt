//
//  InfoViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import UIKit

class InfoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemPurple
        
        let button = UIButton(frame: CGRect(x: 100, y: 300, width: 200, height: 50))
        button.setTitle("dont touch me!!!", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func buttonPressed() {
        
        let alertVC = UIAlertController(title: "Error", message: "Something wrong!", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel) { _ in
            print("Destroyed!")
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { _ in
            print("Survived!")
        }
        alertVC.addAction(actionOk)
        alertVC.addAction(actionCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
}
