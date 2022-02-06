//
//  FeedViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import UIKit

class FeedViewController: UIViewController {
    
    let viewModel: ViewOutput
    
    lazy var buttonTop = MagicButton(title: "Top Button", titleColor: .white) {
        self.goToPosts()
    }
    
    lazy var buttonBot = MagicButton(title: "Bot Button", titleColor: .white) {
        self.goToPosts()
    }
    
    let checkTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        text.backgroundColor = .white
        text.layer.cornerRadius = 12
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.black.cgColor
        text.placeholder = "Write something..."
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        return text
    }()
    
    let checkedLAbel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.numberOfLines = 0
        return title
    }()
    
    lazy var checkButton = MagicButton(title: "Check", titleColor: .white) { [weak self] in
        print("check tapped")
        
        if self?.checkTextField.text == "" {
            self?.checkedLAbel.textColor = UIColor.white
            self?.checkedLAbel.text = "WRITE SOMETHING!"
            return
        }
        
        let ifCheckedWord = self?.viewModel.check(word: self?.checkTextField.text ?? "")

        if ifCheckedWord! {
            self?.checkedLAbel.textColor = UIColor.systemGreen
            self?.checkedLAbel.text = "TRUE"
        } else {
            self?.checkedLAbel.textColor = UIColor.systemRed
            self?.checkedLAbel.text = "FALSE"
        }
        self?.checkTextField.text = ""
    }
    
    func goToPosts() {
        let vc = PostViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    init(viewModel: ViewOutput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        setupViews()
        
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
        checkButton.setTitle("Ckeck is pressed", for: .highlighted)
        checkButton.setTitleColor(.purple, for: .highlighted)
    }
}

extension FeedViewController {
    func setupViews() {
        
        let stackView = UIStackView(arrangedSubviews: [
            self.buttonTop,
            self.buttonBot,
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        
        self.view.addSubview(stackView)
        self.view.addSubview(checkTextField)
        self.view.addSubview(checkButton)
        self.view.addSubview(checkedLAbel)
        
        let constraints = [
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            checkTextField.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            checkTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkTextField.heightAnchor.constraint(equalToConstant: 40),
            
            checkButton.topAnchor.constraint(equalTo: checkTextField.bottomAnchor, constant: 10),
            checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            checkedLAbel.topAnchor.constraint(equalTo: checkButton.bottomAnchor, constant: 10),
            checkedLAbel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
