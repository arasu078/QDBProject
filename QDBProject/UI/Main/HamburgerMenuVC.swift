//
//  HamburgerMenuVC.swift
//  QDBProject
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 12/04/23.
//

import Foundation
import UIKit

protocol HamburgerViewControllerDelegate {
    func hamburgerMenuTapped(indexPath: IndexPath)
}

class HamburgerMenuVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: HamburgerViewControllerDelegate?
    var sectionExpanded: [Bool] = [false, false, false]

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        profileIcon.layer.cornerRadius = profileIcon.frame.size.width / 2
        profileIcon.layer.masksToBounds = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: AppConstants.hamburgerCellId)
    }
}

// MARK: - TableView Delegates and Datasources
extension HamburgerMenuVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DataFeeder.sectionData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionExpanded[section] {
            return DataFeeder.sectionData[section].count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.hamburgerCellId, for: indexPath)
        cell.textLabel?.text = DataFeeder.sectionData[indexPath.section][indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        cell.textLabel?.textColor = UIColor.darkGray

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.hamburgerMenuTapped(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        headerView.backgroundColor = .white
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width, height: 20))
        headerLabel.text = DataFeeder.sectionTitle[section]
        headerLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        headerView.addSubview(headerLabel)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleSectionExpansion(_:)))
        headerView.addGestureRecognizer(tapGestureRecognizer)
        headerView.tag = section

        return headerView
    }

    // MARK: - Selectors
    @objc func toggleSectionExpansion(_ gestureRecognizer: UITapGestureRecognizer) {
        if let section = gestureRecognizer.view?.tag {
            sectionExpanded = [false, false, false]
            sectionExpanded[section] = !sectionExpanded[section]
            tableView.reloadSections(IndexSet(integersIn: 0..<tableView.numberOfSections), with: .automatic)
        }
    }
}
