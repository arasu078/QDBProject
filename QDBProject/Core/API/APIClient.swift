//
//  ApiClient.swift
//  QDBProject
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 12/04/23.
//

import Foundation

class APIClient {
    
    func makeRequest<T: Decodable>(url: URL, method: HttpMethod, parameters: Encodable? = nil, headers: [String: String]? = nil, completion: @escaping (Result<T, APIError>) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let parameters = parameters {
            do {
                let jsonData = try JSONEncoder().encode(parameters)
                request.httpBody = jsonData
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.responseUnsuccessful))
                return
            }
            if error != nil {
                completion(.failure(.requestFailed))
                return
            }
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(.invalidData))
                return
            }
            print(responseString)
            if httpResponse.statusCode == 200 {
                do {
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode(T.self, from: data)
                    completion(.success(responseModel))
                } catch {
                    completion(.failure(.jsonParsingFailure))
                }
            } else {
                completion(.failure(.responseUnsuccessful))
            }
            
        }.resume()
    }
}
