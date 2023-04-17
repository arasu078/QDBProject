//
//  QDBProjectTests.swift
//  QDBProjectTests
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 17/04/23.
//

import XCTest
@testable import QDBProject

final class QDBProjectTests: XCTestCase {
    
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        apiClient = APIClient()
    }
    
    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }
    
    func testFetchPostsForUser() {
        let expectation = self.expectation(description: "Posts fetched successfully")
        let userId = 1
        let url = APIEndPoints(path: .postData(id: userId)).url
        apiClient.makeRequest(url: url, method: .get) { (result: Result<[Post], APIError>) in
            switch result {
            case .success(let posts):
                XCTAssertFalse(posts.isEmpty, "Posts array should not be empty")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("API request failed with error: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}

