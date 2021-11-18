//
//  GetRocketService.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 18/11/2021.
//

import Foundation
import RxSwift

protocol RocketService: Service {
}

extension RocketService {
    var baseUrl:String { "https://api.spacexdata.com/" }
}

enum GetRocketFailureReason: Int, Error {
    case invalidURL = 1000
    case notFound = 1001
}

class GetRocketService: RocketService{
    
    static let shared = GetRocketService()
        
    func getRocket(id rocketID: RocketID) -> Observable<Rocket> {
        
        return Observable.create { [weak self] (observer) -> Disposable in
            guard let `self` = self else { return Disposables.create() }
            
            let  endpoint = Endpoint(baseUrl: self.baseUrl,
                                     path: "v4/rockets/\(rocketID)",
                                     queries: nil)
            
            guard let url = endpoint.url else {
                observer.onError(GetRocketFailureReason.invalidURL)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                
                guard let data = data else {
                    observer.onError(error ?? GetRocketFailureReason.notFound)
                    return
                }
                
                do {
                    
                    let rocketResponse = try newJSONDecoder().decode(GetRocketResponseElement.self, from: data)

                    observer.onNext(rocketResponse.toDomain())
                    observer.onCompleted()
                } catch (let error){
                    observer.onError(error)
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    
    enum GetRocketQueryKey: String, QueryKey{
        case id
        
        var description: String { self.rawValue }
    }
}

extension GetRocketResponseElement{
    func toDomain() -> Rocket{
        Rocket(name: self.name,
               description: self.getRocketResponseDescription,
               iconUrlString: self.flickrImages.first,
               linkString: self.wikipedia)
    }
}
// MARK: - GetRocketResponseElement
struct GetRocketResponseElement: Codable {
    let height, diameter: Diameter?
    let mass: Mass?
    let firstStage: FirstStage?
    let secondStage: SecondStage?
    let engines: Engines?
    let landingLegs: LandingLegs?
    let payloadWeights: [PayloadWeight]?
    let flickrImages: [String]
    let name, type: String
    let active: Bool
    let stages, boosters, costPerLaunch, successRatePct: Int?
    let firstFlight, country, company: String?
    let wikipedia: String
    let getRocketResponseDescription, id: String

    enum CodingKeys: String, CodingKey {
        case height, diameter, mass
        case firstStage = "first_stage"
        case secondStage = "second_stage"
        case engines
        case landingLegs = "landing_legs"
        case payloadWeights = "payload_weights"
        case flickrImages = "flickr_images"
        case name, type, active, stages, boosters
        case costPerLaunch = "cost_per_launch"
        case successRatePct = "success_rate_pct"
        case firstFlight = "first_flight"
        case country, company, wikipedia
        case getRocketResponseDescription = "description"
        case id
    }
}

// MARK: - Diameter
struct Diameter: Codable {
    let meters, feet: Double?
}

// MARK: - Engines
struct Engines: Codable {
    let isp: ISP
    let thrustSeaLevel, thrustVacuum: Thrust
    let number: Int
    let type, version: String
    let layout: String?
    let engineLossMax: Int?
    let propellant1, propellant2: String
    let thrustToWeight: Double

    enum CodingKeys: String, CodingKey {
        case isp
        case thrustSeaLevel = "thrust_sea_level"
        case thrustVacuum = "thrust_vacuum"
        case number, type, version, layout
        case engineLossMax = "engine_loss_max"
        case propellant1 = "propellant_1"
        case propellant2 = "propellant_2"
        case thrustToWeight = "thrust_to_weight"
    }
}

// MARK: - ISP
struct ISP: Codable {
    let seaLevel, vacuum: Int

    enum CodingKeys: String, CodingKey {
        case seaLevel = "sea_level"
        case vacuum
    }
}

// MARK: - Thrust
struct Thrust: Codable {
    let kN, lbf: Int
}

// MARK: - FirstStage
struct FirstStage: Codable {
    let thrustSeaLevel, thrustVacuum: Thrust
    let reusable: Bool
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSEC: Int?

    enum CodingKeys: String, CodingKey {
        case thrustSeaLevel = "thrust_sea_level"
        case thrustVacuum = "thrust_vacuum"
        case reusable, engines
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSEC = "burn_time_sec"
    }
}

// MARK: - LandingLegs
struct LandingLegs: Codable {
    let number: Int
    let material: String?
}

// MARK: - Mass
struct Mass: Codable {
    let kg, lb: Int
}

// MARK: - PayloadWeight
struct PayloadWeight: Codable {
    let id, name: String
    let kg, lb: Int
}

// MARK: - SecondStage
struct SecondStage: Codable {
    let thrust: Thrust
    let payloads: Payloads
    let reusable: Bool
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSEC: Int?

    enum CodingKeys: String, CodingKey {
        case thrust, payloads, reusable, engines
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSEC = "burn_time_sec"
    }
}

// MARK: - Payloads
struct Payloads: Codable {
    let compositeFairing: CompositeFairing
    let option1: String

    enum CodingKeys: String, CodingKey {
        case compositeFairing = "composite_fairing"
        case option1 = "option_1"
    }
}

// MARK: - CompositeFairing
struct CompositeFairing: Codable {
    let height, diameter: Diameter
}
