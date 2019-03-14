//
//  REST.swift
//  Carangas
//
//  Created by Usuário Convidado on 13/03/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Foundation

class REST {
    
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    //private static let session = URLSession.shared
    
    private static let configuration : URLSessionConfiguration = {
        
        let config = URLSessionConfiguration.default
        
        // Desabilitar acesso a internet movel
        config.allowsCellularAccess = false
        
        // Adiconar alguma coisa no header
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        
        // Configurar um tempo para o timeout
        config.timeoutIntervalForRequest = 30.0
        
        // Maximo de conexao que podera ter simultaniamente
        config.httpMaximumConnectionsPerHost = 3
        
        return config
    }()
    
    private static let session = URLSession(configuration: configuration)
    
    class func loadCars(onComplete: @escaping ([Car]) -> Void) {
        
        guard let url = URL(string: basePath) else {
            print("Erro ao montar URL")
            return
        }
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print("Deu erro", error!)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Response nulo")
                return
            }
            
            if response.statusCode != 200 {
                print("Erro de status code", response.statusCode)
                return
            }
            
            guard let data = data else {
                print("Dados inválidos!")
                return
            }
            
            do {
                
                let cars = try JSONDecoder().decode([Car].self, from: data)
                
                onComplete(cars)
                
                print("Total de carros", cars.count)
                
            } catch {
                print("Error ao tratar json")
            }
            
            
        })
        
        task.resume()
        print("Fim do metodo")
    }
    
    class func applyOperation(_ operation: RESTOperation, car: Car, onComplete: @escaping (Bool) -> Void) {
        
        let urlString = basePath + "/" + (car._id ?? "")
        
        var httpMethod: String = ""
        
        switch operation {
        case .delete:
            httpMethod = "DELETE"
        case .save:
            httpMethod = "POST"
        case .update:
            httpMethod = "PUT"
        }
        
        guard let url = URL(string: urlString) else {
            onComplete(false)
            return
        }
        
        var urlResquest = URLRequest(url: url)
        urlResquest.httpMethod = httpMethod
        urlResquest.httpBody = try! JSONEncoder().encode(car)
        
        let task = session.dataTask(with: urlResquest) { (data, _, _) in
            guard let _ = data else {
                onComplete(false)
                return
            }
            
            onComplete(true)
        }
        
        task.resume()
        
    }
    
}

enum RESTOperation {
    case update
    case delete
    case save
}



