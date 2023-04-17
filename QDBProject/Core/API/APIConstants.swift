//
//  APIConstants.swift
//  QDBProject
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 12/04/23.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum APIError: Error {
    case netWorkError
    case requestFailed
    case invalidData
    case jsonConversionFailure
    case responseUnsuccessful
    case jsonParsingFailure
    
    var description: String {
        switch self {
        case .netWorkError:
            return "NetWork Error"
        case .requestFailed:
            return "Request Failed"
        case .invalidData:
            return "Invalid Data"
        case .jsonConversionFailure, .responseUnsuccessful:
            return "Parsing Error"
        default:
            return "Unknown Error"
        }
    }
}

enum HttpStatusCode: CustomStringConvertible {
    case unhandled(code: Int)
    case ok                   
    
    init(statusCode: Int) {
        switch(statusCode) {
        case 200:
            self = .ok
        default:
            self = .unhandled(code: statusCode)
        }
    }
    
    var description: String {
        switch self {
        case .ok:
            return "HTTP 200 (OK)"
            
        case .unhandled(let code):
            return "HTTP \(code) <unhandled status code>"
        }
    }
}
