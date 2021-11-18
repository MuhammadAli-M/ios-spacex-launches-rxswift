//
//  LaunchDetailsVC.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 18/11/2021.
//  Copyright (c) 2021 All rights reserved.
//

import UIKit

class LaunchDetailsViewController: UIViewController, StoryboardInstantiable {
    
    var viewModel: LaunchDetailsViewModel!
    
    class func create(with viewModel: LaunchDetailsViewModel) -> LaunchDetailsViewController {
        let vc = LaunchDetailsViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    func bind(to viewModel: LaunchDetailsViewModel) {

    }
}
