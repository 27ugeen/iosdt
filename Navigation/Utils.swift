//
//  Utils.swift
//  Navigation
//
//  Created by GiN Eugene on 25/10/21.
//

import Foundation
import UIKit
import iOSIntPackage

public func putFilterOnImage(_ image: UIImage, _ filterOn: ColorFilter) -> UIImage {
    var filteredImage: UIImage?
    ImageProcessor().processImage(sourceImage: image, filter: filterOn) { processedImage in
        filteredImage = processedImage
    }
    return filteredImage ?? image
}
