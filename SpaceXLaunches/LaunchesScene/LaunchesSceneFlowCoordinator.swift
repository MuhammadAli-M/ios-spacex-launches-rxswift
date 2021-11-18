//
//  LaunchesSceneFlowCoordinator.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 18/11/2021.
//

import UIKit

struct LaunchesListRouter {
    let showLauncheDetails: (_ : Launch) -> Void
}

struct LauncheDetailsRouter {
    let showLaunchesList: () -> Void
}

// MARK: - LaunchesSceneFlowCoordinator
protocol LaunchesSceneDependencies{
    
    func makeLaunchesListVC(router : LaunchesListRouter) -> LaunchesListVC
    func makeLauncheDetailsVC(launch: Launch,
                              router : LauncheDetailsRouter) -> LauncheDetailsVC
}

final class LaunchesSceneFlowCoordinator{
    
    private weak var navigationController: UINavigationController?
    private var dependencies: LaunchesSceneDependencies
    
    init(navigationController: UINavigationController,
         dependencies: LaunchesSceneDependencies){
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {

        let router = LaunchesListRouter(showLauncheDetails: showLauncheDetails)
        let vc = dependencies.makeLaunchesListVC(router: router)
        navigationController?.pushViewController(vc, animated: false)

    }
    
    // LaunchesList router
    func showLauncheDetails(_ launch: Launch) -> Void{
        let router = LauncheDetailsRouter(showLaunchesList: showLaunchesList)
        let vc = dependencies.makeLauncheDetailsVC(launch: launch ,
                                                   router: router)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // LauncheDetails router
    func showLaunchesList(){
        navigationController?.popViewController(animated: true)
    }
}
