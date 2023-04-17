//
//  ChildBlogViewController.swift
//  QDBProject
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 13/04/23.
//

import UIKit

class ChildBlogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    var blogViewModel: BlogViewModel
    var tableView: UITableView!
    
    //MARK: - Initializers
    init(blogViewModel: BlogViewModel) {
        self.blogViewModel = blogViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        blogViewModel.onArrayUpdated = { isUpdated in
            if isUpdated {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Private Methods
    private func configureTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DashboardTableViewCell.self, forCellReuseIdentifier: AppConstants.childBlogViewControllerCellId)
        self.view.addSubview(tableView)
    }
    
    // MARK: - TableView Delegates and Datasources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogViewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.childBlogViewControllerCellId, for: indexPath) as? DashboardTableViewCell,
            let userObject = blogViewModel.objectAt(index: indexPath.row) else {
            return UITableViewCell()
        }
        let image = UIImage(named: "ProfilePic")
        cell.configure(with: userObject.title, subtitle: userObject.body, image: image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userObject = blogViewModel.objectAt(index: indexPath.row) else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailView = storyboard.instantiateViewController(withIdentifier: AppConstants.childBlogViewControllerCellId) as! DetailViewController
        detailView.post = userObject
        navigationController?.pushViewController(detailView, animated: true)
    }
}
