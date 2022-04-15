//
//  InfoTableViewCell.swift
//  Navigation
//
//  Created by GiN Eugene on 12/2/2022.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InfoTableViewCell {
    func setupViews() {
        contentView.backgroundColor = .systemPurple
        contentView.addSubview(label)
        
        let constraints = [
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
