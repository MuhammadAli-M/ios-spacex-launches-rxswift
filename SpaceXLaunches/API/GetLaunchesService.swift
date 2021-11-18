//
//  GetLaunchesService.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 16/11/2021.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

protocol Service {
    var baseUrl:String { get }
}

protocol LaunchesService: Service {
    var apiKey: String { get }
}

extension LaunchesService {
    var baseUrl:String { "https://api.spacexdata.com/" }
    var apiKey: String { "2696829a81b1b5827d515ff121700838"}
}

enum GetLaunchesFailureReason: Int, Error {
    case invalidURL = 1000
    case notFound = 1001
}


class GetLaunchesService: LaunchesService{
    
    static let shared = GetLaunchesService()
    
//    func getLaunches() -> Observable<[Launch]> {
//        let observer = Observable.just([Launch(name: "", number: "", date: "", details: "", iconData: nil, upcoming: false)])
////        return Observable.create { [weak self] observer -> Disposable in
////            guard let `self` = self else { return Disposables.create() }
//
//            let  endpoint = Endpoint(baseUrl: self.baseUrl,
//                                 path: "v4/launches",
//                                 queries: nil)
//
//        guard let url = endpoint.url else {
////            observer.onError(GetLaunchesFailureReason.invalidURL)
//            return observer//Disposables.create()
//        }
//
//            return URLSession.shared.rx.data(request: URLRequest(url: url)).map{ data in
//
//                let launchesResponseData = try newJSONDecoder().decode([GetLaunchesResponseElement].self, from: data)
//                let launches = launchesResponseData.map{ $0.toDomain() }
//                return launches
//
//            }.observe(on: MainScheduler.asyncInstance)
////        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
////
////
////            if let error = error {
////                errorLog("requesting \(url.absoluteString) , error : \(error.localizedDescription )")
////                observer.onError(error)
////                return
////            }
////
////            guard let data = data else{
////                errorLog("requesting \(url.absoluteString) , error : \(error?.localizedDescription ?? " ")")
////                observer.onError(error ?? GetLaunchesFailureReason.notFound)
////                return
////            }
////
////            do{
////                let launchesResponseData = try newJSONDecoder().decode(GetLaunchesResponse.self, from: data)
////                let launches = launchesResponseData.docs.map{ $0.toDomain() }
////                observer.onNext(launches)
////                debugLog("recieved \(launchesResponseData.docs.count) launches")
////            }catch{
////                observer.onError(error)
////                errorLog("while json parsing, error : \(error.localizedDescription)")
////            }
////        }
////            task.resume()
////
////            return Disposables.create()
////        }
//    }
    
    
    func getLaunches() -> Observable<[Launch]> {
        
        return Observable.create { [weak self] (observer) -> Disposable in
            guard let `self` = self else { return Disposables.create() }
            
            let  endpoint = Endpoint(baseUrl: self.baseUrl,
                                     path: "v4/launches",
                                     queries: nil)
            
            guard let url = endpoint.url else {
                observer.onError(GetLaunchesFailureReason.invalidURL)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                
                guard let data = data else {
                    observer.onError(error ?? GetLaunchesFailureReason.notFound)
                    return
                }
                
                do {
                    
                    let results = try newJSONDecoder().decode([GetLaunchesResponseElement].self, from: data)
                    observer.onNext(results.map{ $0.toDomain()})
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
    
}

//enum GetLaunchesQueryKey: String, QueryKey {
//
//}
enum GetLaunchesQueryKey: String, QueryKey {
    var description: String { self.rawValue }
    case options
    case page
    case limit
}


// MARK: - GetLaunchesResponse
//struct GetLaunchesResponse: Codable {
//    let docs: [GetLaunchesResponseElement]
//    let totalDocs, limit, totalPages, page: Int
//    let pagingCounter: Int
//    let hasPrevPage, hasNextPage: Bool
//    let prevPage: Int?
//    let nextPage: Int?
//}

// MARK: - GetLaunchesResponseElement
struct GetLaunchesResponseElement: Codable {
    let fairings: Fairings?
    let links: Links
    let staticFireDateUTC: String?
    let staticFireDateUnix: Int?
    let net: Bool
    let window: Int?
    let rocket: Rocket
    let success: Bool?
    let failures: [Failure]
    let details: String?
    let crew, ships, capsules, payloads: [String]
    let launchpad: Launchpad
    let flightNumber: Int
    let name, dateUTC: String
    let dateUnix: Int
    let dateLocal: Date
    let datePrecision: DatePrecision
    let upcoming: Bool
    let cores: [Core]
    let autoUpdate, tbd: Bool
    let launchLibraryID: String?
    let id: String

    enum CodingKeys: String, CodingKey {
        case fairings, links
        case staticFireDateUTC = "static_fire_date_utc"
        case staticFireDateUnix = "static_fire_date_unix"
        case net, window, rocket, success, failures, details, crew, ships, capsules, payloads, launchpad
        case flightNumber = "flight_number"
        case name
        case dateUTC = "date_utc"
        case dateUnix = "date_unix"
        case dateLocal = "date_local"
        case datePrecision = "date_precision"
        case upcoming, cores
        case autoUpdate = "auto_update"
        case tbd
        case launchLibraryID = "launch_library_id"
        case id
    }
    
    func toDomain() -> Launch{
        Launch(name: name,
               number: String(flightNumber),
               date: dateUTC,
               details: details ?? "",
               iconData: nil,
               upcoming: upcoming)
    }
}

// MARK: - Core
struct Core: Codable {
    let core: String?
    let flight: Int?
    let gridfins, legs, reused, landingAttempt: Bool?
    let landingSuccess: Bool?
    let landingType: LandingType?
    let landpad: Landpad?

    enum CodingKeys: String, CodingKey {
        case core, flight, gridfins, legs, reused
        case landingAttempt = "landing_attempt"
        case landingSuccess = "landing_success"
        case landingType = "landing_type"
        case landpad
    }
}

enum LandingType: String, Codable {
    case asds = "ASDS"
    case ocean = "Ocean"
    case rtls = "RTLS"
}

enum Landpad: String, Codable {
    case the5E9E3032383Ecb267A34E7C7 = "5e9e3032383ecb267a34e7c7"
    case the5E9E3032383Ecb554034E7C9 = "5e9e3032383ecb554034e7c9"
    case the5E9E3032383Ecb6Bb234E7CA = "5e9e3032383ecb6bb234e7ca"
    case the5E9E3032383Ecb761634E7Cb = "5e9e3032383ecb761634e7cb"
    case the5E9E3032383Ecb90A834E7C8 = "5e9e3032383ecb90a834e7c8"
    case the5E9E3033383Ecb075134E7CD = "5e9e3033383ecb075134e7cd"
    case the5E9E3033383Ecbb9E534E7Cc = "5e9e3033383ecbb9e534e7cc"
}

enum DatePrecision: String, Codable {
    case day = "day"
    case hour = "hour"
    case month = "month"
}

// MARK: - Failure
struct Failure: Codable {
    let time: Int
    let altitude: Int?
    let reason: String
}

// MARK: - Fairings
struct Fairings: Codable {
    let reused, recoveryAttempt, recovered: Bool?
    let ships: [String]

    enum CodingKeys: String, CodingKey {
        case reused
        case recoveryAttempt = "recovery_attempt"
        case recovered, ships
    }
}

enum Launchpad: String, Codable {
    case the5E9E4501F509094Ba4566F84 = "5e9e4501f509094ba4566f84"
    case the5E9E4502F509092B78566F87 = "5e9e4502f509092b78566f87"
    case the5E9E4502F509094188566F88 = "5e9e4502f509094188566f88"
    case the5E9E4502F5090995De566F86 = "5e9e4502f5090995de566f86"
}

// MARK: - Links
struct Links: Codable {
    let patch: Patch
    let reddit: Reddit
    let flickr: Flickr
    let presskit: String?
    let webcast: String?
    let youtubeID: String?
    let article: String?
    let wikipedia: String?

    enum CodingKeys: String, CodingKey {
        case patch, reddit, flickr, presskit, webcast
        case youtubeID = "youtube_id"
        case article, wikipedia
    }
}

// MARK: - Flickr
struct Flickr: Codable {
    let small: [String]
    let original: [String]
}

// MARK: - Patch
struct Patch: Codable {
    let small, large: String?
}

// MARK: - Reddit
struct Reddit: Codable {
    let campaign: String?
    let launch: String?
    let media, recovery: String?
}

enum Rocket: String, Codable {
    case the5E9D0D95Eda69955F709D1Eb = "5e9d0d95eda69955f709d1eb"
    case the5E9D0D95Eda69973A809D1Ec = "5e9d0d95eda69973a809d1ec"
    case the5E9D0D95Eda69974Db09D1Ed = "5e9d0d95eda69974db09d1ed"
}


    
// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}



struct Launch{
    let name: String
    let number: String
    let date: String
    let details: String
    let iconData: Data?
    let upcoming: Bool

}
