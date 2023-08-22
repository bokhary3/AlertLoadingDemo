//
//  Utils.swift
//  AlertLoadingDemo
//
//  Created by Elsayed Hussein on 22/08/2023.
//

import UIKit

class Utils {
    //MARK: - Variables
    private static var loadingAction: UIAlertAction?
    private static var stackView: UIStackView?
    private static var viewToRemove: UIView?
    private static var alertClosure: ((UIAlertController?) -> Void)?
    private static var okTitle: String?
    private static var viewController: UIViewController?
    private static var alert: UIAlertController?
    //MARK: - Actions
    @objc static func loadingAction(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            loadingAction?.isEnabled = false
            startLoading()
            alertClosure?(alert)
        default:
            return
        }
    }
    
    //MARK: - Methods
    static func alert(_ title: String, _ message: String, showCancel: Bool = false, okTitle: String = "Ok", _ viewController: UIViewController?, alertClosure: ((UIAlertController?) -> Void)? = nil) {
        self.okTitle = okTitle
        self.alertClosure = alertClosure
        self.alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        loadingAction = UIAlertAction(title: okTitle, style: .default)
        if let action = self.loadingAction {
            alert?.addAction(action)
        }
        if showCancel {
            alert?.addAction(.init(title: "Cancel", style: .cancel))
        }
        if let alert = alert {
            viewController?.present(alert, animated: true) {
                self.visitAllViews(in: alert.view)
            }
        }
    }
    
    /// Search about the container view of action which you want to replace it with loader
    /// - Parameter view: parent view
    /// - Returns: return true if this view contains action view
    private static func isLoadingActionView(_ view: UIView) -> Bool {
        for subview in view.subviews {
            if let label = subview as? UILabel, label.text == self.okTitle {
                return true
            }
            return isLoadingActionView(subview)
        }
        return false
    }
    private static func visitAllViews(in view: UIView) {
        for subview in view.subviews {
            if let stackView = subview as? UIStackView {
                self.stackView = stackView
                for subStackView in stackView.arrangedSubviews {
                    if isLoadingActionView(subStackView) {
                        viewToRemove = subStackView
                        let constraint = subStackView.constraints.first(where:  { $0.firstAttribute == .width  })
                        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(loadingAction(sender:)))
                        gestureRecognizer.minimumPressDuration = 0.0
                        
                        // if alert was presenting in scroll view, gesture will not work until set this delegate
                        gestureRecognizer.delegate = viewController as? UIGestureRecognizerDelegate
                        subStackView.addGestureRecognizer(gestureRecognizer)
                    }
                }
            } else {
                // Recursively visit subviews of the current subview
                visitAllViews(in: subview)
            }
        }
    }

    private static func startLoading() {
        let constraint = viewToRemove?.constraints.first(where:  { $0.firstAttribute == .width })
        if let viewToRemove = viewToRemove {
            stackView?.removeArrangedSubview(viewToRemove)
            viewToRemove.removeFromSuperview()
        }
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.widthAnchor.constraint(equalToConstant: constraint?.constant ?? 0).isActive = true
        indicator.color = .lightGray
        indicator.startAnimating()
        stackView?.addArrangedSubview(indicator)
    }
}
