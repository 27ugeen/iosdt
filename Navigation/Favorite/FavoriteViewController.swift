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
    let favoriteSearchHeaderID = String(describing: FavoriteSearchHeaderView.self)
    let tableView = UITableView(frame: .zero, style: .plain)
    
    lazy var searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searcAction))
    
    lazy var resetBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearFilter))
    
    init(favoriteViewModel: FavoriteViewModel) {
        self.favoriteViewModel = favoriteViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setRightBarButtonItems([searchBarButton, resetBarButton], animated: true)
        
        setupTableView()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let author = UserDefaults.standard.string(forKey: "author")
        
        if let unwrappedAuthor = author {
            guard unwrappedAuthor == "" else {
                self.getFilteredPosts(filteredAuthor: unwrappedAuthor)
                return
            }
            favoriteViewModel.getAllFavoritePosts()
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if favoriteViewModel.favoritePosts.isEmpty {
            self.showAlert(message: "Posts not found!")
        }
    }
    
    func getFilteredPosts(filteredAuthor: String) {
        UserDefaults.standard.set(filteredAuthor, forKey: "author")
        favoriteViewModel.getFilteredPosts(postAuthor: filteredAuthor)
        tableView.reloadData()
    }
    
    @objc func searcAction() {
        let searhcVC = FavoriteSearchViewController()
        searhcVC.filterAction = self.getFilteredPosts
        self.present(searhcVC, animated: true)
    }
    
    @objc func clearFilter() {
        UserDefaults.standard.set("", forKey: "author")
        favoriteViewModel.getAllFavoritePosts()
        tableView.reloadData()
    }
}
// MARK: - setup table view
extension FavoriteViewController {
    func setupTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoritePostTableViewCell.self, forCellReuseIdentifier: favoritePostCellID)
        tableView.register(FavoriteSearchHeaderView.self, forHeaderFooterViewReuseIdentifier: favoriteSearchHeaderID)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}
// MARK: - setup views
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
// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteViewModel.favoritePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: favoritePostCellID, for: indexPath) as! FavoritePostTableViewCell
        cell.postAuthorLabel.text = "Author: \(favoriteViewModel.favoritePosts[indexPath.row].author)"
        cell.postTitleLabel.text = favoriteViewModel.favoritePosts[indexPath.row].title
        cell.postImageView.image = favoriteViewModel.favoritePosts[indexPath.row].image
        cell.postDescriptionLabel.text = favoriteViewModel.favoritePosts[indexPath.row].description
        cell.postlikesLabel.text = "Likes: \(favoriteViewModel.favoritePosts[indexPath.row].likes)"
        cell.postViewsLabel.text = "Views: \(favoriteViewModel.favoritePosts[indexPath.row].views)"
        return cell
        
    }
}
// MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: favoriteSearchHeaderID) as! FavoriteSearchHeaderView
        let author = UserDefaults.standard.string(forKey: "author")
        if author != "" {
            if let unwrappedAuthor = author {
                headerView.searchLabel.text = "Filtered posts by \"\(unwrappedAuthor)\""
            }
        } else {
            headerView.searchLabel.text = "Not filtered by author"
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
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
