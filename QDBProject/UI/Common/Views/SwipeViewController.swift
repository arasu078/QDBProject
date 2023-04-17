//
//  SwipeViewController.swift
//  QDBProject
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 13/04/23.
//


import UIKit

protocol GenericSwipeViewControllerDelegate {
    func didLoadViewControllerAtIndex(_ index: Int) -> UIViewController
}

class GenericSwipeViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    // MARK: - Constants
    var kSelectionBarSwipeConstant: CGFloat = 4.5
    var kTitleFont: UIFont = Fonts.Bold.of(size: 17)
    var titleBarHeight: CGFloat = 44.0
    var selectionBarHeight: CGFloat = 1.0
    var buttonPadding: CGFloat = 8.0
    let contentSizeOffset: CGFloat = 10.0
    let SELECTED_BUTTON_COLOR = UIColor.blue
    let DEFAULT_BUTTON_COLOR = UIColor.init(red: 143.0/255.0, green: 142.0/255.0, blue: 148.0/255.0, alpha: 1.0)
    let BUTTON_FONT = Fonts.Bold.of(size: 13.0)
    
    // MARK: - Properties
    var titleBarView = UIScrollView()
    var selectionBar = UIView()
    var seprator = UIView()
    var pageViewController: UIPageViewController?
    var pageScrollView: UIScrollView?
    var buttonsFrameArray = [CGRect]()
    var buttonWidth: CGFloat?
    var titleBarButton = UIButton()
    var titleBarDataSource: [String]?
    var currentPageIndex = 0
    var viewFrame : CGRect?
    public var delegate: GenericSwipeViewControllerDelegate?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let frame = viewFrame {
            self.view.frame = frame
        }
        
        titleBarView.layer.shadowColor = UIColor.gray.cgColor
        titleBarView.layer.masksToBounds = false
        titleBarView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        titleBarView.layer.shadowRadius = 0.5
        titleBarView.layer.shadowOpacity = 0.1
        
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageScrollView?.contentInsetAdjustmentBehavior = .automatic
        
        if let startingViewController = viewControllerAtIndex(0) {
            let viewControllers = [startingViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })
            self.pageViewController!.dataSource = self
            self.pageViewController?.delegate = self
            
            if let startingViewController = viewControllerAtIndex(currentPageIndex) {
                let viewControllers = [startingViewController]
                self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })
            }
            self.addChild(self.pageViewController!)
            self.view.addSubview(self.pageViewController!.view)
            
            let pageViewRect = CGRect(x: 0.0, y: titleBarHeight, width: self.view.frame.width, height: self.view.frame.height-titleBarHeight)
            self.pageViewController!.view.frame = pageViewRect
            self.pageViewController!.didMove(toParent: self)
            self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncScrollView()
        setuptitleBar()
    }
    
    override  func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //MARK: - Private Mehtods
    private func setuptitleBar() {
        if self.view.subviews.contains(titleBarView) {
            titleBarView.subviews.forEach({ (view) in
                view.removeFromSuperview()
            })
            titleBarView.layer.removeFromSuperlayer()
            titleBarView.removeFromSuperview()
        }
        
        titleBarView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: titleBarHeight)
        titleBarView.isScrollEnabled = true
        titleBarView.showsHorizontalScrollIndicator = false
        titleBarView.backgroundColor = UIColor.white
        
        setuptitleBarButtons()
        self.view.addSubview(titleBarView)
        
        setUpSeprator()
        setupSelectionBar()
    }
    
    private func setUpSeprator() {
        seprator.frame = CGRect(x: 0.0, y: titleBarHeight, width: UIScreen.main.bounds.width, height: 1.0)
        seprator.backgroundColor = UIColor.gray
        seprator.alpha = 0.3
        titleBarView.addSubview(seprator)
    }
    
    private func setuptitleBarButtons() {
        if let buttonList = titleBarDataSource {
            buttonsFrameArray.removeAll()
            
            for i in 0 ..< buttonList.count {
                let previousButtonX = i > 0 ? buttonsFrameArray[i-1].origin.x : 0.0
                let previousButtonW = i > 0 ? buttonsFrameArray[i-1].size.width : 0.0
                let width:Int
                if (i <= 4) {
                    width = Int(UIScreen.main.bounds.width - 30)/buttonList.count
                } else {
                    width = Int(getWidthForText(buttonList[i]) + buttonPadding)
                }
                
                titleBarButton = UIButton(frame: CGRect(x: previousButtonX + previousButtonW + buttonPadding, y: 0.0, width: CGFloat(width), height: titleBarHeight))
                buttonsFrameArray.append(titleBarButton.frame)
                
                titleBarButton.setTitle(buttonList[i], for: UIControl.State())
                titleBarButton.tag = i
                titleBarButton.titleLabel?.font = kTitleFont
                titleBarButton.setTitleColor(currentPageIndex == i ?  SELECTED_BUTTON_COLOR : DEFAULT_BUTTON_COLOR , for: UIControl.State())
                titleBarButton.addTarget(self, action: #selector(GenericSwipeViewController.didtitleBarButtonTap(_:)), for: .touchUpInside)
                
                titleBarView.addSubview(titleBarButton)
                
                if i == buttonList.count-1 {
                    titleBarView.contentSize = CGSize(width:buttonsFrameArray[i].origin.x + buttonsFrameArray[i].size.width + contentSizeOffset, height: titleBarHeight)
                }
            }
        }
    }
    
    private func setupSelectionBar() {
        UIView.animate(withDuration: 0.1) { [unowned self] in
            self.setupSelectionBarFrame(self.currentPageIndex)
        }
        
        selectionBar.backgroundColor =  SELECTED_BUTTON_COLOR
        selectionBar.alpha = 1.0
        
        titleBarView.addSubview(selectionBar)
    }
    
    private func setupSelectionBarFrame(_ index: Int) {
        if buttonsFrameArray.count > 0 {
            let previousButtonX = index > 0 ? buttonsFrameArray[index-1].origin.x : 0.0
            let previousButtonW = index > 0 ? buttonsFrameArray[index-1].size.width : 0.0
            
            selectionBar.frame = CGRect(x: previousButtonX + previousButtonW + buttonPadding, y: titleBarHeight - selectionBarHeight, width: buttonsFrameArray[index].size.width, height: selectionBarHeight)
        }
    }
    
    private func getWidthForText(_ text: String) -> CGFloat {
        return buttonWidth ?? ceil((text as NSString).size(withAttributes: [NSAttributedString.Key.font: kTitleFont]).width)
    }
    
    private func updateButtonColorOnSelection() {
        for button in titleBarView.subviews {
            if button is UIButton {
                if button.tag == currentPageIndex {
                    (button as! UIButton).setTitleColor( SELECTED_BUTTON_COLOR, for: UIControl.State())
                } else {
                    (button as! UIButton).setTitleColor(DEFAULT_BUTTON_COLOR, for: UIControl.State())
                }
            }
        }
    }
    
    private func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        if titleBarDataSource?.count == 0 || index >= (titleBarDataSource?.count)! {
            return nil
        }
        let viewController = delegate?.didLoadViewControllerAtIndex(index)
        viewController?.view.tag = index
        
        return viewController
    }
    
    private func syncScrollView() {
        for view: UIView in (pageViewController?.view.subviews)! {
            if view is UIScrollView {
                pageScrollView = view as? UIScrollView
                pageScrollView?.delegate = self
            }
        }
    }
    
    //MARK: SEGMENT BUTTON ACTION
    @objc func didtitleBarButtonTap(_ sender: UIButton) {
        let tempIndex = currentPageIndex
        if sender.tag == tempIndex { return }
        let scrollDirection: UIPageViewController.NavigationDirection = sender.tag > tempIndex ? .forward : .reverse
        pageViewController?.setViewControllers([viewControllerAtIndex(sender.tag)!], direction: scrollDirection, animated: true, completion: { (complete) -> Void in
            if complete {
                self.currentPageIndex = sender.tag
                UIView.animate(withDuration: 0.05) { [unowned self] in
                    self.updateButtonColorOnSelection()
                    self.titleBarView.scrollRectToVisible(CGRect(x: self.buttonsFrameArray[self.currentPageIndex].origin.x, y: 0.0,  width: self.buttonsFrameArray[self.currentPageIndex].size.width, height: 44.0), animated: true)
                }
            }
        })
    }
}

