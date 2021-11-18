//
//  LaunchesSceneDIContainer.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 18/11/2021.
//

import UIKit

// TODO: Remove it after renaming
typealias LaunchesListVC = LaunchesListViewController

// TODO: Delete after finish
class LauncheDetailsVC: UIViewController{
    
}

final class LaunchesSceneDIContainer {
    
    init(){
        
    }
}

extension LaunchesSceneDIContainer: LaunchesSceneDependencies{
    // Views
    func makeLaunchesListVC(router: LaunchesListRouter) -> LaunchesListVC {
        
        let viewModel = DefaultLaunchesListViewModel()
        // TODO: setup the view model
        let vc = LaunchesListViewController.create(with: viewModel)
        return vc
    }
    
    func makeLauncheDetailsVC(launch: Launch,
                              router: LauncheDetailsRouter) -> LauncheDetailsVC {
        // TODO: Fix it
        return LauncheDetailsVC()
    }
    
    // Coordinator
    func makeLaunchesSceneFlowCoordinator(navigationController: UINavigationController) -> LaunchesSceneFlowCoordinator{
        return LaunchesSceneFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}
