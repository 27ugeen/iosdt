//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by GiN Eugene on 04.08.2021.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    var post: Post? {
        didSet {
            postTitleLabel.text = post?.title
            postImageView.image = post?.image
            postDescriptionLabel.text = post?.description
            postlikesLabel.text = "Likes: \(String(describing: (post?.likes ?? 0)))"
            postViewsLabel.text = "Views: \(String(describing: (post?.views ?? 0)))"
        }
    }
    
    var postTitleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.numberOfLines = 2
        return title
    }()
    
    var postImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        return image
    }()
    
    var postDescriptionLabel: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        description.textColor = .systemGray
        description.numberOfLines = 0
        return description
    }()
    
    var postlikesLabel: UILabel = {
        let likes = UILabel()
        likes.translatesAutoresizingMaskIntoConstraints = false
        likes.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        likes.textColor = .black
        return likes
    }()
    
    var postViewsLabel: UILabel = {
        let views = UILabel()
        views.translatesAutoresizingMaskIntoConstraints = false
        views.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        views.textColor = .black
        return views
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostTableViewCell {
    
    private func setupViews() {
        contentView.addSubview(postTitleLabel)
        contentView.addSubview(postImageView)
        contentView.addSubview(postDescriptionLabel)
        contentView.addSubview(postlikesLabel)
        contentView.addSubview(postViewsLabel)
        
        let constraints = [
            postTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            postTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            postTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.topAnchor.constraint(equalTo: postTitleLabel.bottomAnchor, constant: 12),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor),
            
            postDescriptionLabel.leadingAnchor.constraint(equalTo: postTitleLabel.leadingAnchor),
            postDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            postDescriptionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            
            postlikesLabel.leadingAnchor.constraint(equalTo: postTitleLabel.leadingAnchor),
            postlikesLabel.topAnchor.constraint(equalTo: postDescriptionLabel.bottomAnchor, constant: 16),
            postlikesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            postViewsLabel.topAnchor.constraint(equalTo: postlikesLabel.topAnchor),
            postViewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            postViewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
