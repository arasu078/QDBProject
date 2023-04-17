//
//  APIConnector.swift
//  QDBProject
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 13/04/23.
//

import Foundation

class APIConnector {
    func fetchPosts(id: Int, completionStatus: @escaping (Result<[Post], APIError>) -> Void) {
        let dashboardUrl = APIEndPoints(path: .postData(id: id)).url
        APIClient().makeRequest(url: dashboardUrl, method: .get) { (result: Result<[Post], APIError>) in
            DispatchQueue.main.async {
                completionStatus(result)
            }
        }
    }
    
    func putPost(payload: Post) {
        LoadingIndicator.shared.show()
        let url = APIEndPoints(path: .putPost(id: payload.id)).url
        APIClient().makeRequest(url: url, method: .put, parameters: payload) { (result: Result<Post, APIError>) in
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
            }
            switch result {
            case .success(let user):
                print(user)
            case .failure(let error):
                print(error)
            }
        }
    }
}
