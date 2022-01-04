//
//  FeedViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import UIKit

class FeedViewController: UIViewController {
    
    let buttonTop = MagicButton(title: "Top Button", titleColor: .white)
    let buttonBot = MagicButton(title: "Bot Button", titleColor: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = PostViewController()
        
        buttonTop.setTitle("Top is pressed", for: .highlighted)
        buttonTop.setTitleColor(.purple, for: .highlighted)
        buttonBot.setTitle("Bot is pressed", for: .highlighted)
        buttonBot.setTitleColor(.purple, for: .highlighted)
        
        buttonTop.onTap = {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        buttonBot.onTap = {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        setupStackView()
        
        self.title = "Feed"
        self.view.backgroundColor = .systemOrange
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
