//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by GiN Eugene on 25.07.2021.
//

import UIKit
import SnapKit

class ProfileHeaderView: UITableViewHeaderFooterView {
    
    let avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.white.cgColor
        image.image = UIImage(named: "blackCat")
        image.layer.cornerRadius = 110 / 2
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let fullNameLabel: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "Hipster Cat"
        name.textColor = .black
        name.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return name
    }()
    
    let statusLabel: UILabel = {
        let status = UILabel()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.text = "Waiting for something..."
        status.textColor = .gray
        status.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return status
    }()
    
    let statusTextField: UITextField = {
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
    
    lazy var setStatusButton = MagicButton(title: "Set status", titleColor: .white) { [self] in
            print("Setstatus button pressed...")
            (statusTextField.text == "" || statusTextField.text == nil) ?
            (statusLabel.text = "Write something!") :
            (statusLabel.text = statusTextField.text)
            statusTextField.text = ""
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupStatusButton()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
}

extension ProfileHeaderView {
    private func setupStatusButton() {
        setStatusButton.setTitleColor(.purple, for: .highlighted)
        setStatusButton.backgroundColor = .systemBlue.withAlphaComponent(0.7)
        setStatusButton.layer.cornerRadius = 14
        setStatusButton.layer.shadowRadius = 4
        setStatusButton.layer.shadowOpacity = 0.7
        setStatusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        setStatusButton.layer.shadowColor = UIColor.black.cgColor
    }
}

extension ProfileHeaderView {
    private func setupViews(){
        
        addSubview(avatarImage)
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(statusTextField)
        addSubview(setStatusButton)
        
        avatarImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(16)
            make.leading.equalTo(16)
            make.size.equalTo(CGSize(width: 110, height: 110))
        }
        fullNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(16)
            make.leading.equalTo(avatarImage.snp.trailing).offset(16)
        }
        setStatusButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(avatarImage.snp.bottom).offset(46)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(-16)
            make.height.equalTo(50)
        }
        statusTextField.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(avatarImage.snp.trailing).offset(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(setStatusButton.snp.top).offset(-16)
            make.height.equalTo(40)
        }
        statusLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(avatarImage.snp.trailing).offset(16)
            make.bottom.equalTo(statusTextField.snp.top).offset(-8)
        }
    }
}
