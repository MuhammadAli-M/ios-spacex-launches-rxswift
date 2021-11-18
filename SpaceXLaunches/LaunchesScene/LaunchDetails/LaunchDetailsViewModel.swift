//
//  LaunchDetailsViewModel.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 18/11/2021.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation

protocol LaunchDetailsViewModelInput {
    func viewDidLoad()
}

protocol LaunchDetailsViewModelOutput {
    
}

protocol LaunchDetailsViewModel: LaunchDetailsViewModelInput, LaunchDetailsViewModelOutput { }

class DefaultLaunchDetailsViewModel: LaunchDetailsViewModel {
    
    // MARK: - OUTPUT

}

// MARK: - INPUT. View event methods
extension DefaultLaunchDetailsViewModel {
    func viewDidLoad() {
    }
}
