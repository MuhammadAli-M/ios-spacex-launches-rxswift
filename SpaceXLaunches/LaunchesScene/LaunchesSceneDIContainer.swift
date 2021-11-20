//
//  LaunchesSceneDIContainer.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 18/11/2021.
//

import UIKit

final class LaunchesSceneDIContainer {
    
    init(){
        
    }
}

extension LaunchesSceneDIContainer: LaunchesSceneDependencies{
    // Views
    func makeLaunchesListVC(router: LaunchesListRouter) -> LaunchesListVC {
        
        let viewModel = DefaultLaunchesListViewModel(router: router)
        // TODO: setup the view model
        let vc = LaunchesListVC.create(with: viewModel)
        return vc
    }
    
    func makeLauncheDetailsVC(launch: Launch,
                              router: LaunchDetailsRouter) -> LaunchDetailsVC {
        let viewModel = DefaultLaunchDetailsViewModel(launch: launch, router: router)
        // TODO: setup the view model
        let vc = LaunchDetailsVC.create(with: viewModel)
        return vc
    }
    
    // Coordinator
    func makeLaunchesSceneFlowCoordinator(navigationController: UINavigationController) -> LaunchesSceneFlowCoordinator{
        return LaunchesSceneFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}
