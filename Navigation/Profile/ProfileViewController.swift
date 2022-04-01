//
//  ProfileViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let profileViewModel: ProfileViewModel
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    let cellID = String(describing: PostTableViewCell.self)
    let photoCellID = String(describing: PhotosTableViewCell.self)
    let headerID = String(describing: ProfileHeaderView.self)
    
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapEdit(_:)))
        tapGesture.numberOfTapsRequired = 2
        tableView.addGestureRecognizer(tapGesture)
        
        setupTableView()
        setupConstraints()
    }
    
    func logOut() {
        UserDefaults.standard.set(false, forKey: "isSignedUp")
        
        let viewController = LogInViewController(loginViewModel: LoginViewModel().self)
        let navCtrl = UINavigationController(rootViewController: viewController)

        guard
            let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first,
            let rootViewController = window.rootViewController

        else {
            return
        }

        navCtrl.view.frame = rootViewController.view.frame
        navCtrl.isNavigationBarHidden = true
        navCtrl.view.layoutIfNeeded()

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = navCtrl
        })
        
        print("User is signed out!")
    }
    
    @objc func tapEdit(_ recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.tableView.cellForRow(at: tapIndexPath) as? PostTableViewCell {
                    if tapIndexPath.row == 0 {
                        return
                    } else {
                        tappedCell.post = PostsStorage.tableModel[tapIndexPath.section].posts[tapIndexPath.row - 1]
                        profileViewModel.addToFavoritePosts(tappedCell.post!) { message in
                            self.showAlert(message: message ?? "")
                        }
                    }
                }
            }
        }
    }
}

extension ProfileViewController {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: photoCellID)
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: headerID)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ProfileViewController {
    func setupConstraints() {
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PostsStorage.tableModel.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostsStorage.tableModel[section].posts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: PhotosTableViewCell = tableView.dequeueReusableCell(withIdentifier: photoCellID, for: indexPath) as! PhotosTableViewCell
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PostTableViewCell
            cell.post = PostsStorage.tableModel[indexPath.section].posts[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return PostsStorage.tableModel[section].title
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let photosVC = PhotosViewController()
            navigationController?.pushViewController(photosVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ProfileHeaderView()
        headerView.logOutAction = self.logOut
        return headerView
    }
}
