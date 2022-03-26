//
//  InfoViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import UIKit

enum userURLs: String {
    case planets = "https://swapi.dev/api/planets/1"
    case todos = "https://jsonplaceholder.typicode.com/todos/41"
}

class InfoViewController: UIViewController {
    
    var planetInfoModel: PlanetInfoModel?
    var residentsModel: ResidentsModel?
    var residentsName: [String] = []
    
    let viewModel: InfoViewModel
    
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
    
    init(viewModel: InfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.decodeModelFromData(costumURL: userURLs.planets.rawValue, modelType: PlanetInfoModel.self) { model in
            self.planetInfoModel = model
            if let urls = self.planetInfoModel?.residents {
                
                for url in urls {
                    self.viewModel.decodeModelFromData(costumURL: url, modelType: ResidentsModel.self) { model in
                        self.residentsModel = model
                        self.residentsName.append(model.name)
                        self.tableView.reloadData()
                    }
                }
            }
            self.orbitalPeriodLabel.text = "Orbital period is: " + (self.planetInfoModel?.orbitalPerion ?? "0") + " solar days"
        }
        
        viewModel.serializeValueFromData(costumURL: userURLs.todos.rawValue, value: "title") { value in
            self.infoLabel.text = value
        }
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
        residentsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoTableViewCell.self), for: indexPath) as! InfoTableViewCell
        
        cell.label.text = residentsName[indexPath.row]
        return cell
    }
}
