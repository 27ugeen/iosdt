//
//  FavoriteViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 30/3/2022.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController {
    
    let favoriteViewModel: FavoriteViewModel
    
    let favoritePostCellID = String(describing: FavoritePostTableViewCell.self)
    let favoriteSearchHeaderID = String(describing: FavoriteSearchHeaderView.self)
    let tableView = UITableView(frame: .zero, style: .plain)
    
    lazy var fetchResultsController: NSFetchedResultsController<FavoritePost> = {
        let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataBaseManager.shared.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    
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
        
        DataBaseManager.shared.persistentContainer.viewContext.perform {
            do {
                try self.fetchResultsController.performFetch()
                self.tableView.reloadData()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
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
        return fetchResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favoritePostCellID, for: indexPath) as! FavoritePostTableViewCell
        
        let post = fetchResultsController.object(at: indexPath)
        cell.postAuthorLabel.text = "Author: \(post.author ?? "")"
        cell.postTitleLabel.text = post.title
        cell.postImageView.image = DataBaseManager.shared.getImageFromDocuments(imageUrl: URL(string: post.stringImage ?? "") ?? URL(fileURLWithPath: ""))
        cell.postDescriptionLabel.text = post.postDescription
        cell.postlikesLabel.text = "Likes: \(post.likes)"
        cell.postViewsLabel.text = "Views: \(post.views)"
        
        return cell
    }
}
// MARK: - NSFetchedResultsControllerDelegate
extension FavoriteViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { fallthrough }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let newIndexPath = newIndexPath else { fallthrough }
            
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { fallthrough }
            
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { fallthrough }
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
        let post = fetchResultsController.object(at: indexPath)
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            self.favoriteViewModel.removePostFromFavorite(post: post)
            complete(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
