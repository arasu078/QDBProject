//
//  BaseBlogViewController.swift
//  QDBProject
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 12/04/23.
//

import Foundation
import UIKit

class BaseBlogViewController: UIViewController, GenericSwipeViewControllerDelegate {
    
    // MARK: - Properties
    let blogViewModel = BlogViewModel()
    let swipeView = GenericSwipeViewController()
    var currenPageIndex: Int?
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSwipeViewControllers()
    }
    
    // MARK: - Private Methods
    private func configureSwipeViewControllers() {
        swipeView.viewFrame = CGRect(x: 0.0, y: 50, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 50)
        swipeView.titleBarDataSource = DataFeeder.sectionData.last
        swipeView.delegate = self
        swipeView.currentPageIndex = self.currenPageIndex ?? 0
        self.addChild(swipeView)
        self.view.addSubview(swipeView.view)
        swipeView.didMove(toParent: self)
    }
    
    // MARK: - GenericSwipeViewControllerDelegate
    func didLoadViewControllerAtIndex(_ index: Int) -> UIViewController {
        let childBlogViewController = ChildBlogViewController(blogViewModel: blogViewModel)
        blogViewModel.index = index
        return childBlogViewController
    }
}
