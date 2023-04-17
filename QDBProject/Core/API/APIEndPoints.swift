//
//  APIEndPoints.swift
//  QDBProject
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 12/04/23.
//

import Foundation

struct APIEndPoints {
    let url: URL
    
    enum ApiEndpointPath {
        case postData(id: Int)
        case putPost(id: Int)
        
        func path() -> String {
            switch self {
            case .postData(let id):
                return "/users/\(id)/posts"
            case .putPost(let id):
                return "posts/\(id)"
            }
        }
    }
    
    init(path: ApiEndpointPath) {
        guard let infoDict = Bundle.main.infoDictionary,
              let baseUrlString = infoDict["BASE_URL"] as? String,
        let baseURL = URL(string: baseUrlString)else {
            fatalError("Base URL not found in environment variables.")
        }

        self.url = baseURL.appendingPathComponent(path.path())
    }
}


