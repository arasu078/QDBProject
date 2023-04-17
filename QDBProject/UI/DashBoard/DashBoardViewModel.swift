//
//  DashBoardViewModel.swift
//  QDBProject
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 12/04/23.
//

import Foundation

class DashBoardViewModel {
    var posts: [Post]?
    func fetchData(id: Int, completionStatus: @escaping (Bool) -> Void) {
        APIConnector().fetchPosts(id: id) { (result: Result<[Post], APIError>) in
            switch result {
            case .success(let user):
                self.posts = user
                completionStatus(true)
            case .failure(let error):
                completionStatus(false)
                print(error)
            }
        }
    }
    
    func hasData() -> Bool {
        guard let posts else {
            return false
        }
        return true
    }
    
    func numberOfRows() -> Int {
        return posts?.count ?? 0
    }
    
    func objectAt(index: Int) -> Post? {
        return posts?[index]
    }
}
