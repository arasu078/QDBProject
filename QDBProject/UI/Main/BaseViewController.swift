//
//  ViewController.swift
//  QDBProject
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 12/04/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - StoryBoard Properties
    @IBOutlet weak var backViewForHamburgerView: UIView!
    @IBOutlet weak var HamburgerViewleadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var hamburgerView: UIView!
    @IBOutlet weak var parentView: UIView!
    
    // MARK: - Properties
    var childView: UIViewController?
    private var isHamburgerMenuShown:Bool = false
    private var beginPoint:CGFloat = 0.0
    private var difference:CGFloat = 0.0
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        childView = DashboardViewController()
        addViewController(childView!)
    }
    
    //MARK: - Private Mehtods
    private func configureNavigationBar() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {            
            let statusBar = UIView(frame: window.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = .white
            window.addSubview(statusBar)
        }
        
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(showHideHamburgerView))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func addViewController(_ childVC: UIViewController) {
        addChild(childVC)
        childVC.view.frame = view.frame
        view.addSubview(childVC.view)
        childVC.didMove(toParent: self)
    }
    
    private func removeViewController() {
        guard let index = children.firstIndex(of: childView!) else {
            return
        }
        let currentChildVC = children[index]
        currentChildVC.willMove(toParent: nil)
        currentChildVC.view.removeFromSuperview()
        currentChildVC.removeFromParent()
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == AppConstants.hamburgerSegue) {
            if let controller = segue.destination as? HamburgerMenuVC {
                controller.delegate = self
            }
        }
    }
    
    //MARK: - Selectors
    @objc func showHideHamburgerView() {
        isHamburgerMenuShown ? hideHamburgerView() : showHamburgerView()
    }
    
    //MARK: - HamburgerMenu Helpers
    private func hideHamburgerView() {
        addViewController(childView!)
        UIView.animate(withDuration: 0.1) {
            self.HamburgerViewleadingConstraint.constant = 10
            self.view.layoutIfNeeded()
        } completion: { (status) in
            self.backViewForHamburgerView.alpha = 0.0
            UIView.animate(withDuration: 0.1) {
                self.HamburgerViewleadingConstraint.constant = -280
                self.view.layoutIfNeeded()
            } completion: { (status) in
                self.backViewForHamburgerView.isHidden = true
                self.isHamburgerMenuShown = false
            }
        }
    }
    
    private func showHamburgerView() {
        removeViewController()
        UIView.animate(withDuration: 0.1) {
            self.HamburgerViewleadingConstraint.constant = 10
            self.view.layoutIfNeeded()
        } completion: { (status) in
            self.backViewForHamburgerView.alpha = 0.75
            self.backViewForHamburgerView.isHidden = false
            UIView.animate(withDuration: 0.1) {
                self.HamburgerViewleadingConstraint.constant = 0
                self.view.layoutIfNeeded()
            } completion: { (status) in
                self.isHamburgerMenuShown = true
            }
        }
        self.backViewForHamburgerView.isHidden = false
    }
}

//MARK: - HamburgerViewControllerDelegate
extension BaseViewController: HamburgerViewControllerDelegate {
    func hamburgerMenuTapped(indexPath: IndexPath) {
        isHamburgerMenuShown = false
        title = DataFeeder.sectionData[indexPath.section][indexPath.row]
        removeViewController()
        if indexPath.section == 0 {
            let dashboardViewController = DashboardViewController()
            dashboardViewController.index = indexPath.row + 3
            childView = dashboardViewController
            addViewController(childView!)
        } else  {
            let baseBlogViewController = BaseBlogViewController()
            baseBlogViewController.currenPageIndex = indexPath.row

            childView = baseBlogViewController
            addViewController(childView!)
        }
    }
}
