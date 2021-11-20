//
//  LaunchesListVC.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 16/11/2021.
//  Copyright (c) 2021 All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LaunchesListVC: UIViewController, StoryboardInstantiable {
    @IBOutlet weak var yearSegmentedControl: UISegmentedControl!
    @IBOutlet weak var eventSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: LaunchesListViewModel!
    private var bag = DisposeBag()

    class func create(with viewModel: LaunchesListViewModel) -> LaunchesListVC {
        let vc = LaunchesListVC.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableView.automaticDimension
        bind(to: viewModel)
    }

    
    private func setupYearsAndEvents(){
        let years = viewModel.availableYears
        let events = viewModel.availableEvents
        setupSegmentControl(yearSegmentedControl, withItems: years)
        setupSegmentControl(eventSegmentedControl, withItems: events)
        [yearSegmentedControl,eventSegmentedControl].forEach{
            $0?.selectedSegmentIndex = 0
        }
    }
    
    private func setupSegmentControl(_ segControl: UISegmentedControl, withItems items: [String]) {
        segControl.removeAllSegments()
        items.enumerated().forEach() { item in
            segControl.insertSegment(with: nil, at: item.offset, animated: false)
            segControl.setTitle(item.element, forSegmentAt: item.offset)
        }
    }

    
    func bind(to viewModel: LaunchesListViewModel) {
        
        viewModel.title.subscribe { [weak self] titleString in
            
            self?.title = titleString
        }.disposed(by: bag)
                                
        
        viewModel.launches.bind(to: tableView.rx.items(cellIdentifier: LaunchTableViewCell.Id,
                                                    cellType: LaunchTableViewCell.self)) { row , item , cell in
            cell.configure(viewModel: item)
        }.disposed(by: bag)

        
        tableView.rx.itemSelected.bind { [weak self] indexPath in
            debugLog("selected:: index: \(indexPath.row)")
            self?.viewModel.launchSelected.onNext(indexPath.row)
        }.disposed(by: bag)


        Observable.combineLatest( yearSegmentedControl.rx.selectedSegmentIndex,
                                  eventSegmentedControl.rx.selectedSegmentIndex).subscribe(onNext: { [weak self] year, event in
            debugLog("selected:: year: \(year), event: \(event)")
            self?.viewModel.yearAndEventSelected.onNext((yearIndex: year, eventIndex: event))
        }).disposed(by: bag)
    }
}
