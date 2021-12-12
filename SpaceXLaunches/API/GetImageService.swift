//
//  GetImageService.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 19/11/2021.
//

import Foundation
import RxSwift

enum GetImageFailureReason: Int, Error {
    case invalidURL = 1000
    case notFound = 1001
}


class GetImageService{
    
    static let shared = GetImageService()
        
    func getImage(path: String?) -> Observable<Data> {
        
        return Observable.create { (observer) -> Disposable in
            
            let  endpoint = Endpoint(baseUrl: path ?? "",
                                     path: "",
                                     queries: nil)
            
            guard let url = endpoint.url else {
                observer.onError(GetImageFailureReason.invalidURL)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                
                guard let data = data else {
                    observer.onError(error ?? GetImageFailureReason.notFound)
                    return
                }
                
                    debugLog("imageData: \(data.count)")
                    observer.onNext(data)
                    observer.onCompleted()
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
