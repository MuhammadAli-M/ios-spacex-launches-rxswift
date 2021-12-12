//
//  AppDIContainer.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 18/11/2021.
//

import Foundation

final class AppDIContainer{
    
    func makeLaunchesSceneDIContainer() -> LaunchesSceneDIContainer{
        return LaunchesSceneDIContainer()
    }
}
