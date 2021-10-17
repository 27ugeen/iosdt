//
//  FeedViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import UIKit

class FeedViewController: UIViewController {
    
    let buttonTop: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Top Button", for: .normal)
        button.setTitle("Top pressed", for: .highlighted)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.purple, for: .highlighted)
        button.addTarget(self, action: #selector(buttonTupped), for: .touchUpInside)
        return button
    }()
    
    let buttonBot: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Bot Button", for: .normal)
        button.setTitle("Bot pressed", for: .highlighted)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.purple, for: .highlighted)
        button.addTarget(self, action: #selector(buttonTupped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStackView()
        
        self.title = "Feed"
        self.view.backgroundColor = .systemOrange
    }
    
    @objc func buttonTupped() {
        let vc = PostViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FeedViewController {
    func setupStackView() {
        
        let stackView = UIStackView(arrangedSubviews: [
            self.buttonTop,
            self.buttonBot
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        
        self.view.addSubview(stackView)
        
        let constraints = [
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
