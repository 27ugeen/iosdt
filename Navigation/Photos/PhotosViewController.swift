//
//  PhotosViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 08.08.2021.
//

import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {
    
    var imagePublisherFacade = ImagePublisherFacade()
    
//    let userImages = ImgStorage.arrImg
    
    private var userImages: [UIImage]? {
        
        didSet {
//            let photosStorage = PhotosStorage()
//            let userArrayImages = UserImagesArray()
//            userPhoto = userArrayImages.recivePhotos(photos: photosStorage)
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
        imagePublisherFacade.addImagesWithTimer(time: 1, repeat: 18, userImages: ImgStorage.arrImg)
        
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
//        imagePublisherFacade.addImagesWithTimer(time: 2, repeat: 18, userImages: ImgStorage.arrImg)
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
//        return PhotosStorage.tableModel.count
        return 1
//        return userPhoto?.count ?? 1
//        if let section = dataSource?.count {
//            return section
//        } else {
//            return 0
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return PhotosStorage.tableModel[section].photos.count
        return userImages?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotosCollectionViewCell.self), for: indexPath) as! PhotosCollectionViewCell
//        cell.photo = PhotosStorage.tableModel[indexPath.section].photos[indexPath.row]
//        let cell = UICollectionViewCell()
        cell.photo = ImgStorage.arrImg.first
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


