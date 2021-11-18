//
//  LaunchesListViewModel.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 16/11/2021.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
// TODO: assure no capture for self

protocol LaunchesListViewModelInput {
    func viewDidLoad()
}

protocol LaunchesListViewModelOutput {
    var yearAndEventSelected: PublishSubject<(yearIndex: Int ,eventIndex: Int )> { get }
    var launchSelected: PublishSubject<(Int)> { get }

    var launches: PublishSubject<[LaunchViewModel]> { get }
    var title: BehaviorRelay<String> { get }
    var availableYears: [String] { get }
    var availableEvents: [String] { get }
}

protocol LaunchesListViewModel: LaunchesListViewModelInput, LaunchesListViewModelOutput { }

class DefaultLaunchesListViewModel: LaunchesListViewModel {
    private var router: LaunchesListRouter
    init(router: LaunchesListRouter){
        self.router = router
        setupBindings()
    }
    
    let launches = PublishSubject<[LaunchViewModel]>()
    let allLaunches = PublishSubject<[Launch]>()
    let title: BehaviorRelay<String> = .init(value: "SpaceX Launches")
    private var filteredLaunches = [Launch]()

    var yearAndEventSelected = PublishSubject<(yearIndex: Int ,eventIndex: Int )>()
    var launchSelected = PublishSubject<(Int)>()

    private let bag = DisposeBag()
    
    func setupBindings(){
        
        yearAndEventSelected.subscribe { (yearIndex: Int, eventIndex: Int) in
            
            GetLaunchesService.shared.getLaunches()
                .map{ launches in
                
                    debugLog("lauches: \(launches)")
                    return launches.map{ $0} }
                
                .subscribe(
                    onNext: { [weak self] models in
                        
                        self?.allLaunches.onNext(models)},
                    
                    onError: { [weak self] error in
                        
                        errorLog("Got an error: \(error)")
                        self?.allLaunches.onNext([])
                    })
            
                .disposed(by: self.bag)
            
            
            self.allLaunches
                .map { launches in
                    
                    let upcomping = self.availableEvents[eventIndex] == "Upcoming"
                    
                    let filtered = launches
                        .filter{ launch in
                            return launch.upcoming == upcomping && launch.date.description.contains(self.availableYears[yearIndex]) == true}
                    
                    self.filteredLaunches = filtered
                    
                    let filteredViewModels = filtered
                        .map{LaunchViewModel($0)}
                    
                    debugLog("filtered: \(filtered)")
                    return filteredViewModels
                    
                }.bind(to: self.launches)
            
                .disposed(by: self.bag)
        }
        .disposed(by: self.bag)
        
        
        self.launchSelected.subscribe { [weak self] index in
            guard let `self` = self else { return }
            
            guard self.filteredLaunches.indices.contains(index) else {return}

            self.router.showLaunchDetails(self.filteredLaunches[index])
            
        } onError: { error in
            
        } onCompleted: {
            
        }.disposed(by: self.bag)

        
    }
    
    // MARK: - OUTPUT
    var availableYears: [String] {
        ["2020", "2021"]
    }
    
    var availableEvents: [String] {
        ["Successful", "Upcoming"]
    }
}

// MARK: - INPUT. View event methods
extension DefaultLaunchesListViewModel {
    func viewDidLoad() {
        
    }
}



