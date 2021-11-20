//
//  MagicButton.swift
//  Navigation
//
//  Created by GiN Eugene on 20/11/21.
//

import Foundation
import UIKit

final class MagicButton: UIButton {
    
    var title: String?
    var titleColor: UIColor?
    var buttonColor: UIColor?
    
    var onTap: (() -> Void)?
    
    init(title: String, titleColor: UIColor) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.title = title
        self.titleColor = titleColor
//        self.buttonColor = buttonColor
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    @objc private func buttonTapped() {
        onTap?()
    }
}
