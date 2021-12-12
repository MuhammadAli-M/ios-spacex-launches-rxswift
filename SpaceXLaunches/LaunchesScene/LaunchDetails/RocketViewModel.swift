//
//  RocketViewModel.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 18/11/2021.
//

import Foundation
import RxSwift
import RxCocoa
struct RocketViewModel{
    let name: String
    let description: String
    let iconData: Observable<UIImage?>
    let link: URL?
    
    init(_ model: Rocket){
        name = model.name
        description = model.description
        iconData =  GetImageService.shared.getImage(path: model.iconUrlString).map { UIImage(data: $0)}
        link = URL(string: model.linkString) 
    }
}
