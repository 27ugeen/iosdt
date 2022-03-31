//
//  LogInViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 31.07.2021.
//

import UIKit

class LogInViewController: UIViewController, LoginViewInputProtocol {
    
    let loginViewModel: LoginViewModel
    
    var authError: String = ""
    var currentStrategy: AuthorizationStrategy = .logIn
    var isSignedUp: Bool = UserDefaults.standard.bool(forKey: "isSignedUp")
    var isUserExists: Bool = true {
        willSet {
            if newValue {
                loginButton.setTitle("Log in", for: .normal)
                switchLoginButton.setTitle("You don't have an account yet? Create", for: .normal)
            } else {
                loginButton.setTitle("Create new account", for: .normal)
                switchLoginButton.setTitle("Do you already have an account? Sign In", for: .normal)
            }
        }
    }
    
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
    
    let logoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "trident")
        image.backgroundColor = .white
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    let loginTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .systemGray6
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.borderWidth = 0.5
        text.layer.cornerRadius = 10
        text.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        text.textColor = .black
        text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        text.tintColor = UIColor(named: "myAccentColor")
        text.autocapitalizationType = .none
        text.placeholder = " Email or phone"
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        return text
    }()
    
    let passwordTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .systemGray6
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.borderWidth = 0.5
        text.layer.cornerRadius = 10
        text.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        text.textColor = .black
        text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        text.tintColor = UIColor(named: "myAccentColor")
        text.autocapitalizationType = .none
        text.placeholder = " Password"
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.isSecureTextEntry = true
        return text
    }()
    
    lazy var loginButton = MagicButton(title: "Log in", titleColor: .white) {
        self.goToProfile()
    }
    
    lazy var switchLoginButton = MagicButton(title: "You don't have an account yet? Create", titleColor: .systemBlue) {
        self.isUserExists = !self.isUserExists
    }
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUserSignUp()
        setupLoginButton()
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
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func createTabBarController() -> UITabBarController {
        let tabBC = UITabBarController()
        
        let feedVC = FeedViewController(viewModel: FeedViewModel().self)
        let feedNavVC = UINavigationController(rootViewController: feedVC)
        feedNavVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let profileVC = ProfileViewController()
        let profileNavVC = UINavigationController(rootViewController: profileVC)
        profileNavVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
        profileNavVC.isNavigationBarHidden = true
        
        let favoriteVC = FavoriteViewController()
        let favoriteNavVC = UINavigationController(rootViewController: favoriteVC)
        favoriteNavVC.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "star.square.fill"), tag: 2)
        
        tabBC.viewControllers = [profileNavVC, feedNavVC, favoriteNavVC]
               
        return tabBC
    }
    
    func backToRootView() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func checkUserSignUp() {
        if isSignedUp {
            let userId = UserDefaults.standard.string(forKey: "userId")
            if let currentId = userId {
            let currentUser = loginViewModel.getCurrentUser(currentId)
                let tabBC = createTabBarController()
                self.navigationController?.pushViewController(tabBC, animated: true)
                print("Current user: \(String(describing: currentUser.email)) is signed in")
            }
        } else {
            print("No user is signed in.")
        }
    }
    
    func goToProfile() {
        if !isUserExists {
            currentStrategy = .newUser
        } else {
            currentStrategy = .logIn
        }
        
        if(!(loginTextField.text ?? "").isEmpty && !(passwordTextField.text ?? "").isEmpty) {
            userTryAuthorize(withStrategy: currentStrategy)
        } else {
            showAlert(message: "Please fill in all fields!")
        }
    }
    
    func userTryAuthorize(withStrategy: AuthorizationStrategy) {
        switch currentStrategy {
        case .logIn:
            loginViewModel.signInUser(userLogin: loginTextField.text ?? "", userPassword: passwordTextField.text ?? "") { error in
                if let unwrappedError = error {
                    self.authError = unwrappedError
                    print("Error: \(unwrappedError)")
                    self.showAlert(message: unwrappedError)
                }
            }
        case .newUser:
            loginViewModel.createUser(userLogin: loginTextField.text ?? "", userPassword: passwordTextField.text ?? "") { error in
                if let unwrappedError = error {
                    self.authError = unwrappedError
                    print("Error: \(unwrappedError)")
                    self.showAlert(message: unwrappedError)
                }
            }
        }
        if authError == "" {
            let tabBC = createTabBarController()
            self.navigationController?.pushViewController(tabBC, animated: true)
            print("Current user: \(String(describing: self.loginTextField.text)) is signed in")
        }
        authError = ""
    }
}

extension LogInViewController {
    func setupLoginButton() {
        let backgroundImage = UIImage(named: "blue_pixel")
        let trasparentImage = backgroundImage!.alpha(0.8)
        
        loginButton.setBackgroundImage(backgroundImage, for: .normal)
        loginButton.setBackgroundImage(trasparentImage, for: .selected)
        loginButton.setBackgroundImage(trasparentImage, for: .highlighted)
        loginButton.setBackgroundImage(trasparentImage, for: .disabled)
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        
        switchLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
}

extension LogInViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(logoImage)
        contentView.addSubview(loginTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(loginButton)
        contentView.addSubview(switchLoginButton)
        
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
            
            logoImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImage.widthAnchor.constraint(equalToConstant: 150),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor),
            
            loginTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginTextField.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 100),
            loginTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            switchLoginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            switchLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 5),
            switchLoginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchLoginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            switchLoginButton.heightAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

private extension LogInViewController {
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}
