//
//  BlogViewModel.swift
//  QDBProject
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 13/04/23.
//

import Foundation

class BlogViewModel: DashBoardViewModel {
    // MARK: - Properties
    var postsDict: [Int: [Post]]? = [:] {
        didSet {
            onArrayUpdated?(true)
        }
    }
    var onArrayUpdated: ((Bool) -> Void)?
        var index: Int = 0 {
        didSet {
            guard let postsDict, let _ = postsDict[index] else {
                super.fetchData(id: index + 2) {  status in
                    if status, let post = self.posts {
                        self.postsDict?[self.index] = post
                    }
                }
                return
            }
        }
    }
    
    // MARK: - Data Helpers
    override func hasData() -> Bool {
        guard let postsDict, let postData = postsDict[index] else {
            return false
        }
        return postData.count <= 0
    }
    
    override func numberOfRows() -> Int {
        guard let postsDict, let postData = postsDict[index] else {
            return 0
        }
        return postData.count
    }

    override func objectAt(index: Int) -> Post? {
        guard let postsDict, let postData = postsDict[self.index] else {
            return nil
        }
        return postData[index]
    }
}