//MARK: PAGEVIEWCONTROLLER DATASOURCE
extension GenericSwipeViewController {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        if index == 0 || index == NSNotFound { return nil }
        index -= 1
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        if index == NSNotFound {
            return nil
        }
        index += 1
        if index == titleBarDataSource?.count { return nil }
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let lastVC = pageViewController.viewControllers?.last
            {
                currentPageIndex = lastVC.view.tag
            }
            UIView.animate(withDuration: 0.1) { [unowned self] in
                self.setupSelectionBarFrame(self.currentPageIndex)
                self.updateButtonColorOnSelection()
                self.titleBarView.scrollRectToVisible(CGRect(x: self.buttonsFrameArray[self.currentPageIndex].origin.x, y: 0.0,  width: self.buttonsFrameArray[self.currentPageIndex].size.width, height: 44.0), animated: true)
            }
        }
    }
}

//MARK: SCROLLVIEW DELEGATES
extension GenericSwipeViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xFromCenter:CGFloat = self.view.frame.size.width-scrollView.contentOffset.x
        let xCoor = buttonsFrameArray[currentPageIndex].origin.x;
        UIView.animate(withDuration: 0.05) { [unowned self] in
            self.selectionBar.frame = CGRect(x: xCoor-xFromCenter/kSelectionBarSwipeConstant, y: self.selectionBar.frame.origin.y, width: self.buttonsFrameArray[self.currentPageIndex].size.width, height: self.selectionBar.frame.size.height)
        }
    }
    
    func userInteraction(enabled isEnabled: Bool) {
        self.titleBarView.isUserInteractionEnabled = isEnabled
        self.pageScrollView?.isScrollEnabled = isEnabled
    }
}
