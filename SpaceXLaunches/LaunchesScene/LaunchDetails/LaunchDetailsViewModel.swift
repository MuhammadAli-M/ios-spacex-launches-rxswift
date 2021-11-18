//
//  LaunchDetailsViewModel.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 18/11/2021.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol LaunchDetailsViewModelInput {
    func viewDidLoad()
    func backBtnTapped()
}

protocol LaunchDetailsViewModelOutput {
    var rocketViewModel: BehaviorRelay<RocketViewModel?> { get}
}

protocol LaunchDetailsViewModel: LaunchDetailsViewModelInput, LaunchDetailsViewModelOutput { }

class DefaultLaunchDetailsViewModel: LaunchDetailsViewModel {
    
    let rocketViewModel: BehaviorRelay<RocketViewModel?>
    
    private let router: LaunchDetailsRouter
    private let launch: Launch
    private let bag = DisposeBag()

    init(launch: Launch, router: LaunchDetailsRouter){
        self.launch = launch
        self.router = router
        self.rocketViewModel = .init(value: nil)
        setupBindings()
        getRocketDetails()
    }
    
    func setupBindings(){
        
        // TODO: bind the service with the model
        
    }
    
    func getRocketDetails(){
        GetRocketService.shared.getRocket(id: launch.rocketID)
            .subscribe(
                onNext: { [weak self] rocket in
                    
                    self?.rocketViewModel.accept( RocketViewModel(rocket) )}
                
                , onError: { [weak self] error in

                    errorLog("Got an error: \(error)")
                    self?.rocketViewModel.accept( nil )
                    
                })
            .disposed(by: self.bag)

    }
    // MARK: - OUTPUT

    
}

// MARK: - INPUT. View event methods
extension DefaultLaunchDetailsViewModel {
    func viewDidLoad() {
    }
    
    func backBtnTapped(){
        router.showLaunchesList()
    }
}
}
