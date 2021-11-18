//
//  LaunchesListViewModel.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 16/11/2021.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

protocol LaunchesListViewModelInput {
    func viewDidLoad()
}

protocol LaunchesListViewModelOutput {
    var launches: PublishSubject<[LaunchViewModel]> { get }
    var availableYears: [String] { get }
    var availableEvents: [String] { get }
    func fetchLaunches(yearIndex: Int ,eventIndex: Int )
    func showLaunchDetails(at index: Int)
}

protocol LaunchesListViewModel: LaunchesListViewModelInput, LaunchesListViewModelOutput { }

class DefaultLaunchesListViewModel: LaunchesListViewModel {
    
    init(){
        
    }
    
    var launches = PublishSubject<[LaunchViewModel]>()
    var allLaunches = PublishSubject<[Launch]>()
    
    let bag = DisposeBag()
    // MARK: - OUTPUT
    var availableYears: [String] {
        ["2020", "2021"]
    }
    
    var availableEvents: [String] {
        ["Successful", "Upcoming"]
    }
    func fetchLaunches(yearIndex: Int ,eventIndex: Int ){
//        let itemViewModels = [
//            LaunchViewModel(name: "Test name",
//                            number: "213",
//                            date: "2021-11-21 10:12:00",
//                            details: "Engine failure at 33 seconds and loss of vehicle",
//                            iconData: nil,
//                            upcoming: false)
//        ]
//
//        launches.onNext(itemViewModels)
//        launches.onCompleted()
        
        GetLaunchesService.shared.getLaunches().map{ launches in
                    debugLog("lauches: \(launches)")
            return launches.map{ $0}
        }.bind(to: allLaunches)
            .disposed(by: bag)
     
        allLaunches.asObservable().map { models in
//            guard let `self` = self else { return false }
            debugLog("models: \(models)")

            let upcomping = self.availableEvents[eventIndex] == "Upcoming"

            let filtered = models.filter { launch in
                return launch.upcoming == upcomping && launch.date.contains(self.availableYears[yearIndex]) == true }.map{LaunchViewModel($0)}
            debugLog("filtered: \(filtered)")
            return filtered
//        }.map{ LaunchViewModel($0) }
        }.subscribe(onNext: { self.launches.onNext($0) })
            .disposed(by: bag)
        
    }
        
//        allLaunches.flatMap { [weak self] observer -> Disposable in
//            guard let `self` = self else { return Disposables.create() }
//
//            let upcomping = self.availableEvents[eventIndex] == "Upcoming"
//
//            return observer.filter{ launch in
//                return launch.upcoming == upcomping && launch.date.contains(self.availableYears[yearIndex]) == true }
//
//        }.bind(to: launches)
        
//        { launches in
//            debugLog("lauches: \(launches)")
//        } onError: { error in
//            errorLog("error \(error.localizedDescription)")
//        } onCompleted: {
//            debugLog("completed")
//        }

//    }
    
    func showLaunchDetails(at index: Int) {
        
    }
}

// MARK: - INPUT. View event methods
extension DefaultLaunchesListViewModel {
    func viewDidLoad() {
        
    }
}



