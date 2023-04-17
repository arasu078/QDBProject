//
//  DetailViewController.swift
//  QDBProject
//
//  Created by Murugesan, Ponnarasu (Cognizant) on 13/04/23.
//

import Foundation
import UIKit

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    var post: Post?
    private let textView = UITextView()
    private let submitButton = UIButton(type: .system)
    private var isEditingEnabled = false {
        didSet {
            textView.isEditable = isEditingEnabled
            textView.textColor = isEditingEnabled ? .darkText : .lightGray
            submitButton.isHidden = isEditingEnabled
        }
    }
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = AppConstants.detailNavigationTitle
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: AppConstants.editButtonTitle, style: .plain, target: self, action: #selector(editButtonTapped))
        configureTextView()
        configureSubmitButton()
        addConstrains()
        isEditingEnabled = false
        submitButton.isHidden = true
    }
    
    // MARK: - Private Methods
    private func configureTextView() {
        textView.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 200)
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 5.0
        textView.text = post?.body
        view.addSubview(textView)
    }
    
    private func configureSubmitButton() {
        submitButton.setTitle(AppConstants.submitButtoTitle, for: .normal)
        submitButton.backgroundColor = .white
        submitButton.layer.cornerRadius = 4.0
        submitButton.layer.borderWidth = 1.0
        submitButton.layer.borderColor = UIColor.systemBlue.cgColor
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        view.addSubview(submitButton)
    }
    
    private func addConstrains() {
        let horizontalConstraint = NSLayoutConstraint(item: submitButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16.0),
            submitButton.widthAnchor.constraint(equalToConstant: 100),
            submitButton.heightAnchor.constraint(equalToConstant: 34.0),
            horizontalConstraint
        ])
    }
    
    //MARK: - Selectors
    @objc private func editButtonTapped() {
        isEditingEnabled = !isEditingEnabled
        if isEditingEnabled {
            navigationItem.rightBarButtonItem?.title = AppConstants.doneButtonTitle
            textView.becomeFirstResponder()
        } else {
            navigationItem.rightBarButtonItem?.title = AppConstants.doneButtonTitle
            textView.resignFirstResponder()
        }
    }
    
    @objc private func submitButtonTapped() {
        guard var post = self.post, let text = textView.text else {
            return
        }
        post.body = text
        APIConnector().putPost(payload: post)
    }
}
