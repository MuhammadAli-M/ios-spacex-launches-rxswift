//
//  LaunchDetailsVC.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 18/11/2021.
//  Copyright (c) 2021 All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LaunchDetailsVC: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var launchImageView: UIImageView!
    @IBOutlet weak var link: UILabel!
    @IBOutlet weak var rocketdescription: UILabel!
        
    var viewModel: LaunchDetailsViewModel!
    
    private var bag = DisposeBag()

    
    class func create(with viewModel: LaunchDetailsViewModel) -> LaunchDetailsVC {
        let vc = LaunchDetailsVC.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: setup outlets
        self.navigationItem.hidesBackButton = true
        let customBackButton = UIBarButtonItem(title: "＜ Back", style: .plain, target: self, action: #selector(backBtnTapped))
           self.navigationItem.leftBarButtonItem = customBackButton
        
        link.textColor = .systemBlue
        link.attributedText = "".underLined
        bind(to: viewModel)
    }
    
    func bind(to viewModel: LaunchDetailsViewModel) {
        
        viewModel.rocketViewModel
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] rocketViewModel in
                debugLog("rocket model updated")
                guard let `self` = self else { return }
                
                guard let rocketViewModel = rocketViewModel else { return }
    
                self.title = rocketViewModel.name
                self.link.text = rocketViewModel.link?.absoluteString
                self.rocketdescription.text = rocketViewModel.description
                rocketViewModel.iconData.subscribe(onNext: { [weak self] image in
                    guard let `self` = self else { return }
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.launchImageView.image = image
                    }
                })
                    .disposed(by: self.bag)
            
            }, onError: { [weak self] error in

                errorLog("error from rocketViewModel: \(error.localizedDescription)")

                self?.showAlert(title: "Error",
                               message: error.localizedDescription,
                               preferredStyle: .alert) {
                    // TODO: back to launches
                }

            }, onCompleted: { })
            
            .disposed(by: bag)
    }
    
    // TODO: Fix to be RX
    @objc func backBtnTapped(){
        viewModel.backBtnTapped()
    }
}


extension String {

    var underLined: NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }

}
