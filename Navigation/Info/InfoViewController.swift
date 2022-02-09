//
//  InfoViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import UIKit

class InfoViewController: UIViewController {
    
//    let infoNetworkService = InfoNetworkService()
    
    lazy var infoButtton = MagicButton(title: "dont touch me!!!", titleColor: .white) {
        self.buttonPressed()
    }
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let orbitalPeriodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Orbita"
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queueInfoLabel = DispatchQueue(label: "InfoLabel")
        let queueOrbitalPeriodLabel = DispatchQueue(label: "orbitalPeriodLabel")
        
        queueOrbitalPeriodLabel.async {
            var period = "0"
            
            if let url = URL(string: "https://swapi.dev/api/planets/1") {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let unwrappedData = data {
                        do{
                            let planetInfo = try JSONDecoder().decode(PlanetInfoModel.self, from: unwrappedData)
                            print("Data: \(planetInfo)")
                            period = planetInfo.orbitalPerion
                            
                            DispatchQueue.main.async {
                                self.orbitalPeriodLabel.text = "Orbital period is: " + period + " solar days"
                                print("Orbital period is: \(period)")
                            }
                        }
                        catch let error {
                            print("Error: \(error)")
                        }
                    }
                    
                }
                task.resume()
            } else {
                print("Can't create URL")
            }
        }
        queueInfoLabel.async {
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
        self.view.addSubview(orbitalPeriodLabel)
        
        let constraints = [
            infoButtton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            infoButtton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoButtton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: infoButtton.bottomAnchor, constant: 10),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            orbitalPeriodLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            orbitalPeriodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            orbitalPeriodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
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

struct UserModel: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case completed
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        userId = try container.decode(Int.self, forKey: .userId)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        completed = try container.decode(Bool.self, forKey: .completed)
    }
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

struct PlanetInfoModel: Codable {
    let name: String
//    let rotationPeriod: Int
    let orbitalPerion: String
    let diameter: String
//    let climate: String
//    let gravity: String
//    let terrain: String
//    let surfaceWater: Int
    let population: String
    
    enum CodingKeys: String, CodingKey {
        case name
//        case rotationPeriod = "rotation_period"
        case orbitalPerion = "orbital_period"
        case diameter
//        case climate
//        case gravity
//        case terrian
//        case surfaceWater = "surface_water"
        case population
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        orbitalPerion = try container.decode(String.self, forKey: .orbitalPerion)
        diameter = try container.decode(String.self, forKey: .diameter)
        population = try container.decode(String.self, forKey: .population)
    }
}

//{
//    "name": "Tatooine",
//    "rotation_period": "23",
//    "orbital_period": "304",
//    "diameter": "10465",
//    "climate": "arid",
//    "gravity": "1 standard",
//    "terrain": "desert",
//    "surface_water": "1",
//    "population": "200000",
//    "residents": [
//        "https://swapi.dev/api/people/1/",
//        "https://swapi.dev/api/people/2/",
//        "https://swapi.dev/api/people/4/",
//        "https://swapi.dev/api/people/6/",
//        "https://swapi.dev/api/people/7/",
//        "https://swapi.dev/api/people/8/",
//        "https://swapi.dev/api/people/9/",
//        "https://swapi.dev/api/people/11/",
//        "https://swapi.dev/api/people/43/",
//        "https://swapi.dev/api/people/62/"
//    ],
//    "films": [
//        "https://swapi.dev/api/films/1/",
//        "https://swapi.dev/api/films/3/",
//        "https://swapi.dev/api/films/4/",
//        "https://swapi.dev/api/films/5/",
//        "https://swapi.dev/api/films/6/"
//    ],
//    "created": "2014-12-09T13:50:49.641000Z",
//    "edited": "2014-12-20T20:58:18.411000Z",
//    "url": "https://swapi.dev/api/planets/1/"
//}
