//
//  LaunchesListViewModel.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 16/11/2021.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift
// TODO: assure no capture for self

protocol LaunchesListViewModelInput {
    func viewDidLoad()
}

protocol LaunchesListViewModelOutput {
    var yearAndEventSelected: PublishSubject<(yearIndex: Int ,eventIndex: Int )> { get }
    var launches: PublishSubject<[LaunchViewModel]> { get }
    var availableYears: [String] { get }
    var availableEvents: [String] { get }
    func showLaunchDetails(at index: Int)
}

protocol LaunchesListViewModel: LaunchesListViewModelInput, LaunchesListViewModelOutput { }

class DefaultLaunchesListViewModel: LaunchesListViewModel {
    
    init(){
        setupBindings()
    }
    
    var launches = PublishSubject<[LaunchViewModel]>()
    var allLaunches = PublishSubject<[Launch]>()
    var yearAndEventSelected = PublishSubject<(yearIndex: Int ,eventIndex: Int )>()
    let bag = DisposeBag()
    
    func setupBindings(){
        
        yearAndEventSelected.subscribe { (yearIndex: Int, eventIndex: Int) in
            
            GetLaunchesService.shared.getLaunches()
                .map{ launches in
                
                    debugLog("lauches: \(launches)")
                    return launches.map{ $0}}
                
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
                            return launch.upcoming == upcomping && launch.date.contains(self.availableYears[yearIndex]) == true}
                    
                        .map{LaunchViewModel($0)}
                    
                    debugLog("filtered: \(filtered)")
                    return filtered
                    
                }.bind(to: self.launches)
            
                .disposed(by: self.bag)
        }
        .disposed(by: self.bag)
    }
    
    // MARK: - OUTPUT
    var availableYears: [String] {
        ["2020", "2021"]
    }
    
    var availableEvents: [String] {
        ["Successful", "Upcoming"]
    }
    
    func showLaunchDetails(at index: Int) {
        
    }
}

// MARK: - INPUT. View event methods
extension DefaultLaunchesListViewModel {
    func viewDidLoad() {
        
    }
}



