//
//  FavoriteSearchViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 4/4/2022.
//

import UIKit

class FavoriteSearchViewController: UIViewController {
    
    var filterAction: ((_ author: String) -> Void)?
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let contentView: UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    let searchTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .systemGray6
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.borderWidth = 0.5
        text.layer.cornerRadius = 10
        text.textColor = .black
        text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        text.tintColor = UIColor(named: "myAccentColor")
        text.autocapitalizationType = .none
        text.placeholder = " Search by author"
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        return text
    }()
    
    lazy var cancelButton = MagicButton(title: "Cancel", titleColor: .systemGray) {
        self.dismiss(animated: true)
    }
    
    lazy var searchButton = MagicButton(title: "Search", titleColor: .systemGray) {
        self.filterAction?(self.searchTextField.text ?? "")
        self.dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - setup buttons
extension FavoriteSearchViewController {
    func setupButtons() {
        
        cancelButton.setTitleColor(.systemRed, for: .highlighted)
        
        searchButton.setTitleColor(.systemBlue, for: .highlighted)
        searchButton.layer.cornerRadius = 10
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.systemGray.cgColor
        searchButton.clipsToBounds = true
        searchButton.addTarget(self, action: #selector(startHighlight), for: .touchDown)
        searchButton.addTarget(self, action: #selector(stopHighLight), for: .touchUpInside)
    }
    
    @objc func startHighlight() {
        searchButton.layer.borderColor = UIColor.systemBlue.cgColor
    }
    @objc func stopHighLight() {
        searchButton.layer.borderColor = UIColor.systemGray.cgColor
    }
}

// MARK: - setup views
extension FavoriteSearchViewController {
    func setupViews() {
        self.view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(searchTextField)
        contentView.addSubview(cancelButton)
        contentView.addSubview(searchButton)
        
        let constraints = [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            searchTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            searchTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 42),
            searchTextField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -10),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 42),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            
            searchButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            searchButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - setup keyboard
private extension FavoriteSearchViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}
