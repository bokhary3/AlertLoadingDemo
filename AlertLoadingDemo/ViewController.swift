//
//  ViewController.swift
//  AlertLoadingDemo
//
//  Created by Elsayed Hussein on 22/08/2023.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Variables
    var loadingAction: UIAlertAction?
    var alert: UIAlertController?
    var stackView: UIStackView?
    var viewToRemove: UIView?
    
    //MARK: - Outlets
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Utils.alert("Release this version", "It will be released on app store", showCancel: true, self) { alert in
            // do your task
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                alert?.dismiss(animated: true)
            }
        }
    }
}

extension ViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
