//
//  Launch.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 20/11/2021.
//

import Foundation

typealias RocketID = String

struct Launch{
    let name: String
    let number: Int
    let date: Date
    let details: String
    let icon: String?
    let upcoming: Bool
    let successful: Bool
    let rocketID: RocketID
}
