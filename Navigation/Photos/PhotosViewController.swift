//
//  PhotosViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 08.08.2021.
//

import UIKit
import iOSIntPackage
import SnapKit

class PhotosViewController: UIViewController {
    
    private var imagePublisherFacade = ImagePublisherFacade()
    
    private var userImages: [UIImage]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        collection.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PhotosCollectionViewCell.self))
        
        collection.dataSource = self
        collection.delegate = self
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        imagePublisherFacade.subscribe(self)
        imagePublisherFacade.addImagesWithTimer(time: 1, repeat: ImgStorage.arrImg.count , userImages: ImgStorage.arrImg)
        
        self.title = "Photo Gallery"
    }
    
    deinit {
        imagePublisherFacade.rechargeImageLibrary()
        imagePublisherFacade.removeSubscription(for: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: UIBarButtonItem.Style.done, target: self, action: nil)
        self.navigationItem.setRightBarButtonItems([button], animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension PhotosViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        let constraints = [
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension PhotosViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        userImages = images
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return PhotosStorage.tableModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotosCollectionViewCell.self), for: indexPath) as! PhotosCollectionViewCell
        //=====================
//        var filteredImage: UIImage?
//                ImageProcessor().processImage(sourceImage: ImgStorage.arrImg[indexPath.item], filter: .colorInvert) {
//                    processedImage in
//                    filteredImage = processedImage
//                }
        //        cell.imageView.image = filteredImage
        //======================
        
        var userCgImage: [CGImage?]?

        ImageProcessor().processImagesOnThread(sourceImages: ImgStorage.arrImg, filter: .fade, qos: .userInitiated) {
            processedImages in
            userCgImage = processedImages
        }
        
        /*
         ImageProcessor().processImagesOnThread(sourceImages: ImgStorage.arrImg, filter: .noir, qos: .default)--9.63
         ImageProcessor().processImagesOnThread(sourceImages: ImgStorage.arrImg, filter: .chrome, qos: .utility)--16.51
         ImageProcessor().processImagesOnThread(sourceImages: ImgStorage.arrImg, filter: .colorInvert, qos: .utility)--13.10
         ImageProcessor().processImagesOnThread(sourceImages: ImgStorage.arrImg, filter: .colorInvert, qos: .userInteractive)--12.07
         ImageProcessor().processImagesOnThread(sourceImages: ImgStorage.arrImg, filter: .tonal, qos: .background)--14.72
         ImageProcessor().processImagesOnThread(sourceImages: ImgStorage.arrImg, filter: .fade, qos: .userInitiated)--16.39
         */

//        filteredImage = UIImage(cgImage: (userCgImage?[indexPath.item]) as! CGImage)
//        cell.imageView.image = filteredImage
        
        cell.imageView.image = userImages?[indexPath.item]
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let photoWidth = CGFloat(collectionView.frame.width - 4 * 8) / 3
        
        return CGSize(width: photoWidth, height: photoWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Photo Gallery: item: \(indexPath.item)")
    }
}


