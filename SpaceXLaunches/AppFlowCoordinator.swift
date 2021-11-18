//
//  AppFlowCoordinator.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 18/11/2021.
//

import UIKit

final class AppFlowCoordinator{
    
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer){
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        self.navigationController.navigationBar.prefersLargeTitles = true
        let flow = appDIContainer.makeLaunchesSceneDIContainer().makeLaunchesSceneFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}



