//
//  FeedViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import UIKit

class FeedViewController: UIViewController {
    
    lazy var buttonTop = MagicButton(title: "Top Button", titleColor: .white) {
        let vc = PostViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var buttonBot = MagicButton(title: "Bot Button", titleColor: .white) {
        let vc = PostViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        setupStackView()
        
        self.title = "Feed"
        self.view.backgroundColor = .systemOrange
    }
}

extension FeedViewController {
    func setupButtons() {
        buttonTop.setTitle("Top is pressed", for: .highlighted)
        buttonTop.setTitleColor(.purple, for: .highlighted)
        buttonBot.setTitle("Bot is pressed", for: .highlighted)
        buttonBot.setTitleColor(.purple, for: .highlighted)
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
