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
}

protocol LaunchesListViewModelOutput {
    var yearAndEventSelected: PublishSubject<(yearIndex: Int ,eventIndex: Int )> { get }
    var launchSelected: PublishSubject<(Int)> { get }

    var launches: BehaviorRelay<[LaunchViewModel]> { get }
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
    
    let launches = BehaviorRelay<[LaunchViewModel]>(value: [])
    let title: BehaviorRelay<String> = .init(value: "SpaceX Launches")
    private var filteredLaunches = [Launch]()
    private var allLaunches = [Launch]()
    var yearAndEventSelected = PublishSubject<(yearIndex: Int ,eventIndex: Int )>()
    var launchSelected = PublishSubject<(Int)>()

    private let bag = DisposeBag()
    
    func setupBindings(){
        
        yearAndEventSelected.subscribe { [weak self] (yearIndex: Int, eventIndex: Int) in
            guard let `self` = self else { return }
            
            GetLaunchesService.shared.getLaunches()
            
                .throttle(.seconds(5), scheduler: ConcurrentMainScheduler.instance)
            
                .flatMapLatest({ [weak self] launchesValues -> Observable<[Launch]> in
                    
                    guard let `self` = self else { return Observable.just([])}
                    
                    self.allLaunches = launchesValues
                    debugLog("all lauches: \(launchesValues.count)")

                    let filtered = launchesValues
                        .filter{ launch in
                            let upcomping = self.availableEvents[eventIndex] == "Upcoming"
                            let success = self.availableEvents[eventIndex] == "Successful"
                            return (launch.upcoming == upcomping || launch.successful == success) && launch.date.description.contains(self.availableYears[yearIndex]) == true}
                    
                    self.filteredLaunches = filtered
                                        
                    debugLog("filtered: \(filtered.count)")
                    return Observable.of(filtered)
                })
            
                .subscribe(
                    onNext: { [weak self] models in
                        
                        let viewModels = models.map{ LaunchViewModel($0)}
                        
                        debugLog("viewModels: \(viewModels.count)")
                        
                        self?.launches.accept( viewModels)
                    },
                    onError: { [weak self] error in

                        errorLog("got an error: \(error)")
                        self?.launches.accept( [])
                    })
            
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





