//
//  LaunchViewModel.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 19/11/2021.
//

import Foundation
import RxSwift
import RxCocoa

struct LaunchViewModel{
    let name: String
    let number: String
    let date: String
    let details: String
    let iconData: Observable<UIImage?>
    let upcoming: Bool
    
    init(_ model: Launch){
        name = model.name
        number = String(model.number)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy HH:mm:ss"
        date = formatter.string(from: model.date)
        details = model.details
        if model.upcoming{
            iconData =  GetImageService.shared.getImage(path: model.icon).map { UIImage(data: $0)} // TODO: verfiy it
        }else{
            iconData = .of(nil)
        }
        upcoming = model.upcoming
    }
}