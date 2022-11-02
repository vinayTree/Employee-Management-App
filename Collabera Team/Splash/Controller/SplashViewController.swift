//
//  ViewController.swift
//  Collabera Team
//
//  Created by vinay kumar bg on 30/10/22.
//

import UIKit
import RxSwift

class SplashViewController: UIViewController {
    
    weak var coordinator: SplashCoordinator?

    private lazy var splashView = SplashView()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .inactiveColor
        navigationController?.navigationBar.isHidden = true
                
        setupNotificationObservers()
        setupSplashView()
        setupObservers()
    }
    
    /// notifie if user leaves app, after re-entering make transition to next page
    private func setupNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationEnteringForeground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func handleNotificationEnteringForeground() {
        splashView.animateTransitionLayer()
    }
    
    private func setupSplashView() {
        view.addSubview(splashView)
        splashView.anchorFillSuperview()
    }
    
    /// observe when to transit to next screen
    private func setupObservers() {
        splashView.startTransitionOberver.observeOn(MainScheduler.instance).subscribe(onCompleted: { [weak self] in
            self?.startTransition()
        }).disposed(by: self.disposeBag)
    }

    @objc private func startTransition() {
        coordinator?.parentCoordinator?.navigateToLoginViewController()
    }

}



