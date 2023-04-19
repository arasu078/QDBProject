//
//  DashboardViewController.swift
//  QDBProject
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 12/04/23.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController {
    
    // MARK: - Properties
    var dashboardViewModel: DashBoardViewModel = DashBoardViewModel()
    var tableView: UITableView!
    var index: Int?
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchDataFromViewModel(id: index ?? 1)
    }
    
    // MARK: - Private Methods
    private func configureTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DashboardTableViewCell.self, forCellReuseIdentifier: AppConstants.dashboardCellId)
        self.view.addSubview(tableView)
    }
    
    private func fetchDataFromViewModel(id: Int) {
        LoadingIndicator.shared.show()
        dashboardViewModel.fetchData(id: id) { status in
            LoadingIndicator.shared.hide()
            if status {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - TableView Delegates and Datasources
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardViewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.dashboardCellId, for: indexPath) as? DashboardTableViewCell,
               let userObject = dashboardViewModel.objectAt(index: indexPath.row) else {
            return UITableViewCell()
        }
        let image = UIImage(named: "ProfilePic")
        cell.configure(with: userObject.title, subtitle: userObject.body, image: image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userObject = dashboardViewModel.objectAt(index: indexPath.row) else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: AppConstants.detailViewControllerID) as! DetailViewController
        detailViewController.post = userObject
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
