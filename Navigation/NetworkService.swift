//
//  NetworkService.swift
//  Navigation
//
//  Created by GiN Eugene on 6/2/2022.
//

import Foundation

enum AppConfiguration: String, CaseIterable {
    case people = "https://swapi.dev/api/people/8"
    case starships = "https://swapi.dev/api/starships/3"
    case planets = "https://swapi.dev/api/planets/5"
}

struct NetworkService {
    
    static func startTask(requestUrl: String) {
        if let url = URL(string: requestUrl) {
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let unwrappedData = data {
                    if let converted = String(data: unwrappedData, encoding: .utf8) {
                        print("Server's data is: \(converted)")
                    }
                }
                
                if let httpUrlRespose = response as? HTTPURLResponse {
                    print("Status code is: \(httpUrlRespose.statusCode)") // status code
                    do {
                        let headers = try JSONSerialization.data(withJSONObject: httpUrlRespose.allHeaderFields, options: .prettyPrinted)
                        
                        if let JSONHeaders = String(data: headers, encoding: .utf8) {
                            print("Server's Headers are: \(JSONHeaders)") // all headers
                        }
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                }
                if let unwrappedError = error as NSError? {
                    let code = unwrappedError.code
                    print("Error code is: \(code)") // code: -1009
                    
                    print("Error is: \(unwrappedError.debugDescription)") // "The Internet connection appears to be offline."
                }
            }
            
            task.resume()
            
        } else {
            print("Cannot create URL")
        }
    }
}
