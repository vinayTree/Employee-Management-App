//
//  EmployeeDetailsCoordinator.swift
//  Collabera Team
//
//  Created by vinay kumar bg on 30/10/22.
//

import UIKit

class EmployeeDetailsCoordinator: Coordinator {

    weak var parentCoordinator: MainCoordinator?
    
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {

    }
    
}



