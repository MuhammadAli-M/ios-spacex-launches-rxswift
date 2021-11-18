//
//  RocketViewModel.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 18/11/2021.
//

import Foundation

struct RocketViewModel{
    let name: String
    let description: String
    let iconData: Data?
    let link: URL?
    
    init(_ model: Rocket){
        name = model.name
        description = model.description
        iconData = nil
        link = URL(string: model.linkString) 
    }
}
