//
//  InfoViewModel.swift
//  Navigation
//
//  Created by GiN Eugene on 26/3/2022.
//

import Foundation

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

protocol InfoViewModelOutputProtocol: AnyObject {
    func serializeValueFromData(costumURL: String, value: String, completition: @escaping (String) -> Void)
    func decodeModelFromData<T: Decodable>(costumURL: String, modelType: T.Type, completition: @escaping (T) -> Void)
}

final class InfoViewModel: InfoViewModelOutputProtocol {
    
    var planetsInfo: [PlanetInfoModel] = []
    
    func serializeValueFromData(costumURL: String, value: String, completition: @escaping (String) -> Void){
        if let url = URL(string: costumURL) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let unwrappedData = data {
                    do {
                        let serializedData = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                        if let dict = serializedData as? [String: Any],
                           let title = dict[value] as? String {
                            DispatchQueue.main.async {
                                completition(title)
                            }
                        }
                    } catch let error { print(error) }
                }
            }
            task.resume()
        } else { print("Can't create URL") }
    }
    
    func decodeModelFromData<T: Decodable>(costumURL: String, modelType: T.Type, completition: @escaping (T) -> Void) {
        if let url = URL(string: costumURL) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let unwrappedData = data {
                    do {
                        let modelInfo = try JSONDecoder().decode(modelType, from: unwrappedData)
                        DispatchQueue.main.async {
                            completition(modelInfo)
                        }
                    }
                    catch let error { print("Error: \(error)") }
                }
            }
            task.resume()
        } else { print("Can't create URL") }
    }
}
