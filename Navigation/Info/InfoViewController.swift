//
//  InfoViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import UIKit

class InfoViewController: UIViewController {
    
    enum userURLs: String {
        case planets = "https://swapi.dev/api/planets/1"
        case todos = "https://jsonplaceholder.typicode.com/todos/41"
    }
    
    var planetInfoModel: PlanetInfoModel?
    
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
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        decodeStringFromData(costumURL: userURLs.planets.rawValue, modelType: PlanetInfoModel.self) { model in
            self.planetInfoModel = model
            DispatchQueue.main.async {
                self.orbitalPeriodLabel.text = "Orbital period is: " + model.orbitalPerion + " solar days"
            }
        }
        
        serializeStringFromData(costumURL: userURLs.todos.rawValue) { title in
            DispatchQueue.main.async {
                self.infoLabel.text = title
            }
        }
        
        setupViews()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        print("Residents: \(String(describing: planetInfoModel?.residents))")
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
    
    func serializeStringFromData(costumURL: String, completition: @escaping (String) -> Void){
        if let url = URL(string: costumURL) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let unwrappedData = data {
                    do {
                        let serializedData = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                        if let dict = serializedData as? [String: Any],
                           let title = dict["title"] as? String {
                            completition(title)
                        }
                    } catch let error { print(error) }
                }
            }
            task.resume()
        } else { print("Can't create URL") }
    }
    
    func decodeStringFromData<T: Decodable>(costumURL: String, modelType: T.Type, completition: @escaping (T) -> Void) {
        if let url = URL(string: costumURL) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let unwrappedData = data {
                    do {
                        let planetInfo = try JSONDecoder().decode(modelType, from: unwrappedData)
                        completition(planetInfo)
                    }
                    catch let error { print("Error: \(error)") }
                }
            }
            task.resume()
        } else { print("Can't create URL") }
    }
}

extension InfoViewController {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: String(describing: InfoTableViewCell.self))
        tableView.dataSource = self
    }
}

extension InfoViewController {
    func setupViews() {
        
        self.view.backgroundColor = .systemPurple
        
        self.view.addSubview(infoButtton)
        self.view.addSubview(infoLabel)
        self.view.addSubview(orbitalPeriodLabel)
        self.view.addSubview(tableView)
        
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
            
            tableView.topAnchor.constraint(equalTo: orbitalPeriodLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.planetInfoModel?.residents.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoTableViewCell.self), for: indexPath) as! InfoTableViewCell

        decodeStringFromData(costumURL: userURLs.planets.rawValue, modelType: PlanetInfoModel.self) { model in
            self.planetInfoModel = model
            if let urls = self.planetInfoModel?.residents {
                self.decodeStringFromData(costumURL: urls[indexPath.row], modelType: ResidentsModel.self) { model in
                    DispatchQueue.main.async {
                        cell.label.text = model.name
                    }
                }
            }
        }
        return cell
    }
}

struct PlanetInfoModel: Codable {
    let name: String
    let orbitalPerion: String
    let diameter: String
    let population: String
    var residents: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case orbitalPerion = "orbital_period"
        case diameter
        case population
        case residents
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        orbitalPerion = try values.decode(String.self, forKey: .orbitalPerion)
        diameter = try values.decode(String.self, forKey: .diameter)
        population = try values.decode(String.self, forKey: .population)
        residents = try values.decode([String].self, forKey: .residents)
    }
}

struct ResidentsModel: Codable {
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
    }
}
