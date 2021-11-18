//
//  LaunchesListViewController.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 16/11/2021.
//  Copyright (c) 2021 All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LaunchesListViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet weak var yearSegmentedControl: UISegmentedControl!
    @IBOutlet weak var eventSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: LaunchesListViewModel!
    private var bag = DisposeBag()

    class func create(with viewModel: LaunchesListViewModel) -> LaunchesListViewController {
        let vc = LaunchesListViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupYearsAndEvents()
        bind(to: viewModel)
        viewModel.fetchLaunches(yearIndex: 0, eventIndex: 0)
    }

    
    func setupYearsAndEvents(){
        let years = viewModel.availableYears
        let events = viewModel.availableEvents
        setupSegmentControl(yearSegmentedControl, withItems: years)
        setupSegmentControl(eventSegmentedControl, withItems: events)
        [yearSegmentedControl,eventSegmentedControl].forEach{
            $0?.selectedSegmentIndex = 0
        }
        
//        yearSegmentedControl.rx.selectedSegmentIndex.changed.
    }
    
    fileprivate func setupSegmentControl(_ segControl: UISegmentedControl, withItems items: [String]) {
        segControl.removeAllSegments()
        items.enumerated().forEach() { item in
            segControl.insertSegment(with: nil, at: item.offset, animated: false)
            segControl.setTitle(item.element, forSegmentAt: item.offset)
        }
    }

    
    func bindTableData(){
        viewModel.launches.bind(to: tableView.rx.items(cellIdentifier: LaunchTableViewCell.Id,
                                                    cellType: LaunchTableViewCell.self)) { row , item , cell in
            cell.configure(viewModel: item)
        }.disposed(by: bag)
        
        // Bind a model selected
        tableView.rx.itemSelected.bind { [weak self] indexPath in
            debugLog("selected:: index: \(indexPath.row)")
            self?.viewModel.showLaunchDetails(at: indexPath.row)
        }.disposed(by: bag)
    }
    
    func bind(to viewModel: LaunchesListViewModel) {
        bindTableData()

        Observable.combineLatest( yearSegmentedControl.rx.selectedSegmentIndex,
                                  eventSegmentedControl.rx.selectedSegmentIndex).subscribe(onNext: { [weak self] year, event in
            debugLog("selected:: year: \(year), event: \(event)")
            self?.viewModel.fetchLaunches(yearIndex: year, eventIndex: event)
            
        }).disposed(by: bag)
    }
    
    @IBAction func yearChanged(_ sender: UISegmentedControl) {
//        debugLog("yearChanged: \(sender.selectedSegmentIndex)")
    }
    
    @IBAction func eventChanged(_ sender: UISegmentedControl) {
//        debugLog("eventChanged: \(sender.selectedSegmentIndex)")
    }
    
}
