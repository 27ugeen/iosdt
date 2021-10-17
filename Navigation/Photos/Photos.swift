//
//  Photos.swift
//  Navigation
//
//  Created by GiN Eugene on 08.08.2021.
//

import Foundation
import UIKit

struct Photo {
    let image: UIImage
}

struct PhotosSection {
    let photos: [Photo]
}

struct PhotosStorage {
    static let tableModel = [
        PhotosSection(photos: [Photo(image: #imageLiteral(resourceName: "bmw")), Photo(image: #imageLiteral(resourceName: "beach")), Photo(image: #imageLiteral(resourceName: "dog-")), Photo(image: #imageLiteral(resourceName: "ocean")),
                               Photo(image: #imageLiteral(resourceName: "zakynthos")), Photo(image: #imageLiteral(resourceName: "cat")), Photo(image: #imageLiteral(resourceName: "woman2")), Photo(image: #imageLiteral(resourceName: "drop")),
                               Photo(image: #imageLiteral(resourceName: "women")), Photo(image: #imageLiteral(resourceName: "jellyfish")), Photo(image: #imageLiteral(resourceName: "smoothie")), Photo(image: #imageLiteral(resourceName: "strawberries")),
                               Photo(image: #imageLiteral(resourceName: "girl-26")), Photo(image: #imageLiteral(resourceName: "kingfisher")), Photo(image: #imageLiteral(resourceName: "man")), Photo(image: #imageLiteral(resourceName: "sailboat")),
                               Photo(image: #imageLiteral(resourceName: "sea-shell")), Photo(image: #imageLiteral(resourceName: "car2")), Photo(image: #imageLiteral(resourceName: "macroperspective")), Photo(image: #imageLiteral(resourceName: "ferrari-458-spider")),
                               Photo(image: #imageLiteral(resourceName: "cat")), Photo(image: #imageLiteral(resourceName: "wolf")), Photo(image: #imageLiteral(resourceName: "tasmanian-devil")), Photo(image: #imageLiteral(resourceName: "palm-trees")),
                               Photo(image: #imageLiteral(resourceName: "shoes")), Photo(image: #imageLiteral(resourceName: "sea-25")), Photo(image: #imageLiteral(resourceName: "surf-15")), Photo(image: #imageLiteral(resourceName: "road")),
                               Photo(image: #imageLiteral(resourceName: "porsche")), Photo(image: #imageLiteral(resourceName: "waves")), Photo(image: #imageLiteral(resourceName: "girls")), Photo(image: #imageLiteral(resourceName: "tree")),
                               Photo(image: #imageLiteral(resourceName: "ladybug")), Photo(image: #imageLiteral(resourceName: "raccoon")), Photo(image: #imageLiteral(resourceName: "dog-2")), Photo(image: #imageLiteral(resourceName: "zakynthos")),
                               Photo(image: #imageLiteral(resourceName: "face-painting")), Photo(image: #imageLiteral(resourceName: "boat")), Photo(image: #imageLiteral(resourceName: "girls")), Photo(image: #imageLiteral(resourceName: "milky-way")),
                               Photo(image: #imageLiteral(resourceName: "waves")), Photo(image: #imageLiteral(resourceName: "the-sun"))
        ])
    ]
}
