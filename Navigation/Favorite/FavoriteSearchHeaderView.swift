//
//  FavoriteSearchTableViewCell.swift
//  Navigation
//
//  Created by GiN Eugene on 4/4/2022.
//

import UIKit

class FavoriteSearchHeaderView: UITableViewHeaderFooterView {

    let searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
}
// MARK: - setup views
extension FavoriteSearchHeaderView {
    private func setupViews() {
        contentView.addSubview(searchLabel)
        
        let constraints = [
            searchLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            searchLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            searchLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            searchLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
