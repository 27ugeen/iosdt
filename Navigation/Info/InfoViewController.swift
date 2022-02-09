//
//  InfoViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import UIKit

class InfoViewController: UIViewController {
    
    let infoNetworkService = InfoNetworkService()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    lazy var infoButtton = MagicButton(title: "dont touch me!!!", titleColor: .white) {
        self.buttonPressed()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queue = DispatchQueue(label: "update")
        
        queue.async {
            var userLabel = "test"
            
            if let url = URL(string: "https://jsonplaceholder.typicode.com/todos/41") {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let unwrappedData = data {
                        do {
                            let serializedData = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                            if let dict = serializedData as? [String: Any],
                               let title = dict["title"] as? String {
                                
                                userLabel = title
                                
                                DispatchQueue.main.async {
                                    self.infoLabel.text = userLabel
                                    print("label is: \(userLabel)")
                                }
                            }
                        }
                        catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }
                task.resume()
            } else {
                print("Can't create URL")
            }
        }
        setupViews()
    }
    
    func buttonPressed() {
        
        let alertVC = UIAlertController(title: "Error", message: "Something wrong!", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel) { _ in
            print("Destroyed!")
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { _ in
            print("Survived!")
        }
        alertVC.addAction(actionOk)
        alertVC.addAction(actionCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension InfoViewController {
    func setupViews() {
        
        self.view.backgroundColor = .systemPurple
        
        self.view.addSubview(infoButtton)
        self.view.addSubview(infoLabel)
        
        let constraints = [
            infoButtton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoButtton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoButtton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: infoButtton.bottomAnchor, constant: 10),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

//{
//    "userId": 3,
//    "id": 42,
//    "title": "rerum perferendis error quia ut eveniet",
//    "completed": false
//  },

struct UserModel {
    let userId: Int
    let Id: Int
    let title: String
    let completed: Bool
}


class InfoNetworkService {
    
    lazy var infoLabel: String = "tttt"
    
    func startTask(requestUrl: String) {
        if let url = URL(string: requestUrl) {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let unwrappedData = data {
                    do {
                        let serializedData = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                        
                        if let dict = serializedData as? [String: Any],
                           let title = dict["title"] as? String {
                            
                            self.infoLabel = title
                        }
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        } else {
            print("Can't create URL")
        }
    }
}
