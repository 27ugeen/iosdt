//
//  FavoriteViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 30/3/2022.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    let favoriteViewModel: FavoriteViewModel
    
    let favoritePostCellID = String(describing: FavoritePostTableViewCell.self)
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    init(favoriteViewModel: FavoriteViewModel) {
        self.favoriteViewModel = favoriteViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoriteViewModel.getAllFavoritePosts()
        tableView.reloadData()
    }
}

extension FavoriteViewController {
    func setupTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoritePostTableViewCell.self, forCellReuseIdentifier: favoritePostCellID)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension FavoriteViewController {
    func setupViews() {
        
        self.title = "Favorite"
        self.view.backgroundColor = .white
        
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension FavoriteViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteViewModel.favoritePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favoritePostCellID, for: indexPath) as! FavoritePostTableViewCell
        
        cell.postTitleLabel.text = favoriteViewModel.favoritePosts[indexPath.row].title
        cell.postImageView.image = favoriteViewModel.favoritePosts[indexPath.row].image
        cell.postDescriptionLabel.text = favoriteViewModel.favoritePosts[indexPath.row].description
        cell.postlikesLabel.text = "Likes: \(favoriteViewModel.favoritePosts[indexPath.row].likes)"
        cell.postViewsLabel.text = "Views: \(favoriteViewModel.favoritePosts[indexPath.row].views)"
        
        return cell
    }
}

extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let post = favoriteViewModel.favoritePosts[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            self.favoriteViewModel.removePostFromFavorite(post: post, index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
