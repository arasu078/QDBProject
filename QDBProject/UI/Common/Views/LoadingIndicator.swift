//
//  LoadingIndicator.swift
//  QDBProject
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 13/04/23.
//

import Foundation
import UIKit
/// Singleton class which is used for hide and show loading Indicator throughout the app.
class LoadingIndicator {
    
    static let shared = LoadingIndicator()
    
    private var activityIndicator: UIActivityIndicatorView?
    private var backgroundView: UIView?
    
    private init() { }
    
    func show() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else  {
                return
            }
            
            let backgroundView = UIView(frame: window.bounds)
            backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            window.addSubview(backgroundView)
            self.backgroundView = backgroundView
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.center = window.center
            activityIndicator.color = .white
            window.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            self.activityIndicator = activityIndicator
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
            self.activityIndicator = nil
            
            self.backgroundView?.removeFromSuperview()
            self.backgroundView = nil
        }
    }
}
