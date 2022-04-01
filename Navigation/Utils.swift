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

//public func putFilterOnImageOnThread(_ images: [UIImage], _ filterOn: ColorFilter, _ qualityOfService: QualityOfService) -> [UIImage] {
//    var cgImages: [CGImage?]?
//    ImageProcessor().processImagesOnThread(sourceImages: images, filter: filterOn, qos: qualityOfService) { processedImages in
//        cgImages = processedImages
//    }
//    return cgImages.map {
//        image in
//        return [UIImage(cgImage: image as! CGImage)]
//    } as! [UIImage]
//}

public func reciveImagesArrFromPhotoStorage(photos: AnyObject) -> [UIImage] {
    var imageArray: [UIImage] = []
    
         PhotosStorage.tableModel.forEach { PhotosSection in
             PhotosSection.photos.forEach { Photo in
                 imageArray.append(Photo.image)
             }
         }
    return imageArray
}

extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension String {
    var isValidEmail: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}

extension UIViewController {
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
